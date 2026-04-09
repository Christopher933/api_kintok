-- Validación E2E del flujo de cancelación de transacción
-- Requisitos:
-- 1) Haber importado db.sql en una BD de pruebas
-- 2) Ejecutar este script en esa misma BD

USE kintok;

SET @property_id = 7;
SET @customer_id = 1;
SET @user_id = 2;

SELECT 'STEP 1: estado inicial de transacciones por propiedad' AS step;
SELECT
    pt.id,
    pt.property_id,
    pt.transaction_type,
    pt.status,
    pt.transaction_date,
    pt.cancelled_at
FROM property_transaction pt
WHERE pt.property_id = @property_id
ORDER BY pt.id;

SET @active_tx = (
    SELECT pt.id
    FROM property_transaction pt
    WHERE pt.property_id = @property_id
      AND pt.status = 'activa'
    ORDER BY pt.transaction_date DESC, pt.id DESC
    LIMIT 1
);

SELECT 'STEP 2: cancelar transacción activa' AS step, @active_tx AS active_transaction_id;
CALL property_transaction_cancel(@active_tx, 'Validación E2E post-import', @user_id);

SELECT 'STEP 3: validar estatus final de transacción y propiedad' AS step;
SELECT
    pt.id,
    pt.transaction_type,
    pt.status,
    pt.cancel_reason,
    pt.cancelled_at,
    pt.cancelled_by
FROM property_transaction pt
WHERE pt.id = @active_tx;

SELECT
    p.id AS property_id,
    pbs.name AS business_status,
    pps.name AS publication_status
FROM property p
INNER JOIN property_business_status pbs ON pbs.id = p.business_status_id
INNER JOIN property_publication_status pps ON pps.id = p.publication_status_id
WHERE p.id = @property_id;

SELECT 'STEP 4: validar pagos tras cancelación (pendiente/atrasado -> cancelado)' AS step;
SELECT
    rp.id,
    rp.period_year,
    rp.period_month,
    rp.status,
    rp.amount_due,
    rp.amount_paid,
    rp.late_fee
FROM rent_payment rp
WHERE rp.transaction_id = @active_tx
ORDER BY rp.period_year, rp.period_month;

SET @cancelled_payment_id = (
    SELECT rp.id
    FROM rent_payment rp
    WHERE rp.transaction_id = @active_tx
      AND rp.status = 'cancelado'
    ORDER BY rp.id
    LIMIT 1
);

SELECT 'STEP 5: validar guardia de pagos cancelados (debe fallar update)' AS step, @cancelled_payment_id AS cancelled_payment_id;

DROP PROCEDURE IF EXISTS __tmp_validate_cancelled_payment_guard;
DELIMITER $$
CREATE PROCEDURE __tmp_validate_cancelled_payment_guard()
BEGIN
    DECLARE got_error BOOL DEFAULT FALSE;
    DECLARE err_msg TEXT DEFAULT NULL;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET got_error = TRUE;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
    END;

    CALL rent_payment_update(
        @cancelled_payment_id,
        100.00,
        NOW(),
        NULL,
        'Intento de update en pago cancelado',
        @user_id
    );

    SELECT
        got_error AS expected_error,
        err_msg AS error_message;
END$$
DELIMITER ;

CALL __tmp_validate_cancelled_payment_guard();
DROP PROCEDURE __tmp_validate_cancelled_payment_guard;

SELECT 'STEP 6: registrar nueva transacción después de cancelar (debe permitir)' AS step;
CALL property_transaction_register(
    @property_id,
    @customer_id,
    'apartado',
    3500.00,
    'MXN',
    'Nueva transacción de validación tras cancelación',
    @user_id
);

SET @new_tx = (
    SELECT pt.id
    FROM property_transaction pt
    WHERE pt.property_id = @property_id
      AND pt.status = 'activa'
    ORDER BY pt.transaction_date DESC, pt.id DESC
    LIMIT 1
);

CALL transaction_reservation_save(
    @new_tx,
    3500.00,
    'MXN',
    DATE_ADD(NOW(), INTERVAL 15 DAY),
    1,
    'Reserva creada en validación E2E'
);

SELECT
    pt.id,
    pt.property_id,
    pt.transaction_type,
    pt.status,
    pt.notes,
    pt.transaction_date
FROM property_transaction pt
WHERE pt.id = @new_tx;

SELECT
    p.id AS property_id,
    pbs.name AS business_status,
    pps.name AS publication_status
FROM property p
INNER JOIN property_business_status pbs ON pbs.id = p.business_status_id
INNER JOIN property_publication_status pps ON pps.id = p.publication_status_id
WHERE p.id = @property_id;

SELECT 'STEP 7: validar bloqueo de doble transacción activa (debe fallar)' AS step;

DROP PROCEDURE IF EXISTS __tmp_validate_double_active_guard;
DELIMITER $$
CREATE PROCEDURE __tmp_validate_double_active_guard()
BEGIN
    DECLARE got_error BOOL DEFAULT FALSE;
    DECLARE err_msg TEXT DEFAULT NULL;

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET got_error = TRUE;
        GET DIAGNOSTICS CONDITION 1 err_msg = MESSAGE_TEXT;
    END;

    CALL property_transaction_register(
        @property_id,
        @customer_id,
        'renta',
        4000.00,
        'MXN',
        'Este registro debe fallar por transacción activa',
        @user_id
    );

    SELECT
        got_error AS expected_error,
        err_msg AS error_message;
END$$
DELIMITER ;

CALL __tmp_validate_double_active_guard();
DROP PROCEDURE __tmp_validate_double_active_guard;

SELECT 'VALIDACIÓN COMPLETADA' AS result;
