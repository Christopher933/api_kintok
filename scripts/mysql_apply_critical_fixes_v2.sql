USE kintok;

DROP PROCEDURE IF EXISTS property_transaction_register;
DROP PROCEDURE IF EXISTS property_transaction_close;
DROP PROCEDURE IF EXISTS property_status_update;
DROP PROCEDURE IF EXISTS rent_payment_update;
DROP PROCEDURE IF EXISTS rent_payment_partial_add;
DROP PROCEDURE IF EXISTS transaction_reservation_save;
DROP PROCEDURE IF EXISTS transaction_rental_save;
DROP PROCEDURE IF EXISTS transaction_document_add;

DELIMITER ;;

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
    DECLARE v_property_exists INT;
    DECLARE v_property_transaction_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT id
      INTO v_property_exists
      FROM property
     WHERE id = p_property_id
     FOR UPDATE;

    IF v_property_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Propiedad no encontrada';
    END IF;

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
        property_id, customer_id, transaction_type, status,
        final_price, currency, notes, created_by
    )
    VALUES (
        p_property_id, p_customer_id, p_transaction_type, 'activa',
        p_final_price, p_currency, p_notes, p_created_by
    );
    SET v_property_transaction_id = LAST_INSERT_ID();

    UPDATE property
       SET business_status_id = v_business_status_id,
           publication_status_id = v_publication_status_id
     WHERE id = p_property_id;

    INSERT INTO property_status_history (
        property_id, publication_status_id, business_status_id, changed_by, change_notes
    )
    VALUES (
        p_property_id, v_publication_status_id, v_business_status_id, p_created_by,
        CONCAT('Cambio automático por transacción: ', p_transaction_type, '. ', IFNULL(p_notes, ''))
    );

    COMMIT;

    SELECT v_property_transaction_id AS property_transaction_id;
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
    DECLARE v_late_fee   DECIMAL(14,2);
    DECLARE v_total_due  DECIMAL(14,2);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_status     VARCHAR(20);

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    START TRANSACTION;

    SELECT amount_due, due_date, IFNULL(late_fee, 0), status
      INTO v_amount_due, v_due_date, v_late_fee, v_current_status
      FROM rent_payment
     WHERE id = p_payment_id
     FOR UPDATE;

    IF v_amount_due IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pago no encontrado';
    END IF;

    IF v_current_status = 'cancelado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede actualizar un pago cancelado';
    END IF;

    SET v_total_due = v_amount_due + IFNULL(p_late_fee, v_late_fee);

    IF p_amount_paid < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'amount_paid no puede ser negativo';
    END IF;

    IF p_amount_paid > v_total_due THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El pago excede el adeudo del mes. Registra la penalización en late_fee antes de cobrar más.';
    END IF;

    IF p_amount_paid >= v_total_due THEN
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
           late_fee    = IFNULL(p_late_fee, late_fee),
           notes       = p_notes,
           status      = v_status,
           recorded_by = p_recorded_by
     WHERE id = p_payment_id;

    COMMIT;

    SELECT
        rp.*,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due
      FROM rent_payment rp
     WHERE rp.id = p_payment_id;
END ;;

CREATE PROCEDURE rent_payment_partial_add(
    IN p_payment_id  INT,
    IN p_amount      DECIMAL(14,2),
    IN p_paid_at     DATETIME,
    IN p_late_fee    DECIMAL(14,2),
    IN p_notes       TEXT,
    IN p_recorded_by INT
)
BEGIN
    DECLARE v_amount_due DECIMAL(14,2);
    DECLARE v_amount_paid DECIMAL(14,2);
    DECLARE v_due_date DATE;
    DECLARE v_late_fee DECIMAL(14,2);
    DECLARE v_new_late_fee DECIMAL(14,2);
    DECLARE v_total_due DECIMAL(14,2);
    DECLARE v_new_amount_paid DECIMAL(14,2);
    DECLARE v_new_status VARCHAR(20);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_partial_id INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto de la parcialidad debe ser mayor a 0';
    END IF;

    START TRANSACTION;

    SELECT amount_due, amount_paid, due_date, IFNULL(late_fee, 0), status
      INTO v_amount_due, v_amount_paid, v_due_date, v_late_fee, v_current_status
      FROM rent_payment
     WHERE id = p_payment_id
     FOR UPDATE;

    IF v_amount_due IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pago no encontrado';
    END IF;

    IF v_current_status = 'cancelado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede registrar parcialidad en un pago cancelado';
    END IF;

    SET v_new_late_fee = IFNULL(p_late_fee, v_late_fee);
    SET v_total_due = v_amount_due - v_amount_paid + v_new_late_fee;

    IF p_amount > v_total_due THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La parcialidad excede el saldo pendiente del mes';
    END IF;

    SET v_new_amount_paid = v_amount_paid + p_amount;

    IF v_new_amount_paid >= (v_amount_due + v_new_late_fee) THEN
        SET v_new_status = 'pagado';
    ELSEIF v_new_amount_paid > 0 THEN
        SET v_new_status = 'parcial';
    ELSEIF v_due_date < CURDATE() THEN
        SET v_new_status = 'atrasado';
    ELSE
        SET v_new_status = 'pendiente';
    END IF;

    INSERT INTO rent_payment_partiality (
        payment_id, amount, paid_at, notes, recorded_by
    ) VALUES (
        p_payment_id, p_amount, IFNULL(p_paid_at, NOW()), p_notes, p_recorded_by
    );

    SET v_partial_id = LAST_INSERT_ID();

    UPDATE rent_payment
       SET amount_paid = v_new_amount_paid,
           paid_at = IFNULL(p_paid_at, NOW()),
           late_fee = v_new_late_fee,
           notes = CASE
                     WHEN p_notes IS NULL OR p_notes = '' THEN notes
                     WHEN notes IS NULL OR notes = '' THEN p_notes
                     ELSE CONCAT(notes, ' | ', p_notes)
                   END,
           status = v_new_status,
           recorded_by = p_recorded_by
     WHERE id = p_payment_id;

    COMMIT;

    SELECT
        rp.*,
        v_partial_id AS partiality_id,
        p_amount AS partial_amount,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due
      FROM rent_payment rp
     WHERE rp.id = p_payment_id;
