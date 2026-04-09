USE kintok;

-- Mantener columna resumen en lead_contact para compatibilidad (última nota)
SET @col_exists := (
    SELECT COUNT(*)
    FROM INFORMATION_SCHEMA.COLUMNS
    WHERE TABLE_SCHEMA = DATABASE()
      AND TABLE_NAME = 'lead_contact'
      AND COLUMN_NAME = 'lead_notes'
);
SET @sql := IF(
    @col_exists = 0,
    'ALTER TABLE lead_contact ADD COLUMN lead_notes TEXT NULL AFTER conversion_notes',
    'SELECT 1'
);
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- Crear tabla de historial de notas si no existe
CREATE TABLE IF NOT EXISTS lead_contact_note (
    id INT NOT NULL AUTO_INCREMENT,
    lead_contact_id INT NOT NULL,
    note TEXT NOT NULL,
    created_by INT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_lead_contact_note_lead_created (lead_contact_id, created_at),
    KEY fk_lead_contact_note_created_by (created_by),
    CONSTRAINT fk_lead_contact_note_created_by
        FOREIGN KEY (created_by) REFERENCES user(id)
        ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_lead_contact_note_lead
        FOREIGN KEY (lead_contact_id) REFERENCES lead_contact(id)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP PROCEDURE IF EXISTS lead_contact_list_with_customer;
DROP PROCEDURE IF EXISTS lead_contact_notes_update;
DROP PROCEDURE IF EXISTS lead_contact_notes_list;

DELIMITER ;;

CREATE PROCEDURE lead_contact_list_with_customer(
    IN p_status VARCHAR(50),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;

    IF p_page_number IS NULL OR p_page_number < 1 THEN
        SET p_page_number = 1;
    END IF;

    IF p_page_size IS NULL OR p_page_size < 1 THEN
        SET p_page_size = 10;
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    IF p_status IS NOT NULL AND p_status <> '' THEN
        SET p_status = LOWER(p_status);
        IF p_status NOT IN ('nuevo','contactado','calificado','cerrado') THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'status inválido. Usa: nuevo, contactado, calificado, cerrado';
        END IF;
    END IF;

    SELECT COUNT(*)
      INTO v_total_records
    FROM lead_contact l
    WHERE (
        p_status IS NULL
        OR p_status = ''
        OR l.status = p_status
    );

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        l.id,
        l.property_id,
        p.title AS property_title,
        l.name,
        l.email,
        l.phone,
        l.comments,
        l.status,
        l.customer_id,
        c.full_name AS customer_name,
        c.email AS customer_email,
        c.phone AS customer_phone,
        CASE
            WHEN l.customer_id IS NULL THEN 0
            ELSE 1
        END AS is_converted,
        l.changed_by,
        l.converted_by,
        l.converted_at,
        l.conversion_notes,
        l.lead_notes,
        (
            SELECT COUNT(*)
            FROM lead_contact_note ln
            WHERE ln.lead_contact_id = l.id
        ) AS notes_count,
        (
            SELECT ln.note
            FROM lead_contact_note ln
            WHERE ln.lead_contact_id = l.id
            ORDER BY ln.created_at DESC, ln.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT ln.created_at
            FROM lead_contact_note ln
            WHERE ln.lead_contact_id = l.id
            ORDER BY ln.created_at DESC, ln.id DESC
            LIMIT 1
        ) AS last_note_at,
        l.created_at,
        l.updated_at
    FROM lead_contact l
    INNER JOIN property p ON p.id = l.property_id
    LEFT JOIN customer c ON c.id = l.customer_id
    WHERE (
        p_status IS NULL
        OR p_status = ''
        OR l.status = p_status
    )
    ORDER BY l.created_at DESC, l.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;

CREATE PROCEDURE lead_contact_notes_update(
    IN p_lead_contact_id INT,
    IN p_note TEXT,
    IN p_created_by INT
)
BEGIN
    DECLARE v_lead_exists INT;
    DECLARE v_note_id INT;
    DECLARE v_note_trimmed TEXT;

    IF p_lead_contact_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id es requerido';
    END IF;

    SET v_note_trimmed = TRIM(COALESCE(p_note, ''));
    IF v_note_trimmed = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'note es requerida';
    END IF;

    SELECT id INTO v_lead_exists
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_lead_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    INSERT INTO lead_contact_note (
        lead_contact_id,
        note,
        created_by
    ) VALUES (
        p_lead_contact_id,
        v_note_trimmed,
        p_created_by
    );

    SET v_note_id = LAST_INSERT_ID();

    UPDATE lead_contact
       SET lead_notes = v_note_trimmed,
           changed_by = p_created_by,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT
        n.id AS note_id,
        n.lead_contact_id,
        n.note,
        n.created_by,
        u.full_name AS created_by_name,
        n.created_at
    FROM lead_contact_note n
    LEFT JOIN user u ON u.id = n.created_by
    WHERE n.id = v_note_id
    LIMIT 1;
END ;;

CREATE PROCEDURE lead_contact_notes_list(
    IN p_lead_contact_id INT
)
BEGIN
    DECLARE v_lead_exists INT;

    IF p_lead_contact_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id es requerido';
    END IF;

    SELECT id INTO v_lead_exists
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_lead_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    SELECT
        n.id AS note_id,
        n.lead_contact_id,
        n.note,
        n.created_by,
        u.full_name AS created_by_name,
        n.created_at
    FROM lead_contact_note n
    LEFT JOIN user u ON u.id = n.created_by
    WHERE n.lead_contact_id = p_lead_contact_id
    ORDER BY n.created_at DESC, n.id DESC;
END ;;

DELIMITER ;

SELECT 'lead_notes_applied' AS result;
