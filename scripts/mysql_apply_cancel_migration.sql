USE kintok;

-- ------------------------------------------------------------
-- Schema: property_transaction
-- ------------------------------------------------------------

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'property_transaction'
        AND COLUMN_NAME = 'status'
    ),
    'SELECT 1',
    "ALTER TABLE property_transaction ADD COLUMN status varchar(20) NOT NULL DEFAULT 'activa' AFTER transaction_type"
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'property_transaction'
        AND COLUMN_NAME = 'cancelled_at'
    ),
    'SELECT 1',
    "ALTER TABLE property_transaction ADD COLUMN cancelled_at datetime NULL AFTER created_at"
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'property_transaction'
        AND COLUMN_NAME = 'cancelled_by'
    ),
    'SELECT 1',
    "ALTER TABLE property_transaction ADD COLUMN cancelled_by int NULL AFTER cancelled_at"
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'property_transaction'
        AND COLUMN_NAME = 'cancel_reason'
    ),
    'SELECT 1',
    "ALTER TABLE property_transaction ADD COLUMN cancel_reason text NULL AFTER cancelled_by"
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.STATISTICS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'property_transaction'
        AND INDEX_NAME = 'fk_property_transaction_cancelled_by_user'
    ),
    'SELECT 1',
    "ALTER TABLE property_transaction ADD INDEX fk_property_transaction_cancelled_by_user (cancelled_by)"
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
      WHERE CONSTRAINT_SCHEMA = DATABASE()
        AND TABLE_NAME = 'property_transaction'
        AND CONSTRAINT_NAME = 'fk_property_transaction_cancelled_by_user'
    ),
    'SELECT 1',
    "ALTER TABLE property_transaction ADD CONSTRAINT fk_property_transaction_cancelled_by_user FOREIGN KEY (cancelled_by) REFERENCES user(id) ON DELETE SET NULL ON UPDATE CASCADE"
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'property_transaction'
        AND CONSTRAINT_NAME = 'chk_property_transaction_status'
        AND CONSTRAINT_TYPE = 'CHECK'
    ),
    'SELECT 1',
    "ALTER TABLE property_transaction ADD CONSTRAINT chk_property_transaction_status CHECK (status IN ('activa','cancelada','cerrada'))"
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- Recreate idx_property_transaction_type as (transaction_type, status)
SET @idx_has_status = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'property_transaction'
    AND INDEX_NAME = 'idx_property_transaction_type'
    AND COLUMN_NAME = 'status'
);

SET @idx_exists = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'property_transaction'
    AND INDEX_NAME = 'idx_property_transaction_type'
);