END ;;

CREATE PROCEDURE property_transaction_close(
    IN p_transaction_id INT,
    IN p_close_reason TEXT,
    IN p_closed_by INT
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_current_status VARCHAR(20);
    DECLARE v_business_status_id INT;
    DECLARE v_publication_status_id INT;
    DECLARE v_reason TEXT;
    DECLARE v_open_balances INT DEFAULT 0;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

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

    IF v_current_status = 'cerrada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción ya está cerrada';
    END IF;

    IF v_current_status = 'cancelada' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se puede cerrar una transacción cancelada';
    END IF;

    IF v_transaction_type = 'venta' THEN
        SELECT id INTO v_business_status_id
          FROM property_business_status
         WHERE name = 'vendido'
         LIMIT 1;
        SELECT id INTO v_publication_status_id
          FROM property_publication_status
         WHERE name = 'inactivo'
         LIMIT 1;
    ELSE
        SELECT id INTO v_business_status_id
          FROM property_business_status
         WHERE name = 'disponible'
         LIMIT 1;
        SELECT id INTO v_publication_status_id
          FROM property_publication_status
         WHERE name = 'activo'
         LIMIT 1;
    END IF;

    IF v_business_status_id IS NULL OR v_publication_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontraron los catálogos de estado de propiedad requeridos';
    END IF;

    IF v_transaction_type = 'renta' THEN
        SELECT COUNT(*)
          INTO v_open_balances
          FROM rent_payment rp
         WHERE rp.transaction_id = p_transaction_id
           AND (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) > 0;

        IF v_open_balances > 0 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No se puede cerrar la renta con adeudos pendientes';
        END IF;
    END IF;

    SET v_reason = COALESCE(NULLIF(TRIM(p_close_reason), ''), 'Cierre de transacción');

    START TRANSACTION;

    UPDATE property_transaction
       SET status = 'cerrada',
           notes = CASE
                     WHEN notes IS NULL OR notes = '' THEN CONCAT(v_reason, ' (cerrada)')
                     ELSE CONCAT(notes, ' | ', v_reason, ' (cerrada)')
                   END
     WHERE id = p_transaction_id;

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
        p_closed_by,
        CONCAT('Cierre de transacción #', p_transaction_id, ': ', v_reason)
    );

    COMMIT;

    SELECT
        p_transaction_id AS property_transaction_id,
        'cerrada' AS status,
        v_transaction_type AS transaction_type,
        v_property_id AS property_id;
END ;;

CREATE PROCEDURE property_status_update(
    IN p_property_id INT,
    IN p_publication_status_id INT,
    IN p_business_status_id INT,
    IN p_changed_by INT,
    IN p_change_notes TEXT
)
BEGIN
    DECLARE v_current_publication_status_id INT;
    DECLARE v_current_business_status_id INT;
    DECLARE v_new_publication_status_id INT;
    DECLARE v_new_business_status_id INT;

    SELECT publication_status_id, business_status_id
      INTO v_current_publication_status_id, v_current_business_status_id
      FROM property
     WHERE id = p_property_id
     LIMIT 1;

    IF v_current_publication_status_id IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Propiedad no encontrada';
    END IF;

    SET v_new_publication_status_id = COALESCE(p_publication_status_id, v_current_publication_status_id);
    SET v_new_business_status_id = COALESCE(p_business_status_id, v_current_business_status_id);

    UPDATE property
       SET publication_status_id = v_new_publication_status_id,
           business_status_id = v_new_business_status_id
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
        v_new_publication_status_id,
        v_new_business_status_id,
        p_changed_by,
        COALESCE(NULLIF(TRIM(p_change_notes), ''), 'Actualización manual de estatus')
    );

    SELECT ROW_COUNT() AS affected_rows;
