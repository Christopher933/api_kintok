DROP PROCEDURE IF EXISTS `property_delete`;
DELIMITER ;;
CREATE PROCEDURE `property_delete`(
    IN p_id INT
)
BEGIN
    DECLARE v_exists INT;
    SELECT id INTO v_exists FROM property WHERE id = p_id LIMIT 1;

    IF v_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Propiedad no encontrada';
    END IF;

    -- Devolver imágenes físicas para borrar en Node
    SELECT image_url FROM property_image WHERE property_id = p_id;

    -- Devolver docs físicos de transacciones vinculadas a esta propiedad
    SELECT file_url 
    FROM transaction_document td 
    JOIN property_transaction pt ON pt.id = td.transaction_id 
    WHERE pt.property_id = p_id;

    -- Eliminar registro (las dependencias en CASCADE se eliminarán, pero transaction tiene RESTRICT)
    DELETE FROM property_transaction WHERE property_id = p_id;
    DELETE FROM property WHERE id = p_id;
END ;;
DELIMITER ;

DROP PROCEDURE IF EXISTS `customer_delete`;
DELIMITER ;;
CREATE PROCEDURE `customer_delete`(
    IN p_id INT
)
BEGIN
    DECLARE v_exists INT;
    SELECT id INTO v_exists FROM customer WHERE id = p_id LIMIT 1;

    IF v_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente no encontrado';
    END IF;

    -- Devolver docs físicos de transacciones vinculadas a este cliente
    SELECT file_url 
    FROM transaction_document td 
    JOIN property_transaction pt ON pt.id = td.transaction_id 
    WHERE pt.customer_id = p_id;

    -- Limpiar referencias pre-borrado
    DELETE FROM customer_note WHERE customer_id = p_id;
    UPDATE lead_contact SET customer_id = NULL WHERE customer_id = p_id;
    DELETE FROM property_transaction WHERE customer_id = p_id;

    DELETE FROM customer WHERE id = p_id;
END ;;
DELIMITER ;


DROP PROCEDURE IF EXISTS `lead_contact_delete`;
DELIMITER ;;
CREATE PROCEDURE `lead_contact_delete`(
    IN p_id INT
)
BEGIN
    DECLARE v_exists INT;
    SELECT id INTO v_exists FROM lead_contact WHERE id = p_id LIMIT 1;

    IF v_exists IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Lead no encontrado';
    END IF;

    -- No bloqueamos si existe customer_id para forzar borrado en cascada
    -- Limpiar notas y lead
    DELETE FROM lead_contact_note WHERE lead_contact_id = p_id;
    DELETE FROM lead_contact WHERE id = p_id;
END ;;
DELIMITER ;
