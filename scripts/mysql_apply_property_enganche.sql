-- Agrega campo enganche a la tabla property y actualiza el SP property_upsert

ALTER TABLE property
    ADD COLUMN `enganche` DECIMAL(14,2) DEFAULT NULL AFTER `price_value`;

DROP PROCEDURE IF EXISTS `property_upsert`;

DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `property_upsert`(
    IN p_id INT,
    IN p_property_type_id INT,
    IN p_operation_id INT,
    IN p_city_id INT,
    IN p_zone_id INT,
    IN p_address VARCHAR(255),
    IN p_latitude DECIMAL(10,8),
    IN p_longitude DECIMAL(11,8),
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_construction_area DECIMAL(14,2),
    IN p_land_area DECIMAL(14,2),
    IN p_price_value DECIMAL(14,2),
    IN p_enganche DECIMAL(14,2),
    IN p_currency CHAR(3),
    IN p_is_featured TINYINT,
    IN p_publication_status_id INT,
    IN p_business_status_id INT,
    -- Industrial
    IN p_clear_height DECIMAL(10,2),
    IN p_docks INT,
    IN p_power_kva DECIMAL(12,2),
    IN p_industrial_park VARCHAR(150),
    IN p_floor_resistance DECIMAL(10,2),
    -- Residential
    IN p_bedrooms INT,
    IN p_bathrooms DECIMAL(5,2),
    IN p_parking INT,
    IN p_pets_allowed TINYINT,
    IN p_is_furnished TINYINT,
    IN p_age INT,
    -- Land
    IN p_land_use VARCHAR(150),
    IN p_frontage DECIMAL(10,2),
    IN p_depth DECIMAL(10,2),
    IN p_topography VARCHAR(100),
    -- Amenities
    IN p_amenities JSON
)
BEGIN
    DECLARE v_property_id INT;
    DECLARE v_default_publication_status_id INT;
    DECLARE v_default_business_status_id INT;
    DECLARE v_i INT DEFAULT 0;
    DECLARE v_len INT DEFAULT 0;
    DECLARE v_amenity_name VARCHAR(100);

    SELECT id INTO v_default_publication_status_id
    FROM property_publication_status WHERE name = 'activo' LIMIT 1;

    SELECT id INTO v_default_business_status_id
    FROM property_business_status WHERE name = 'disponible' LIMIT 1;

    IF p_publication_status_id IS NULL THEN
        SET p_publication_status_id = v_default_publication_status_id;
    END IF;
    IF p_business_status_id IS NULL THEN
        SET p_business_status_id = v_default_business_status_id;
    END IF;

    IF p_id IS NULL OR p_id = 0 THEN
        INSERT INTO property (
            property_type_id, operation_id, city_id, zone_id,
            address, latitude, longitude, title, description, construction_area, land_area, price_value, enganche, currency,
            is_featured, publication_status_id, business_status_id
        ) VALUES (
            p_property_type_id, p_operation_id, p_city_id, p_zone_id,
            p_address, p_latitude, p_longitude, p_title, p_description, p_construction_area, p_land_area, p_price_value, p_enganche, p_currency,
            p_is_featured, p_publication_status_id, p_business_status_id
        );
        SET v_property_id = LAST_INSERT_ID();
    ELSE
        UPDATE property SET
            property_type_id = p_property_type_id, operation_id = p_operation_id,
            city_id = p_city_id, zone_id = p_zone_id,
            address = p_address, latitude = p_latitude, longitude = p_longitude,
            title = p_title, description = p_description,
            construction_area = p_construction_area, land_area = p_land_area, price_value = p_price_value, enganche = p_enganche,
            currency = p_currency, is_featured = p_is_featured,
            publication_status_id = p_publication_status_id,
            business_status_id = p_business_status_id
        WHERE id = p_id;
        SET v_property_id = p_id;
    END IF;

    -- Industrial
    IF p_clear_height IS NOT NULL OR p_docks IS NOT NULL OR p_power_kva IS NOT NULL
       OR p_industrial_park IS NOT NULL OR p_floor_resistance IS NOT NULL THEN
        INSERT INTO property_industrial (property_id, clear_height, docks, power_kva, industrial_park, floor_resistance)
        VALUES (v_property_id, p_clear_height, p_docks, p_power_kva, p_industrial_park, p_floor_resistance)
        ON DUPLICATE KEY UPDATE
            clear_height = VALUES(clear_height), docks = VALUES(docks),
            power_kva = VALUES(power_kva), industrial_park = VALUES(industrial_park),
            floor_resistance = VALUES(floor_resistance);
    END IF;

    -- Residential
    IF p_bedrooms IS NOT NULL OR p_bathrooms IS NOT NULL OR p_parking IS NOT NULL
       OR p_age IS NOT NULL OR p_pets_allowed IS NOT NULL OR p_is_furnished IS NOT NULL THEN
        INSERT INTO property_residential (property_id, bedrooms, bathrooms, parking, pets_allowed, is_furnished, age)
        VALUES (v_property_id, p_bedrooms, p_bathrooms, p_parking, IFNULL(p_pets_allowed, 0), IFNULL(p_is_furnished, 0), p_age)
        ON DUPLICATE KEY UPDATE
            bedrooms = VALUES(bedrooms), bathrooms = VALUES(bathrooms),
            parking = VALUES(parking), pets_allowed = VALUES(pets_allowed),
            is_furnished = VALUES(is_furnished), age = VALUES(age);
    END IF;

    -- Land
    IF p_land_use IS NOT NULL OR p_frontage IS NOT NULL OR p_depth IS NOT NULL OR p_topography IS NOT NULL THEN
        INSERT INTO property_land (property_id, land_use, frontage, depth, topography)
        VALUES (v_property_id, p_land_use, p_frontage, p_depth, p_topography)
        ON DUPLICATE KEY UPDATE
            land_use = VALUES(land_use), frontage = VALUES(frontage),
            depth = VALUES(depth), topography = VALUES(topography);
    END IF;

    -- Amenities
    IF p_amenities IS NOT NULL AND JSON_LENGTH(p_amenities) >= 0 THEN
        DELETE FROM property_amenity WHERE property_id = v_property_id;

        SET v_len = JSON_LENGTH(p_amenities);
        SET v_i = 0;
        WHILE v_i < v_len DO
            SET v_amenity_name = JSON_UNQUOTE(JSON_EXTRACT(p_amenities, CONCAT('$[', v_i, ']')));
            INSERT INTO property_amenity (property_id, amenity_id)
            SELECT v_property_id, id FROM amenity WHERE name = v_amenity_name;
            SET v_i = v_i + 1;
        END WHILE;
    END IF;

    SELECT v_property_id AS property_id;
END ;;
DELIMITER ;
