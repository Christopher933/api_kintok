/*!50003 DROP PROCEDURE IF EXISTS `property_overdue_list` */;
DELIMITER ;;
CREATE PROCEDURE `property_overdue_list`(
    IN p_search_text VARCHAR(150),
    IN p_city_id INT,
    IN p_zone_id INT,
    IN p_status VARCHAR(20),
    IN p_page_number INT,
    IN p_page_size INT
)
BEGIN
    DECLARE v_page_number INT DEFAULT 1;
    DECLARE v_page_size INT DEFAULT 15;
    DECLARE v_offset INT DEFAULT 0;
    DECLARE v_status VARCHAR(20) DEFAULT NULL;
    DECLARE v_total_records INT DEFAULT 0;
    DECLARE v_total_pages INT DEFAULT 0;
    DECLARE v_search_text VARCHAR(150) DEFAULT NULL;

    SET v_page_number = IFNULL(p_page_number, 1);
    IF v_page_number < 1 THEN SET v_page_number = 1; END IF;

    SET v_page_size = IFNULL(p_page_size, 15);
    IF v_page_size < 1 THEN SET v_page_size = 15; END IF;
    IF v_page_size > 100 THEN SET v_page_size = 100; END IF;

    SET v_offset = (v_page_number - 1) * v_page_size;

    IF p_status IS NOT NULL AND TRIM(p_status) <> '' THEN
        SET v_status = LOWER(TRIM(p_status));
    END IF;

    IF p_search_text IS NOT NULL AND TRIM(p_search_text) <> '' THEN
        SET v_search_text = TRIM(p_search_text);
    END IF;

    SELECT COUNT(*)
      INTO v_total_records
      FROM (
            SELECT
                p.id AS property_id,
                SUM(CASE WHEN (rp.status = 'atrasado' OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN 1 ELSE 0 END) AS overdue_atrasado_count,
                SUM(CASE WHEN rp.status = 'parcial' THEN 1 ELSE 0 END) AS overdue_parcial_count
            FROM property p
            INNER JOIN city c ON c.id = p.city_id
            LEFT JOIN zone z ON z.id = p.zone_id
            INNER JOIN (
                SELECT pt1.property_id, pt1.id AS transaction_id, pt1.customer_id
                FROM property_transaction pt1
                INNER JOIN (
                    SELECT property_id, MAX(id) AS latest_transaction_id
                    FROM property_transaction
                    WHERE status = 'activa' AND transaction_type = 'renta'
                    GROUP BY property_id
                ) tx ON tx.latest_transaction_id = pt1.id
            ) atx ON atx.property_id = p.id
            INNER JOIN customer cu ON cu.id = atx.customer_id
            INNER JOIN rent_payment rp ON rp.transaction_id = atx.transaction_id
            WHERE
                (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE()))
                AND (p_city_id IS NULL OR p.city_id = p_city_id)
                AND (p_zone_id IS NULL OR p.zone_id = p_zone_id)
                AND (
                    v_search_text IS NULL
                    OR p.title LIKE CONCAT('%', v_search_text, '%')
                    OR cu.full_name LIKE CONCAT('%', v_search_text, '%')
                    OR cu.email LIKE CONCAT('%', v_search_text, '%')
                )
            GROUP BY p.id
            HAVING
                v_status IS NULL
                OR v_status = 'todos'
                OR (v_status = 'atrasado' AND overdue_atrasado_count > 0)
                OR (v_status = 'parcial' AND overdue_parcial_count > 0)
      ) q;

    SET v_total_pages = IF(v_total_records = 0, 0, CEIL(v_total_records / v_page_size));

    SELECT
        v_total_records AS total_records,
        v_page_number AS page_number,
        v_page_size AS page_size,
        v_total_pages AS total_pages;

    SELECT
        q.property_id,
        q.title,
        q.city_id,
        q.city_name,
        q.zone_id,
        q.zone_name,
        q.active_transaction_id,
        q.customer_id,
        q.customer_name,
        q.customer_email,
        q.customer_phone,
        q.overdue_payments_count,
        q.overdue_atrasado_count,
        q.overdue_parcial_count,
        q.total_overdue_amount,
        q.oldest_due_date,
        q.max_days_overdue,
        CASE
            WHEN q.overdue_atrasado_count > 0 THEN 'atrasado'
            WHEN q.overdue_parcial_count > 0 THEN 'parcial'
            ELSE 'pendiente'
        END AS overdue_status,
        q.current_payment_id,
        q.current_payment_status,
        q.current_payment_balance_due,
        q.main_image_url
    FROM (
            SELECT
                p.id AS property_id,
                p.title,
                p.city_id,
                c.name AS city_name,
                p.zone_id,
                z.name AS zone_name,
                atx.transaction_id AS active_transaction_id,
                cu.id AS customer_id,
                cu.full_name AS customer_name,
                cu.email AS customer_email,
                cu.phone AS customer_phone,
                SUM(CASE WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN 1 ELSE 0 END) AS overdue_payments_count,
                SUM(CASE WHEN (rp.status = 'atrasado' OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN 1 ELSE 0 END) AS overdue_atrasado_count,
                SUM(CASE WHEN rp.status = 'parcial' THEN 1 ELSE 0 END) AS overdue_parcial_count,
                ROUND(SUM(
                    CASE
                        WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE()))
                        THEN GREATEST((rp.amount_due + IFNULL(rp.late_fee, 0)) - rp.amount_paid, 0)
                        ELSE 0
                    END
                ), 2) AS total_overdue_amount,
                MIN(CASE WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN rp.due_date END) AS oldest_due_date,
                MAX(CASE WHEN (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE())) THEN DATEDIFF(CURDATE(), rp.due_date) ELSE 0 END) AS max_days_overdue,
                rp_cur.id AS current_payment_id,
                rp_cur.status AS current_payment_status,
                GREATEST((rp_cur.amount_due + IFNULL(rp_cur.late_fee, 0)) - rp_cur.amount_paid, 0) AS current_payment_balance_due,
                (
                    SELECT pi2.image_url
                    FROM property_image pi2
                    WHERE pi2.property_id = p.id
                    ORDER BY pi2.sort_order ASC
                    LIMIT 1
                ) AS main_image_url
            FROM property p
            INNER JOIN city c ON c.id = p.city_id
            LEFT JOIN zone z ON z.id = p.zone_id
            INNER JOIN (
                SELECT pt1.property_id, pt1.id AS transaction_id, pt1.customer_id
                FROM property_transaction pt1
                INNER JOIN (
                    SELECT property_id, MAX(id) AS latest_transaction_id
                    FROM property_transaction
                    WHERE status = 'activa' AND transaction_type = 'renta'
                    GROUP BY property_id
                ) tx ON tx.latest_transaction_id = pt1.id
            ) atx ON atx.property_id = p.id
            INNER JOIN customer cu ON cu.id = atx.customer_id
            INNER JOIN rent_payment rp ON rp.transaction_id = atx.transaction_id
            LEFT JOIN rent_payment rp_cur
                   ON rp_cur.transaction_id = atx.transaction_id
                  AND rp_cur.period_year = YEAR(CURDATE())
                  AND rp_cur.period_month = MONTH(CURDATE())
            WHERE
                (rp.status IN ('atrasado', 'parcial') OR (rp.status = 'pendiente' AND rp.due_date < CURDATE()))
                AND (p_city_id IS NULL OR p.city_id = p_city_id)
                AND (p_zone_id IS NULL OR p.zone_id = p_zone_id)
                AND (
                    v_search_text IS NULL
                    OR p.title LIKE CONCAT('%', v_search_text, '%')
                    OR cu.full_name LIKE CONCAT('%', v_search_text, '%')
                    OR cu.email LIKE CONCAT('%', v_search_text, '%')
                )
            GROUP BY
                p.id,
                p.title,
                p.city_id,
                c.name,
                p.zone_id,
                z.name,
                atx.transaction_id,
                cu.id,
                cu.full_name,
                cu.email,
                cu.phone,
                rp_cur.id,
                rp_cur.status,
                rp_cur.amount_due,
                rp_cur.amount_paid,
                rp_cur.late_fee
            HAVING
                v_status IS NULL
                OR v_status = 'todos'
                OR (v_status = 'atrasado' AND overdue_atrasado_count > 0)
                OR (v_status = 'parcial' AND overdue_parcial_count > 0)
    ) q
    ORDER BY q.max_days_overdue DESC, q.total_overdue_amount DESC, q.property_id DESC
    LIMIT v_offset, v_page_size;
END ;;
DELIMITER ;

SELECT 'property_overdue_list_applied' AS result;
