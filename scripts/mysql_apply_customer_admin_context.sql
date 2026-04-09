USE kintok;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'status'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'activo' AFTER notes", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'source'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN source VARCHAR(50) NULL AFTER status", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'assigned_agent_id'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN assigned_agent_id INT NULL AFTER source", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'last_contact_at'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN last_contact_at DATETIME NULL AFTER assigned_agent_id", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'next_follow_up_at'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN next_follow_up_at DATETIME NULL AFTER last_contact_at", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'rfc'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN rfc VARCHAR(20) NULL AFTER next_follow_up_at", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'business_name'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN business_name VARCHAR(150) NULL AFTER rfc", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'billing_email'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN billing_email VARCHAR(150) NULL AFTER business_name", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_line'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN address_line VARCHAR(255) NULL AFTER billing_email", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'created_by'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN created_by INT NULL AFTER address_line", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @col_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'updated_by'
);
SET @sql := IF(@col_exists = 0, "ALTER TABLE customer ADD COLUMN updated_by INT NULL AFTER created_by", 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND INDEX_NAME = 'fk_customer_assigned_agent'
);
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE customer ADD KEY fk_customer_assigned_agent (assigned_agent_id)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND INDEX_NAME = 'fk_customer_created_by'
);
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE customer ADD KEY fk_customer_created_by (created_by)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND INDEX_NAME = 'fk_customer_updated_by'
);
SET @sql := IF(@idx_exists = 0, 'ALTER TABLE customer ADD KEY fk_customer_updated_by (updated_by)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @chk_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
  WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'customer' AND CONSTRAINT_NAME = 'chk_customer_status'
);
SET @sql := IF(@chk_exists = 0,
  "ALTER TABLE customer ADD CONSTRAINT chk_customer_status CHECK (status IN ('activo','inactivo','bloqueado'))",
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'fk_customer_assigned_agent'
);
SET @sql := IF(@fk_exists = 0,
  'ALTER TABLE customer ADD CONSTRAINT fk_customer_assigned_agent FOREIGN KEY (assigned_agent_id) REFERENCES `user`(id) ON DELETE SET NULL ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'fk_customer_created_by'
);
SET @sql := IF(@fk_exists = 0,
  'ALTER TABLE customer ADD CONSTRAINT fk_customer_created_by FOREIGN KEY (created_by) REFERENCES `user`(id) ON DELETE SET NULL ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_exists := (
  SELECT COUNT(*) FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
  WHERE CONSTRAINT_SCHEMA = DATABASE() AND CONSTRAINT_NAME = 'fk_customer_updated_by'
);
SET @sql := IF(@fk_exists = 0,
  'ALTER TABLE customer ADD CONSTRAINT fk_customer_updated_by FOREIGN KEY (updated_by) REFERENCES `user`(id) ON DELETE SET NULL ON UPDATE CASCADE',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DROP PROCEDURE IF EXISTS customer_list;
DROP PROCEDURE IF EXISTS customer_detail;
DROP PROCEDURE IF EXISTS customer_upsert;

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
END ;;

CREATE PROCEDURE customer_upsert(
    IN p_id INT,
    IN p_full_name VARCHAR(150),
    IN p_email VARCHAR(150),
    IN p_phone VARCHAR(50),
    IN p_customer_type VARCHAR(50),
    IN p_notes TEXT,
    IN p_status VARCHAR(20),
    IN p_source VARCHAR(50),
    IN p_assigned_agent_id INT,
    IN p_last_contact_at DATETIME,
    IN p_next_follow_up_at DATETIME,
    IN p_rfc VARCHAR(20),
    IN p_business_name VARCHAR(150),
    IN p_billing_email VARCHAR(150),
    IN p_address_line VARCHAR(255),
    IN p_actor_user_id INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_status VARCHAR(20);

    IF p_full_name IS NULL OR TRIM(p_full_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'full_name es requerido';
    END IF;

    SET v_status = COALESCE(NULLIF(TRIM(p_status), ''), 'activo');
    IF v_status NOT IN ('activo','inactivo','bloqueado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: activo, inactivo, bloqueado';
    END IF;

    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO customer (
            full_name,
            email,
            phone,
            customer_type,
            notes,
            status,
            source,
            assigned_agent_id,
            last_contact_at,
            next_follow_up_at,
            rfc,
            business_name,
            billing_email,
            address_line,
            created_by,
            updated_by
        )
        VALUES (
            TRIM(p_full_name),
            p_email,
            p_phone,
            p_customer_type,
            p_notes,
            v_status,
            p_source,
            p_assigned_agent_id,
            p_last_contact_at,
            p_next_follow_up_at,
            p_rfc,
            p_business_name,
            p_billing_email,
            p_address_line,
            p_actor_user_id,
            p_actor_user_id
        );

        SET v_customer_id = LAST_INSERT_ID();
    ELSE
        UPDATE customer
           SET full_name = TRIM(p_full_name),
               email = p_email,
               phone = p_phone,
               customer_type = p_customer_type,
               notes = p_notes,
               status = v_status,
               source = p_source,
               assigned_agent_id = p_assigned_agent_id,
               last_contact_at = p_last_contact_at,
               next_follow_up_at = p_next_follow_up_at,
               rfc = p_rfc,
               business_name = p_business_name,
               billing_email = p_billing_email,
               address_line = p_address_line,
               updated_by = p_actor_user_id
         WHERE id = p_id;

        IF ROW_COUNT() = 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente no encontrado';
        END IF;

        SET v_customer_id = p_id;
    END IF;

    SELECT v_customer_id AS customer_id;
END ;;

DELIMITER ;

SELECT 'customer_admin_context_applied' AS result;
