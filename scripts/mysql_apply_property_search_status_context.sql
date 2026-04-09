USE kintok;

DROP PROCEDURE IF EXISTS property_search;

DELIMITER ;;
CREATE PROCEDURE property_search(
    IN p_property_type_id   INT,
    IN p_operation_id       INT,
    IN p_city_id            INT,
    IN p_zone_id            INT,
    IN p_min_area           DECIMAL(14,2),
    IN p_max_area           DECIMAL(14,2),
    IN p_min_price          DECIMAL(14,2),
    IN p_max_price          DECIMAL(14,2),
    IN p_target_currency    CHAR(3),
    IN p_featured_only      TINYINT,
    IN p_search_text        VARCHAR(255),
    IN p_min_bedrooms       INT,
    IN p_min_bathrooms      DECIMAL(5,2),
    IN p_min_parking        INT,
    IN p_pets_allowed       TINYINT,
    IN p_min_clear_height   DECIMAL(10,2),
    IN p_min_docks          INT,
    IN p_min_power_kva      DECIMAL(12,2),
    IN p_industrial_park    TINYINT,
    IN p_land_use           VARCHAR(150),
    IN p_amenities          TEXT,
    IN p_page_number        INT,
    IN p_page_size          INT,
    IN p_publication_status VARCHAR(20),
    IN p_business_status    VARCHAR(50)
)
BEGIN
    DECLARE v_offset        INT DEFAULT 0;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages   INT DEFAULT 0;
    DECLARE v_target_curr   CHAR(3);
    DECLARE v_amenity_count INT DEFAULT 0;

    IF p_page_number IS NULL OR p_page_number < 1 THEN SET p_page_number = 1; END IF;
    IF p_page_size   IS NULL OR p_page_size   < 1 THEN SET p_page_size   = 10; END IF;
    SET v_offset = (p_page_number - 1) * p_page_size;
    SET v_target_curr = COALESCE(p_target_currency, 'MXN');

    IF p_amenities IS NOT NULL AND p_amenities != '' THEN
        SET v_amenity_count = LENGTH(p_amenities) - LENGTH(REPLACE(p_amenities, ',', '')) + 1;
    END IF;

    SELECT COUNT(DISTINCT p.id)
      INTO v_total_records
    FROM property p
    JOIN property_publication_status pps ON pps.id = p.publication_status_id
    JOIN property_business_status pbs    ON pbs.id = p.business_status_id
    LEFT JOIN property_residential pr   ON pr.property_id = p.id
    LEFT JOIN property_industrial  pi   ON pi.property_id = p.id
    LEFT JOIN property_land        pl   ON pl.property_id = p.id
    WHERE
        (p_publication_status IS NULL OR pps.name = p_publication_status)
        AND (p_business_status IS NULL OR pbs.name = p_business_status)
        AND (p_property_type_id IS NULL OR p.property_type_id = p_property_type_id)
        AND (p_operation_id     IS NULL OR p.operation_id     = p_operation_id)
        AND (p_city_id          IS NULL OR p.city_id          = p_city_id)
        AND (p_zone_id          IS NULL OR p.zone_id          = p_zone_id)
        AND (p_min_area         IS NULL OR p.area_value      >= p_min_area)
        AND (p_max_area         IS NULL OR p.area_value      <= p_max_area)
        AND (p_min_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) >= p_min_price)
        AND (p_max_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) <= p_max_price)
        AND (p_featured_only    IS NULL OR p_featured_only = 0 OR p.is_featured = 1)
        AND (p_search_text      IS NULL OR p_search_text = ''
             OR p.title       LIKE CONCAT('%', p_search_text, '%')
             OR p.description LIKE CONCAT('%', p_search_text, '%'))
        AND (p_min_bedrooms     IS NULL OR pr.bedrooms     >= p_min_bedrooms)
        AND (p_min_bathrooms    IS NULL OR pr.bathrooms    >= p_min_bathrooms)
        AND (p_min_parking      IS NULL OR pr.parking      >= p_min_parking)
        AND (p_pets_allowed     IS NULL OR p_pets_allowed = 0 OR pr.pets_allowed = 1)
        AND (p_min_clear_height IS NULL OR pi.clear_height >= p_min_clear_height)
        AND (p_min_docks        IS NULL OR pi.docks        >= p_min_docks)
        AND (p_min_power_kva    IS NULL OR pi.power_kva    >= p_min_power_kva)
        AND (p_industrial_park  IS NULL OR p_industrial_park = 0 OR (pi.industrial_park IS NOT NULL AND pi.industrial_park != ''))
        AND (p_land_use         IS NULL OR p_land_use = '' OR pl.land_use = p_land_use)
        AND (v_amenity_count = 0 OR (
            SELECT COUNT(DISTINCT a.name)
            FROM property_amenity pa
            JOIN amenity a ON a.id = pa.amenity_id
            WHERE pa.property_id = p.id
              AND FIND_IN_SET(a.name, p_amenities) > 0
        ) >= v_amenity_count);

    SET v_total_pages = CEIL(v_total_records / p_page_size);

    SELECT
        v_total_records  AS total_records,
        p_page_number    AS page_number,
        p_page_size      AS page_size,
        v_total_pages    AS total_pages,
        v_target_curr    AS target_currency;

    SELECT
        p.id,
        p.property_type_id,
        p.operation_id,
        p.city_id,
        p.zone_id,
        p.title,
        p.description,
        p.area_value,
        p.price_value   AS original_price,
        p.currency      AS original_currency,
        CONCAT('$', FORMAT(p.price_value, 2), ' ', p.currency) AS formatted_original_price,
        IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) AS normalized_price,
        CONCAT('$', FORMAT(
            IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value), 2), ' ', v_target_curr) AS formatted_normalized_price,
        p.views_count,
        p.is_featured,
        p.created_at,
        p.updated_at,
        pt.name         AS property_type_name,
        o.name          AS operation_name,
        c.name          AS city_name,
        z.name          AS zone_name,
        pps.name        AS publication_status,
        pbs.name        AS business_status,
        atx.transaction_id        AS active_transaction_id,
        atx.transaction_type      AS active_transaction_type,
        atx.transaction_status    AS active_transaction_status,
        atx.customer_id           AS active_transaction_customer_id,
        rp_cur.id                 AS current_payment_id,
        rp_cur.status             AS current_payment_status,
        (rp_cur.amount_due - rp_cur.amount_paid + IFNULL(rp_cur.late_fee, 0)) AS current_payment_balance_due,
        (SELECT pi2.image_url FROM property_image pi2
         WHERE pi2.property_id = p.id ORDER BY pi2.sort_order ASC LIMIT 1) AS main_image_url
    FROM property p
    JOIN property_type               pt  ON pt.id  = p.property_type_id
    JOIN operation                   o   ON o.id   = p.operation_id
    JOIN city                        c   ON c.id   = p.city_id
    LEFT JOIN zone                   z   ON z.id   = p.zone_id
    JOIN property_publication_status pps ON pps.id = p.publication_status_id
    JOIN property_business_status    pbs ON pbs.id = p.business_status_id
    LEFT JOIN property_residential   pr  ON pr.property_id = p.id
    LEFT JOIN property_industrial    pi  ON pi.property_id = p.id
    LEFT JOIN property_land          pl  ON pl.property_id = p.id
    LEFT JOIN (
        SELECT
            pt1.id AS transaction_id,
            pt1.property_id,
            pt1.transaction_type,
            pt1.status AS transaction_status,
            pt1.customer_id
        FROM property_transaction pt1
        INNER JOIN (
            SELECT property_id, MAX(id) AS latest_transaction_id
            FROM property_transaction
            WHERE status = 'activa'
            GROUP BY property_id
        ) tmax ON tmax.latest_transaction_id = pt1.id
    ) atx ON atx.property_id = p.id
    LEFT JOIN rent_payment rp_cur
      ON rp_cur.transaction_id = atx.transaction_id
     AND rp_cur.period_year = YEAR(CURDATE())
     AND rp_cur.period_month = MONTH(CURDATE())
    WHERE
        (p_publication_status IS NULL OR pps.name = p_publication_status)
        AND (p_business_status IS NULL OR pbs.name = p_business_status)
        AND (p_property_type_id IS NULL OR p.property_type_id = p_property_type_id)
        AND (p_operation_id     IS NULL OR p.operation_id     = p_operation_id)
        AND (p_city_id          IS NULL OR p.city_id          = p_city_id)
        AND (p_zone_id          IS NULL OR p.zone_id          = p_zone_id)
        AND (p_min_area         IS NULL OR p.area_value      >= p_min_area)
        AND (p_max_area         IS NULL OR p.area_value      <= p_max_area)
        AND (p_min_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) >= p_min_price)
        AND (p_max_price        IS NULL OR IFNULL(fn_convert_to_base(p.price_value, p.currency, v_target_curr), p.price_value) <= p_max_price)
        AND (p_featured_only    IS NULL OR p_featured_only = 0 OR p.is_featured = 1)
        AND (p_search_text      IS NULL OR p_search_text = ''
             OR p.title       LIKE CONCAT('%', p_search_text, '%')
             OR p.description LIKE CONCAT('%', p_search_text, '%'))
        AND (p_min_bedrooms     IS NULL OR pr.bedrooms     >= p_min_bedrooms)
        AND (p_min_bathrooms    IS NULL OR pr.bathrooms    >= p_min_bathrooms)
        AND (p_min_parking      IS NULL OR pr.parking      >= p_min_parking)
        AND (p_pets_allowed     IS NULL OR p_pets_allowed = 0 OR pr.pets_allowed = 1)
        AND (p_min_clear_height IS NULL OR pi.clear_height >= p_min_clear_height)
        AND (p_min_docks        IS NULL OR pi.docks        >= p_min_docks)
        AND (p_min_power_kva    IS NULL OR pi.power_kva    >= p_min_power_kva)
        AND (p_industrial_park  IS NULL OR p_industrial_park = 0 OR (pi.industrial_park IS NOT NULL AND pi.industrial_park != ''))
        AND (p_land_use         IS NULL OR p_land_use = '' OR pl.land_use = p_land_use)
        AND (v_amenity_count = 0 OR (
            SELECT COUNT(DISTINCT a.name)
            FROM property_amenity pa
            JOIN amenity a ON a.id = pa.amenity_id
            WHERE pa.property_id = p.id
              AND FIND_IN_SET(a.name, p_amenities) > 0
        ) >= v_amenity_count)
    ORDER BY p.created_at DESC
    LIMIT p_page_size OFFSET v_offset;
END ;;
DELIMITER ;

SELECT 'property_search_status_context_applied' AS result;
