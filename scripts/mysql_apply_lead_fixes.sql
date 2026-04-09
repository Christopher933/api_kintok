USE kintok;

-- Normalizar estatus legacy antes de constraints
UPDATE lead_contact
   SET status = CASE
                    WHEN LOWER(status) IN ('new') THEN 'nuevo'
                    WHEN LOWER(status) IN ('contacted') THEN 'contactado'
                    WHEN LOWER(status) IN ('qualified') THEN 'calificado'
                    WHEN LOWER(status) IN ('closed') THEN 'cerrado'
                    WHEN LOWER(status) IN ('nueva') THEN 'nuevo'
                    ELSE LOWER(status)
                END;

ALTER TABLE lead_contact
  ADD COLUMN changed_by INT NULL AFTER status,
  ADD COLUMN converted_by INT NULL AFTER changed_by,
  ADD COLUMN converted_at DATETIME NULL AFTER converted_by,
  ADD COLUMN conversion_notes TEXT NULL AFTER converted_at,
  ADD COLUMN lead_notes TEXT NULL AFTER conversion_notes,
  ADD KEY fk_lead_contact_changed_by (changed_by),
  ADD KEY fk_lead_contact_converted_by (converted_by),
  ADD CONSTRAINT chk_lead_contact_status CHECK (status IN ('nuevo','contactado','calificado','cerrado')),
  ADD CONSTRAINT fk_lead_contact_changed_by FOREIGN KEY (changed_by) REFERENCES user(id) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT fk_lead_contact_converted_by FOREIGN KEY (converted_by) REFERENCES user(id) ON DELETE SET NULL ON UPDATE CASCADE;

DROP PROCEDURE IF EXISTS lead_contact_list_with_customer;
DROP PROCEDURE IF EXISTS lead_contact_register;
DROP PROCEDURE IF EXISTS lead_contact_status_update;
DROP PROCEDURE IF EXISTS lead_contact_notes_update;
DROP PROCEDURE IF EXISTS lead_contact_convert_to_customer;

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

CREATE PROCEDURE lead_contact_register(
    IN p_property_id INT,
    IN p_name VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(50),
    IN p_comments TEXT
)
BEGIN
    DECLARE v_property_exists INT;
    DECLARE v_recent_duplicate_id INT;

    IF p_property_id IS NULL OR p_name IS NULL OR p_email IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'property_id, name y email son requeridos';
    END IF;

    IF p_email NOT REGEXP '^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de email inválido';
    END IF;

    IF p_phone IS NOT NULL AND p_phone <> '' AND p_phone NOT REGEXP '^[0-9+()\\-[:space:]]{7,20}$' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Formato de teléfono inválido';
    END IF;

    SELECT id
      INTO v_property_exists
      FROM property
     WHERE id = p_property_id
     LIMIT 1;

    IF v_property_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Propiedad no encontrada';
    END IF;

    SET p_email = LOWER(TRIM(p_email));

    SELECT id
      INTO v_recent_duplicate_id
      FROM lead_contact
     WHERE property_id = p_property_id
       AND LOWER(email) = p_email
       AND created_at >= DATE_SUB(NOW(), INTERVAL 24 HOUR)
     ORDER BY id DESC
     LIMIT 1;

    IF v_recent_duplicate_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Ya existe un lead reciente con ese email para esta propiedad (últimas 24h)';
    END IF;

    INSERT INTO lead_contact (
        property_id,
        name,
        email,
        phone,
        comments,
        status,
        created_at,
        updated_at
    )
    VALUES (
        p_property_id,
        p_name,
        p_email,
        p_phone,
        p_comments,
        'nuevo',
        NOW(),
        NOW()
    );

    SELECT LAST_INSERT_ID() AS lead_contact_id;
END ;;

CREATE PROCEDURE lead_contact_status_update(
    IN p_lead_contact_id INT,
    IN p_status VARCHAR(50),
    IN p_changed_by INT
)
BEGIN
    DECLARE v_lead_exists INT;

    IF p_lead_contact_id IS NULL OR p_status IS NULL OR p_status = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id y status son requeridos';
    END IF;

    SET p_status = LOWER(TRIM(p_status));
    IF p_status NOT IN ('nuevo','contactado','calificado','cerrado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: nuevo, contactado, calificado, cerrado';
    END IF;

    SELECT id INTO v_lead_exists
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_lead_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    UPDATE lead_contact
       SET status = p_status,
           changed_by = p_changed_by,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT ROW_COUNT() AS affected_rows;
END ;;

CREATE PROCEDURE lead_contact_notes_update(
    IN p_lead_contact_id INT,
    IN p_notes TEXT,
    IN p_changed_by INT
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

    UPDATE lead_contact
       SET lead_notes = p_notes,
           changed_by = p_changed_by,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT
        p_lead_contact_id AS lead_contact_id,
        lead_notes,
        changed_by,
        updated_at
    FROM lead_contact
    WHERE id = p_lead_contact_id
    LIMIT 1;
END ;;

CREATE PROCEDURE lead_contact_convert_to_customer(
    IN p_lead_contact_id INT,
    IN p_customer_type VARCHAR(50),
    IN p_notes TEXT,
    IN p_converted_by INT
)
BEGIN
    DECLARE v_name VARCHAR(150);
    DECLARE v_email VARCHAR(150);
    DECLARE v_phone VARCHAR(50);
    DECLARE v_comments TEXT;
    DECLARE v_status VARCHAR(50);
    DECLARE v_customer_id INT;

    IF p_lead_contact_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'lead_contact_id es requerido';
    END IF;

    SELECT name, LOWER(email), phone, comments, status
      INTO v_name, v_email, v_phone, v_comments, v_status
      FROM lead_contact
     WHERE id = p_lead_contact_id
     LIMIT 1;

    IF v_name IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    IF v_status = 'cerrado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El lead ya está cerrado';
    END IF;

    SELECT id
      INTO v_customer_id
      FROM customer
     WHERE LOWER(email) = v_email
     ORDER BY id DESC
     LIMIT 1;

    IF v_customer_id IS NULL THEN
        INSERT INTO customer (
            full_name, email, phone, customer_type, notes
        ) VALUES (
            v_name,
            v_email,
            v_phone,
            COALESCE(NULLIF(TRIM(p_customer_type), ''), 'comprador'),
            COALESCE(NULLIF(TRIM(p_notes), ''), v_comments)
        );
        SET v_customer_id = LAST_INSERT_ID();
    ELSE
        UPDATE customer
           SET full_name = COALESCE(NULLIF(TRIM(v_name), ''), full_name),
               phone = COALESCE(NULLIF(TRIM(v_phone), ''), phone),
               customer_type = COALESCE(NULLIF(TRIM(p_customer_type), ''), customer_type),
               notes = COALESCE(NULLIF(TRIM(p_notes), ''), notes)
         WHERE id = v_customer_id;
    END IF;

    UPDATE lead_contact
       SET customer_id = v_customer_id,
           status = 'cerrado',
           changed_by = p_converted_by,
           converted_by = p_converted_by,
           converted_at = NOW(),
           conversion_notes = p_notes,
           updated_at = NOW()
     WHERE id = p_lead_contact_id;

    SELECT
        p_lead_contact_id AS lead_contact_id,
        v_customer_id AS customer_id,
        'cerrado' AS status,
        1 AS is_converted;
END ;;

DELIMITER ;

SELECT 'lead_fixes_applied' AS result;
