USE kintok;

DROP PROCEDURE IF EXISTS property_transaction_register;

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

    COMMIT;

    SELECT v_property_transaction_id AS property_transaction_id;
END ;;
DELIMITER ;

SELECT 'property_transaction_register_last_insert_fixed' AS result;