END ;;

CREATE PROCEDURE transaction_reservation_save(
    IN p_transaction_id      INT,
    IN p_deposit_amount      DECIMAL(14,2),
    IN p_deposit_currency    CHAR(3),
    IN p_expires_at          DATETIME,
    IN p_applied_to_sale     TINYINT(1),
    IN p_cancellation_policy TEXT
)
BEGIN
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_status VARCHAR(20);

    SELECT transaction_type, status
      INTO v_transaction_type, v_status
      FROM property_transaction
     WHERE id = p_transaction_id
     LIMIT 1;

    IF v_transaction_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    IF v_transaction_type <> 'apartado' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción no es de tipo apartado';
    END IF;

    IF v_status <> 'activa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se puede actualizar apartado en transacciones activas';
    END IF;

    INSERT INTO transaction_reservation (
        transaction_id, deposit_amount, deposit_currency,
        expires_at, applied_to_sale, cancellation_policy
    ) VALUES (
        p_transaction_id, p_deposit_amount, p_deposit_currency,
        p_expires_at, IFNULL(p_applied_to_sale, 0), p_cancellation_policy
    )
    ON DUPLICATE KEY UPDATE
        deposit_amount       = VALUES(deposit_amount),
        deposit_currency     = VALUES(deposit_currency),
        expires_at           = VALUES(expires_at),
        applied_to_sale      = VALUES(applied_to_sale),
        cancellation_policy  = VALUES(cancellation_policy);

    SELECT * FROM transaction_reservation WHERE transaction_id = p_transaction_id;
END ;;

CREATE PROCEDURE transaction_rental_save(
    IN p_transaction_id   INT,
    IN p_start_date       DATE,
    IN p_end_date         DATE,
    IN p_monthly_rent     DECIMAL(14,2),
    IN p_deposit_amount   DECIMAL(14,2),
    IN p_deposit_currency CHAR(3),
    IN p_payment_day      TINYINT,
    IN p_auto_renew       TINYINT(1)
)
BEGIN
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_status VARCHAR(20);

    SELECT transaction_type, status
      INTO v_transaction_type, v_status
      FROM property_transaction
     WHERE id = p_transaction_id
     LIMIT 1;

    IF v_transaction_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    IF v_transaction_type <> 'renta' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'La transacción no es de tipo renta';
    END IF;

    IF v_status <> 'activa' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Solo se puede actualizar renta en transacciones activas';
    END IF;

    INSERT INTO transaction_rental (
        transaction_id, start_date, end_date, monthly_rent,
        deposit_amount, deposit_currency, payment_day, auto_renew
    ) VALUES (
        p_transaction_id, p_start_date, p_end_date, p_monthly_rent,
        p_deposit_amount, p_deposit_currency, IFNULL(p_payment_day, 1), IFNULL(p_auto_renew, 0)
    )
    ON DUPLICATE KEY UPDATE
        start_date       = VALUES(start_date),
        end_date         = VALUES(end_date),
        monthly_rent     = VALUES(monthly_rent),
        deposit_amount   = VALUES(deposit_amount),
        deposit_currency = VALUES(deposit_currency),
        payment_day      = VALUES(payment_day),
        auto_renew       = VALUES(auto_renew);

    SELECT * FROM transaction_rental WHERE transaction_id = p_transaction_id;
END ;;

CREATE PROCEDURE transaction_document_add(
    IN p_transaction_id   INT,
    IN p_document_type_id INT,
    IN p_file_url         VARCHAR(500),
    IN p_file_name        VARCHAR(255),
    IN p_notes            TEXT,
    IN p_uploaded_by      INT
)
BEGIN
    DECLARE v_transaction_type VARCHAR(20);
    DECLARE v_applicable_to VARCHAR(20);

    SELECT pt.transaction_type
      INTO v_transaction_type
      FROM property_transaction pt
     WHERE pt.id = p_transaction_id
     LIMIT 1;

    IF v_transaction_type IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Transacción no encontrada';
    END IF;

    SELECT dt.applicable_to
      INTO v_applicable_to
      FROM document_type dt
     WHERE dt.id = p_document_type_id
     LIMIT 1;

    IF v_applicable_to IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tipo de documento no encontrado';
    END IF;

    IF v_applicable_to <> 'todos' AND v_applicable_to <> v_transaction_type THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El tipo de documento no aplica al tipo de transacción';
    END IF;

    INSERT INTO transaction_document (
        transaction_id, document_type_id, file_url, file_name, notes, uploaded_by
    ) VALUES (
        p_transaction_id, p_document_type_id, p_file_url,
        p_file_name, p_notes, p_uploaded_by
    );

    SELECT LAST_INSERT_ID() AS transaction_document_id;
END ;;

DELIMITER ;

SELECT 'critical_fixes_v2_applied' AS result;
