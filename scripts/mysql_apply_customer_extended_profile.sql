SET @db_name = DATABASE();

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'curp');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN curp VARCHAR(25) NULL AFTER rfc', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'razon_social');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN razon_social VARCHAR(180) NULL AFTER business_name', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'tipo_persona');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN tipo_persona VARCHAR(20) NULL AFTER razon_social', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_street');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_street VARCHAR(150) NULL AFTER address_line', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_number');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_number VARCHAR(30) NULL AFTER address_street', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_neighborhood');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_neighborhood VARCHAR(120) NULL AFTER address_number', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_city');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_city VARCHAR(120) NULL AFTER address_neighborhood', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_state');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_state VARCHAR(120) NULL AFTER address_city', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_zip');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_zip VARCHAR(20) NULL AFTER address_state', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'address_country');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN address_country VARCHAR(120) NULL AFTER address_zip', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'preferred_currency');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN preferred_currency VARCHAR(10) NULL AFTER address_country', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'interest_type');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN interest_type VARCHAR(20) NULL AFTER preferred_currency', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'interest_zones');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN interest_zones TEXT NULL AFTER interest_type', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @exists = (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = @db_name AND TABLE_NAME = 'customer' AND COLUMN_NAME = 'interest_property_types');
SET @sql = IF(@exists = 0, 'ALTER TABLE customer ADD COLUMN interest_property_types TEXT NULL AFTER interest_zones', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

DROP PROCEDURE IF EXISTS customer_list;
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
        OR c.rfc LIKE CONCAT('%', p_search_text, '%')
        OR c.curp LIKE CONCAT('%', p_search_text, '%')
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
        c.rfc,
        c.curp,
        c.business_name,
        c.razon_social,
        c.tipo_persona,
        c.billing_email,
        c.address_line,
        c.address_city,
        c.address_state,
        c.address_country,
        c.preferred_currency,
        c.interest_type,
        c.interest_zones,
        c.interest_property_types,
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
        OR c.rfc LIKE CONCAT('%', p_search_text, '%')
        OR c.curp LIKE CONCAT('%', p_search_text, '%')
    )
      AND (p_status IS NULL OR p_status = '' OR c.status = p_status)
      AND (p_customer_type IS NULL OR p_customer_type = '' OR c.customer_type = p_customer_type)
      AND (p_assigned_agent_id IS NULL OR c.assigned_agent_id = p_assigned_agent_id)
    ORDER BY c.created_at DESC, c.id DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_detail;
DELIMITER ;;
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
        c.curp,
        c.business_name,
        c.razon_social,
        c.tipo_persona,
        c.billing_email,
        c.address_line,
        c.address_street,
        c.address_number,
        c.address_neighborhood,
        c.address_city,
        c.address_state,
        c.address_zip,
        c.address_country,
        c.preferred_currency,
        c.interest_type,
        c.interest_zones,
        c.interest_property_types,
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
DELIMITER ;

DROP PROCEDURE IF EXISTS customer_upsert;
DELIMITER ;;
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
    IN p_curp VARCHAR(25),
    IN p_business_name VARCHAR(150),
    IN p_razon_social VARCHAR(180),
    IN p_tipo_persona VARCHAR(20),
    IN p_billing_email VARCHAR(150),
    IN p_address_line VARCHAR(255),
    IN p_address_street VARCHAR(150),
    IN p_address_number VARCHAR(30),
    IN p_address_neighborhood VARCHAR(120),
    IN p_address_city VARCHAR(120),
    IN p_address_state VARCHAR(120),
    IN p_address_zip VARCHAR(20),
    IN p_address_country VARCHAR(120),
    IN p_preferred_currency VARCHAR(10),
    IN p_interest_type VARCHAR(20),
    IN p_interest_zones TEXT,
    IN p_interest_property_types TEXT,
    IN p_actor_user_id INT
)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_status VARCHAR(20);
    DECLARE v_tipo_persona VARCHAR(20);
    DECLARE v_interest_type VARCHAR(20);
    DECLARE v_preferred_currency VARCHAR(10);

    IF p_full_name IS NULL OR TRIM(p_full_name) = '' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'full_name es requerido';
    END IF;

    SET v_status = COALESCE(NULLIF(TRIM(p_status), ''), 'activo');
    IF v_status NOT IN ('activo','inactivo','bloqueado') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'status inválido. Usa: activo, inactivo, bloqueado';
    END IF;

    SET v_tipo_persona = LOWER(NULLIF(TRIM(COALESCE(p_tipo_persona, '')), ''));
    IF v_tipo_persona IS NOT NULL AND v_tipo_persona NOT IN ('fisica', 'moral') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'tipo_persona inválido. Usa: fisica o moral';
    END IF;

    SET v_interest_type = LOWER(NULLIF(TRIM(COALESCE(p_interest_type, '')), ''));
    IF v_interest_type IS NOT NULL AND v_interest_type NOT IN ('compra', 'renta', 'venta') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'interest_type inválido. Usa: compra, renta o venta';
    END IF;

    SET v_preferred_currency = UPPER(NULLIF(TRIM(COALESCE(p_preferred_currency, '')), ''));
    IF v_preferred_currency IS NOT NULL AND v_preferred_currency NOT IN ('MXN', 'USD') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'preferred_currency inválido. Usa: MXN o USD';
    END IF;

    -- Silently nullify assigned_agent_id if the user doesn't exist
    IF p_assigned_agent_id IS NOT NULL THEN
        SET p_assigned_agent_id = (
            SELECT id FROM `user` WHERE id = p_assigned_agent_id LIMIT 1
        );
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
            curp,
            business_name,
            razon_social,
            tipo_persona,
            billing_email,
            address_line,
            address_street,
            address_number,
            address_neighborhood,
            address_city,
            address_state,
            address_zip,
            address_country,
            preferred_currency,
            interest_type,
            interest_zones,
            interest_property_types,
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
            p_curp,
            p_business_name,
            p_razon_social,
            v_tipo_persona,
            p_billing_email,
            p_address_line,
            p_address_street,
            p_address_number,
            p_address_neighborhood,
            p_address_city,
            p_address_state,
            p_address_zip,
            p_address_country,
            v_preferred_currency,
            v_interest_type,
            p_interest_zones,
            p_interest_property_types,
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
               curp = p_curp,
               business_name = p_business_name,
               razon_social = p_razon_social,
               tipo_persona = v_tipo_persona,
               billing_email = p_billing_email,
               address_line = p_address_line,
               address_street = p_address_street,
               address_number = p_address_number,
               address_neighborhood = p_address_neighborhood,
               address_city = p_address_city,
               address_state = p_address_state,
               address_zip = p_address_zip,
               address_country = p_address_country,
               preferred_currency = v_preferred_currency,
               interest_type = v_interest_type,
               interest_zones = p_interest_zones,
               interest_property_types = p_interest_property_types,
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

SELECT 'customer_extended_profile_applied' AS result;
