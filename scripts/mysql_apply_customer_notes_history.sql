USE kintok;

CREATE TABLE IF NOT EXISTS customer_note (
  id INT NOT NULL AUTO_INCREMENT,
  customer_id INT NOT NULL,
  note TEXT NOT NULL,
  created_by INT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_customer_note_customer_created (customer_id, created_at),
  KEY fk_customer_note_created_by (created_by),
  CONSTRAINT fk_customer_note_created_by FOREIGN KEY (created_by)
    REFERENCES `user` (id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_customer_note_customer FOREIGN KEY (customer_id)
    REFERENCES customer (id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP PROCEDURE IF EXISTS customer_list;
DROP PROCEDURE IF EXISTS customer_detail;
DROP PROCEDURE IF EXISTS customer_note_add;
DROP PROCEDURE IF EXISTS customer_note_list;

DELIMITER ;;

CREATE PROCEDURE customer_list(
    IN p_search_text VARCHAR(150),
    IN p_status VARCHAR(20),
    IN p_customer_type VARCHAR(50),
    IN p_assigned_agent_id INT,
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

    IF p_status IS NOT NULL AND p_status <> '' AND p_status NOT IN ('activo','inactivo','bloqueado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: activo, inactivo, bloqueado';
    END IF;

    SET v_offset = (p_page_number - 1) * p_page_size;

    SELECT COUNT(*)
      INTO v_total_records
    FROM customer c
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
    )
      AND (p_status IS NULL OR p_status = '' OR c.status = p_status)
      AND (p_customer_type IS NULL OR p_customer_type = '' OR c.customer_type = p_customer_type)
      AND (p_assigned_agent_id IS NULL OR c.assigned_agent_id = p_assigned_agent_id);

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records AS total_records,
        p_page_number AS page_number,
        p_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        c.id,
        c.full_name,
        c.email,
        c.phone,
        c.customer_type,
        c.status,
        c.source,
        c.assigned_agent_id,
        ua.full_name AS assigned_agent_name,
        c.last_contact_at,
        c.next_follow_up_at,
        c.notes,
        (
            SELECT COUNT(*)
            FROM customer_note cn
            WHERE cn.customer_id = c.id
        ) AS notes_count,
        (
            SELECT cn.note
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT cn.created_at
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note_at,
        (
            SELECT COUNT(*)
            FROM lead_contact lc
            WHERE lc.customer_id = c.id
              AND lc.status <> 'cerrado'
        ) AS open_leads_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
              AND pt.status = 'activa'
        ) AS active_transactions_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_transactions_count,
        (
            SELECT COALESCE(SUM(fn_convert_to_base(COALESCE(pt.final_price, 0), pt.currency, 'MXN')), 0)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_spent_or_rented_mxn,
        (
            SELECT COUNT(*)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status = 'atrasado'
        ) AS overdue_payments_count,
        (
            SELECT MIN(rp.due_date)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status IN ('pendiente','parcial','atrasado')
        ) AS next_due_date,
        c.created_at,
        c.updated_at
    FROM customer c
    LEFT JOIN `user` ua ON ua.id = c.assigned_agent_id
    WHERE (
        p_search_text IS NULL
        OR p_search_text = ''
        OR c.full_name LIKE CONCAT('%', p_search_text, '%')
        OR c.email LIKE CONCAT('%', p_search_text, '%')
        OR c.phone LIKE CONCAT('%', p_search_text, '%')
    )
      AND (p_status IS NULL OR p_status = '' OR c.status = p_status)
      AND (p_customer_type IS NULL OR p_customer_type = '' OR c.customer_type = p_customer_type)
      AND (p_assigned_agent_id IS NULL OR c.assigned_agent_id = p_assigned_agent_id)
    ORDER BY c.created_at DESC, c.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;

CREATE PROCEDURE customer_detail(
    IN p_customer_id INT
)
BEGIN
    DECLARE v_exists INT;

    SELECT id INTO v_exists
    FROM customer
    WHERE id = p_customer_id
    LIMIT 1;

    IF v_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    SELECT
        c.id,
        c.full_name,
        c.email,
        c.phone,
        c.customer_type,
        c.status,
        c.source,
        c.assigned_agent_id,
        ua.full_name AS assigned_agent_name,
        c.last_contact_at,
        c.next_follow_up_at,
        c.rfc,
        c.business_name,
        c.billing_email,
        c.address_line,
        c.notes,
        (
            SELECT COUNT(*)
            FROM customer_note cn
            WHERE cn.customer_id = c.id
        ) AS notes_count,
        (
            SELECT cn.note
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note,
        (
            SELECT cn.created_at
            FROM customer_note cn
            WHERE cn.customer_id = c.id
            ORDER BY cn.created_at DESC, cn.id DESC
            LIMIT 1
        ) AS last_note_at,
        c.created_by,
        ucb.full_name AS created_by_name,
        c.updated_by,
        uub.full_name AS updated_by_name,
        (
            SELECT COUNT(*)
            FROM lead_contact lc
            WHERE lc.customer_id = c.id
              AND lc.status <> 'cerrado'
        ) AS open_leads_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
              AND pt.status = 'activa'
        ) AS active_transactions_count,
        (
            SELECT COUNT(*)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_transactions_count,
        (
            SELECT COALESCE(SUM(fn_convert_to_base(COALESCE(pt.final_price, 0), pt.currency, 'MXN')), 0)
            FROM property_transaction pt
            WHERE pt.customer_id = c.id
        ) AS total_spent_or_rented_mxn,
        (
            SELECT COUNT(*)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status = 'atrasado'
        ) AS overdue_payments_count,
        (
            SELECT COALESCE(SUM(GREATEST((rp.amount_due + COALESCE(rp.late_fee, 0)) - rp.amount_paid, 0)), 0)
            FROM rent_payment rp
            INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
            WHERE pt.customer_id = c.id
              AND rp.status IN ('pendiente','parcial','atrasado')
        ) AS outstanding_balance_mxn,
        c.created_at,
        c.updated_at
    FROM customer c
    LEFT JOIN `user` ua ON ua.id = c.assigned_agent_id
    LEFT JOIN `user` ucb ON ucb.id = c.created_by
    LEFT JOIN `user` uub ON uub.id = c.updated_by
    WHERE c.id = p_customer_id
    LIMIT 1;

    SELECT
        lc.id AS lead_contact_id,
        lc.property_id,
        p.title AS property_title,
        lc.name,
        lc.email,
        lc.phone,
        lc.status,
        lc.comments,
        lc.created_at,
        lc.updated_at
    FROM lead_contact lc
    LEFT JOIN property p ON p.id = lc.property_id
    WHERE lc.customer_id = p_customer_id
    ORDER BY lc.created_at DESC, lc.id DESC;

    SELECT
        pt.id AS transaction_id,
        pt.property_id,
        p.title AS property_title,
        pt.transaction_type,
        pt.status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.cancelled_at,
        pt.cancel_reason,
        pt.created_at
    FROM property_transaction pt
    LEFT JOIN property p ON p.id = pt.property_id
    WHERE pt.customer_id = p_customer_id
    ORDER BY pt.transaction_date DESC, pt.id DESC;

    SELECT
        rp.id AS payment_id,
        rp.transaction_id,
        rp.period_year,
        rp.period_month,
        rp.due_date,
        rp.amount_due,
        rp.amount_paid,
        GREATEST((rp.amount_due + COALESCE(rp.late_fee, 0)) - rp.amount_paid, 0) AS amount_pending,
        rp.currency,
        rp.status,
        rp.late_fee,
        rp.paid_at,
        rp.notes,
        rp.updated_at
    FROM rent_payment rp
    INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
    WHERE pt.customer_id = p_customer_id
    ORDER BY rp.due_date DESC, rp.id DESC;

    SELECT
        cn.id AS note_id,
        cn.customer_id,
        cn.note,
        cn.created_by,
        u.full_name AS created_by_name,
        cn.created_at
    FROM customer_note cn
    LEFT JOIN `user` u ON u.id = cn.created_by
    WHERE cn.customer_id = p_customer_id
    ORDER BY cn.created_at DESC, cn.id DESC;
END ;;

CREATE PROCEDURE customer_note_add(
    IN p_customer_id INT,
    IN p_note TEXT,
    IN p_created_by INT
)
BEGIN
    DECLARE v_customer_exists INT;
    DECLARE v_note_id INT;
    DECLARE v_note_trimmed TEXT;

    IF p_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'customer_id es requerido';
    END IF;

    SET v_note_trimmed = TRIM(COALESCE(p_note, ''));
    IF v_note_trimmed = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'note es requerida';
    END IF;

    SELECT id INTO v_customer_exists
    FROM customer
    WHERE id = p_customer_id
    LIMIT 1;

    IF v_customer_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    INSERT INTO customer_note (customer_id, note, created_by)
    VALUES (p_customer_id, v_note_trimmed, p_created_by);

    SET v_note_id = LAST_INSERT_ID();

    UPDATE customer
       SET notes = v_note_trimmed,
           updated_by = p_created_by,
           updated_at = NOW()
    WHERE id = p_customer_id;

    SELECT
        cn.id AS note_id,
        cn.customer_id,
        cn.note,
        cn.created_by,
        u.full_name AS created_by_name,
        cn.created_at
    FROM customer_note cn
    LEFT JOIN `user` u ON u.id = cn.created_by
    WHERE cn.id = v_note_id
    LIMIT 1;
END ;;

CREATE PROCEDURE customer_note_list(
    IN p_customer_id INT
)
BEGIN
    DECLARE v_customer_exists INT;

    IF p_customer_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'customer_id es requerido';
    END IF;

    SELECT id INTO v_customer_exists
    FROM customer
    WHERE id = p_customer_id
    LIMIT 1;

    IF v_customer_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    SELECT
        cn.id AS note_id,
        cn.customer_id,
        cn.note,
        cn.created_by,
        u.full_name AS created_by_name,
        cn.created_at
    FROM customer_note cn
    LEFT JOIN `user` u ON u.id = cn.created_by
    WHERE cn.customer_id = p_customer_id
    ORDER BY cn.created_at DESC, cn.id DESC;
END ;;

DELIMITER ;

SELECT 'customer_notes_history_applied' AS result;
