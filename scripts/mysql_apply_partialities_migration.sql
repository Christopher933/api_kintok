USE kintok;

-- ------------------------------------------------------------
-- Tabla de parcialidades por mes/pago
-- ------------------------------------------------------------

CREATE TABLE IF NOT EXISTS rent_payment_partiality (
  id int NOT NULL AUTO_INCREMENT,
  payment_id int NOT NULL,
  amount decimal(14,2) NOT NULL,
  paid_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  notes text COLLATE utf8mb4_unicode_ci,
  recorded_by int DEFAULT NULL,
  created_at datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  KEY idx_rent_payment_partiality_payment (payment_id),
  KEY fk_rent_payment_partiality_user (recorded_by),
  CONSTRAINT fk_rent_payment_partiality_payment FOREIGN KEY (payment_id) REFERENCES rent_payment(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_rent_payment_partiality_user FOREIGN KEY (recorded_by) REFERENCES user(id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_rent_payment_partiality_amount CHECK (amount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------------
-- SPs de pagos/parcialidades
-- ------------------------------------------------------------

DROP PROCEDURE IF EXISTS rent_payment_list;
DROP PROCEDURE IF EXISTS rent_payment_update;
DROP PROCEDURE IF EXISTS rent_payment_partial_list;
DROP PROCEDURE IF EXISTS rent_payment_partial_add;

DELIMITER ;;

CREATE PROCEDURE rent_payment_list(
    IN p_transaction_id INT
)
BEGIN
    UPDATE rent_payment
       SET status = 'atrasado'
     WHERE transaction_id = p_transaction_id
       AND due_date < CURDATE()
       AND status IN ('pendiente');

    SELECT
        rp.*,
        (rp.amount_due - rp.amount_paid + IFNULL(rp.late_fee, 0)) AS balance_due,
        (
            SELECT COUNT(*)
              FROM rent_payment_partiality rpp
             WHERE rpp.payment_id = rp.id
        ) AS partialities_count,
        (
            SELECT IFNULL(SUM(rpp2.amount), 0)
              FROM rent_payment_partiality rpp2
             WHERE rpp2.payment_id = rp.id
        ) AS partialities_total
      FROM rent_payment rp
     WHERE rp.transaction_id = p_transaction_id
     ORDER BY rp.period_year ASC, rp.period_month ASC;
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

    SELECT amount_due, due_date, IFNULL(late_fee, 0), status
      INTO v_amount_due, v_due_date, v_late_fee, v_current_status
      FROM rent_payment
     WHERE id = p_payment_id;

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

CREATE PROCEDURE rent_payment_partial_list(
    IN p_payment_id INT
)
BEGIN
    SELECT
        rpp.id,
        rpp.payment_id,
        rpp.amount,
        rpp.paid_at,
        rpp.notes,
        rpp.recorded_by,
        u.full_name AS recorded_by_name,
        rpp.created_at
    FROM rent_payment_partiality rpp
    LEFT JOIN user u ON u.id = rpp.recorded_by
    WHERE rpp.payment_id = p_payment_id
    ORDER BY rpp.paid_at ASC, rpp.id ASC;
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

    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El monto de la parcialidad debe ser mayor a 0';
    END IF;

    SELECT amount_due, amount_paid, due_date, IFNULL(late_fee, 0), status
      INTO v_amount_due, v_amount_paid, v_due_date, v_late_fee, v_current_status
      FROM rent_payment
     WHERE id = p_payment_id;

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

    START TRANSACTION;

    INSERT INTO rent_payment_partiality (
        payment_id,
        amount,
        paid_at,
        notes,
        recorded_by
    ) VALUES (
        p_payment_id,
        p_amount,
        IFNULL(p_paid_at, NOW()),
        p_notes,
        p_recorded_by
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

DELIMITER ;

SELECT 'partialities_migration_applied' AS result;