SET @sql = IF(@idx_exists > 0 AND @idx_has_status = 0, 'ALTER TABLE property_transaction DROP INDEX idx_property_transaction_type', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_exists = (
  SELECT COUNT(*)
  FROM INFORMATION_SCHEMA.STATISTICS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'property_transaction'
    AND INDEX_NAME = 'idx_property_transaction_type'
);

SET @sql = IF(@idx_exists = 0, 'ALTER TABLE property_transaction ADD INDEX idx_property_transaction_type (transaction_type, status)', 'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- ------------------------------------------------------------
-- Schema: rent_payment check status includes cancelado
-- ------------------------------------------------------------

SET @sql = (
  SELECT IF(
    EXISTS (
      SELECT 1
      FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
      WHERE TABLE_SCHEMA = DATABASE()
        AND TABLE_NAME = 'rent_payment'
        AND CONSTRAINT_NAME = 'chk_rent_payment_status'
        AND CONSTRAINT_TYPE = 'CHECK'
    ),
    'ALTER TABLE rent_payment DROP CHECK chk_rent_payment_status',
    'SELECT 1'
  )
);
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

ALTER TABLE rent_payment
  ADD CONSTRAINT chk_rent_payment_status
  CHECK (status IN ('pendiente','pagado','parcial','atrasado','cancelado'));

-- ------------------------------------------------------------
-- Procedures
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS property_get_detail;
DROP PROCEDURE IF EXISTS property_transaction_list_by_customer;
DROP PROCEDURE IF EXISTS property_transaction_list_by_property;
DROP PROCEDURE IF EXISTS property_transaction_register;
DROP PROCEDURE IF EXISTS property_transaction_cancel;
DROP PROCEDURE IF EXISTS rent_payment_update;

DELIMITER ;;

CREATE PROCEDURE property_get_detail(IN p_property_id INT)
BEGIN
    SELECT
        p.*,
        pt.name  AS property_type,
        o.name   AS operation,
        c.name   AS city,
        z.name   AS zone,
        pps.name AS publication_status,
        pbs.name AS business_status,
        fn_format_price(p.price_value, p.currency) AS formatted_price
    FROM property p
    INNER JOIN property_type               pt  ON pt.id  = p.property_type_id
    INNER JOIN operation                   o   ON o.id   = p.operation_id
    INNER JOIN city                        c   ON c.id   = p.city_id
    INNER JOIN zone                        z   ON z.id   = p.zone_id
    INNER JOIN property_publication_status pps ON pps.id = p.publication_status_id
    INNER JOIN property_business_status    pbs ON pbs.id = p.business_status_id
    WHERE p.id = p_property_id;

    SELECT * FROM property_industrial WHERE property_id = p_property_id;
    SELECT * FROM property_residential WHERE property_id = p_property_id;
    SELECT * FROM property_land WHERE property_id = p_property_id;

    SELECT a.id, a.name
      FROM property_amenity pa
      INNER JOIN amenity a ON a.id = pa.amenity_id
     WHERE pa.property_id = p_property_id
     ORDER BY a.name;

    SELECT id, property_id, image_url, sort_order
      FROM property_image
     WHERE property_id = p_property_id
     ORDER BY sort_order, id;

    SELECT ag.id, ag.full_name, ag.email, ag.phone, ag.bio, ag.image_url
      FROM property_agent pag
      INNER JOIN agent ag ON ag.id = pag.agent_id
     WHERE pag.property_id = p_property_id
       AND ag.is_active = b'1'
     ORDER BY ag.full_name;

    SELECT
        pt.id              AS transaction_id,
        pt.transaction_type,
        pt.status          AS transaction_status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.created_at,
        pt.cancelled_at,
        pt.cancelled_by,
        pt.cancel_reason,
        c.id               AS customer_id,
        c.full_name        AS customer_name,
        c.email            AS customer_email,
        c.phone            AS customer_phone,
        c.customer_type,
        tr_res.deposit_amount      AS reservation_deposit,
        tr_res.deposit_currency    AS reservation_currency,
        tr_res.expires_at          AS reservation_expires_at,
        tr_res.applied_to_sale     AS reservation_applied_to_sale,
        tr_ren.start_date          AS rental_start_date,
        tr_ren.end_date            AS rental_end_date,
        tr_ren.monthly_rent        AS rental_monthly_rent,
        tr_ren.deposit_amount      AS rental_deposit,
        tr_ren.deposit_currency    AS rental_deposit_currency,
        tr_ren.payment_day         AS rental_payment_day,
        tr_ren.auto_renew          AS rental_auto_renew
    FROM property_transaction pt
    INNER JOIN customer c ON c.id = pt.customer_id
    LEFT JOIN transaction_reservation tr_res ON tr_res.transaction_id = pt.id
    LEFT JOIN transaction_rental      tr_ren ON tr_ren.transaction_id = pt.id
    WHERE pt.property_id = p_property_id
      AND pt.status = 'activa'
    ORDER BY pt.transaction_date DESC, pt.id DESC
    LIMIT 1;

    SELECT
        rp.id,
        rp.period_year,
        rp.period_month,
        rp.due_date,
        rp.amount_due,
        rp.amount_paid,
        rp.currency,
        rp.status,
        rp.late_fee,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due,
        (
            SELECT COUNT(*)
              FROM rent_payment rp2
             WHERE rp2.transaction_id = rp.transaction_id
               AND rp2.status IN ('atrasado', 'parcial')
        ) AS overdue_count,
        (
            SELECT IFNULL(SUM(rp3.amount_due - rp3.amount_paid + IFNULL(rp3.late_fee, 0)), 0)
              FROM rent_payment rp3
             WHERE rp3.transaction_id = rp.transaction_id
               AND rp3.status IN ('atrasado', 'parcial')
        ) AS total_overdue_amount
    FROM rent_payment rp
    INNER JOIN property_transaction pt ON pt.id = rp.transaction_id
    WHERE pt.property_id    = p_property_id
      AND pt.transaction_type = 'renta'
      AND pt.status = 'activa'
      AND rp.period_year    = YEAR(CURDATE())
      AND rp.period_month   = MONTH(CURDATE())
    LIMIT 1;
END ;;

CREATE PROCEDURE property_transaction_list_by_customer(
    IN p_customer_id INT
)
BEGIN
    SELECT
        pt.id,
        pt.property_id,
        p.title AS property_title,
        c.id AS customer_id,
        c.full_name AS customer_name,
        pt.transaction_type,
        pt.status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.cancelled_at,
        pt.cancel_reason,
        u.full_name AS registered_by
    FROM property_transaction pt
    INNER JOIN property p ON p.id = pt.property_id
    INNER JOIN customer c ON c.id = pt.customer_id
    LEFT JOIN user u ON u.id = pt.created_by
    WHERE pt.customer_id = p_customer_id
    ORDER BY pt.transaction_date DESC, pt.id DESC;
END ;;

CREATE PROCEDURE property_transaction_list_by_property(
    IN p_property_id INT
)
BEGIN
    SELECT
        pt.id,
        pt.property_id,
        p.title AS property_title,
        c.id AS customer_id,
        c.full_name AS customer_name,
        c.email AS customer_email,
        c.phone AS customer_phone,
        c.customer_type,
        pt.transaction_type,
        pt.status,
        pt.final_price,
        pt.currency,
        pt.transaction_date,
        pt.notes,
        pt.cancelled_at,
        pt.cancel_reason,
        u.full_name AS registered_by,
        pt.created_at
    FROM property_transaction pt
    INNER JOIN property p ON p.id = pt.property_id
    INNER JOIN customer c ON c.id = pt.customer_id
    LEFT JOIN user u ON u.id = pt.created_by
    WHERE pt.property_id = p_property_id
    ORDER BY pt.transaction_date DESC, pt.id DESC;
END ;;

CREATE PROCEDURE property_transaction_register(
    IN p_property_id INT,
    IN p_customer_id INT,
    IN p_transaction_type VARCHAR(20),
    IN p_final_price DECIMAL(14,2),
    IN p_currency CHAR(3),
    IN p_notes TEXT,
    IN p_created_by INT
)
BEGIN
    DECLARE v_business_status_id INT;
    DECLARE v_publication_status_id INT;
    DECLARE v_active_transaction_id INT;
    DECLARE v_property_transaction_id INT;

    SELECT id
      INTO v_active_transaction_id
      FROM property_transaction
     WHERE property_id = p_property_id
       AND status = 'activa'
     ORDER BY transaction_date DESC, id DESC
     LIMIT 1;

    IF v_active_transaction_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La propiedad ya tiene una transacción activa. Cancélala o ciérrala antes de registrar otra.';
    END IF;

    IF p_transaction_type = 'apartado' THEN
        SELECT id INTO v_business_status_id FROM property_business_status WHERE name = 'apartado' LIMIT 1;
        SELECT id INTO v_publication_status_id FROM property_publication_status WHERE name = 'activo' LIMIT 1;
    ELSEIF p_transaction_type = 'venta' THEN
        SELECT id INTO v_business_status_id FROM property_business_status WHERE name = 'vendido' LIMIT 1;
        SELECT id INTO v_publication_status_id FROM property_publication_status WHERE name = 'inactivo' LIMIT 1;
    ELSEIF p_transaction_type = 'renta' THEN
        SELECT id INTO v_business_status_id FROM property_business_status WHERE name = 'rentado' LIMIT 1;
        SELECT id INTO v_publication_status_id FROM property_publication_status WHERE name = 'inactivo' LIMIT 1;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'transaction_type inválido. Usa: apartado, venta o renta';
    END IF;

    INSERT INTO property_transaction (
        property_id,
        customer_id,
        transaction_type,
        status,
        final_price,
        currency,
        notes,
        created_by
    )
    VALUES (
        p_property_id,
        p_customer_id,
        p_transaction_type,
        'activa',
        p_final_price,
        p_currency,
        p_notes,
        p_created_by
    );
    SET v_property_transaction_id = LAST_INSERT_ID();

    UPDATE property
       SET business_status_id = v_business_status_id,
           publication_status_id = v_publication_status_id
     WHERE id = p_property_id;

    INSERT INTO property_status_history (
        property_id,
        publication_status_id,
        business_status_id,
        changed_by,
        change_notes
    )
    VALUES (
        p_property_id,
        v_publication_status_id,
        v_business_status_id,
        p_created_by,
        CONCAT('Cambio automático por transacción: ', p_transaction_type, '. ', IFNULL(p_notes, ''))
    );

    SELECT v_property_transaction_id AS property_transaction_id;
END ;;

CREATE PROCEDURE property_transaction_cancel(
    IN p_transaction_id INT,
    IN p_cancel_reason TEXT,
    IN p_cancelled_by INT
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_business_status_id INT;
    DECLARE v_publication_status_id INT;
    DECLARE v_reason TEXT;
    DECLARE v_payments_cancelled INT DEFAULT 0;

    SELECT
        pt.property_id,
        pt.transaction_type,
        pt.status
      INTO v_property_id, v_transaction_type, v_current_status
      FROM property_transaction pt
     WHERE pt.id = p_transaction_id
     LIMIT 1;

    IF v_property_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    IF v_current_status = 'cancelada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción ya está cancelada';
    END IF;

    IF v_current_status = 'cerrada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede cancelar una transacción cerrada';
    END IF;

    SELECT id INTO v_business_status_id FROM property_business_status WHERE name = 'disponible' LIMIT 1;
    SELECT id INTO v_publication_status_id FROM property_publication_status WHERE name = 'activo' LIMIT 1;

    IF v_business_status_id IS NULL OR v_publication_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontraron los catálogos de estado de propiedad requeridos';
    END IF;

    SET v_reason = COALESCE(NULLIF(TRIM(p_cancel_reason), ''), 'Cancelada por usuario');

    START TRANSACTION;

    UPDATE property_transaction
       SET status = 'cancelada',
           cancelled_at = NOW(),
           cancelled_by = p_cancelled_by,
           cancel_reason = v_reason
     WHERE id = p_transaction_id;

    IF v_transaction_type = 'renta' THEN
        UPDATE rent_payment
           SET status = 'cancelado',
               notes = CASE
                           WHEN notes IS NULL OR notes = '' THEN CONCAT('Pago cancelado por cancelación de la transacción #', p_transaction_id)
                           ELSE CONCAT(notes, ' | Pago cancelado por cancelación de la transacción #', p_transaction_id)
                       END
         WHERE transaction_id = p_transaction_id
           AND status IN ('pendiente', 'atrasado');

        SET v_payments_cancelled = ROW_COUNT();
    END IF;

    UPDATE property
       SET business_status_id = v_business_status_id,
           publication_status_id = v_publication_status_id
     WHERE id = v_property_id;

    INSERT INTO property_status_history (
        property_id,
        publication_status_id,
        business_status_id,
        changed_by,
        change_notes
    ) VALUES (
        v_property_id,
        v_publication_status_id,
        v_business_status_id,
        p_cancelled_by,
        CONCAT('Cancelación de transacción #', p_transaction_id, ': ', v_reason)
    );

    COMMIT;

    SELECT
        p_transaction_id AS property_transaction_id,
        'cancelada' AS status,
        v_transaction_type AS transaction_type,
        v_property_id AS property_id,
        v_payments_cancelled AS payments_cancelled;
END ;;

CREATE PROCEDURE rent_payment_update(
    IN p_payment_id  INT,
    IN p_amount_paid DECIMAL(14,2),
    IN p_paid_at     DATETIME,
    IN p_late_fee    DECIMAL(14,2),
    IN p_notes       TEXT,
    IN p_recorded_by INT
)
BEGIN
    DECLARE v_amount_due DECIMAL(14,2);
    DECLARE v_due_date   DATE;
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_status     VARCHAR(20);

    SELECT amount_due, due_date, status
      INTO v_amount_due, v_due_date, v_current_status
      FROM rent_payment
     WHERE id = p_payment_id;

    IF v_current_status = 'cancelado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede actualizar un pago cancelado';
    END IF;

    IF p_amount_paid >= v_amount_due THEN
        SET v_status = 'pagado';
    ELSEIF p_amount_paid > 0 THEN
        SET v_status = 'parcial';
    ELSEIF v_due_date < CURDATE() THEN
        SET v_status = 'atrasado';
    ELSE
        SET v_status = 'pendiente';
    END IF;

    UPDATE rent_payment
       SET amount_paid = p_amount_paid,
           paid_at     = IFNULL(p_paid_at, NOW()),
           late_fee    = p_late_fee,
           notes       = p_notes,
           status      = v_status,
           recorded_by = p_recorded_by
     WHERE id = p_payment_id;

    SELECT
        rp.*,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due
      FROM rent_payment rp
     WHERE rp.id = p_payment_id;
END ;;

DELIMITER ;

SELECT 'migration_applied' AS result;
