const db = require("../../_shared/bd");
const pool = db.pool;

exports.listFeatured = async (query) => {
    const { page_number, page_size } = query;
    const [result] = await pool.query("CALL property_list_featured(?, ?)", [
        parseInt(page_number) || 1,
        parseInt(page_size) || 10,
    ]);
    return {
        meta: result[0][0],
        data: result[1],
    };
};

exports.getDetail = async (id) => {
    const [result] = await pool.query("CALL property_get_detail(?)", [id]);
    return {
        property: result[0][0],
        industrial: result[1][0] || null,
        residential: result[2][0] || null,
        land: result[3][0] || null,
        amenities: result[4],
        images: result[5],
        agents: result[6],
    };
};

exports.visitIncrement = async (body) => {
    const { property_id, ip_address, user_agent } = body;
    await pool.query("CALL property_visit_increment(?, ?, ?)", [property_id, ip_address, user_agent]);
    return { message: "Visit incremented" };
};

exports.search = async (body) => {
    const {
        property_type_id,
        operation_id,
        city_id,
        zone_id,
        min_area,
        max_area,
        min_price,
        max_price,
        target_currency,
        featured_only,
        search_text,
        page_number,
        page_size,
    } = body;
    const [result] = await pool.query("CALL property_search(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", [
        property_type_id || null,
        operation_id || null,
        city_id || null,
        zone_id || null,
        min_area || null,
        max_area || null,
        min_price || null,
        max_price || null,
        target_currency || null,
        featured_only === undefined ? null : featured_only,
        search_text || null,
        parseInt(page_number) || 1,
        parseInt(page_size) || 10,
    ]);
    return {
        meta: result[0][0],
        data: result[1],
    };
};

exports.upsert = async (body) => {
    const params = [
        body.id || null,
        body.property_type_id,
        body.operation_id,
        body.city_id,
        body.zone_id,
        body.title,
        body.description || null,
        body.area_value || null,
        body.price_value || null,
        body.currency,
        body.is_featured || 0,
        body.is_active || 1,
        body.clear_height || null,
        body.docks || null,
        body.power_kva || null,
        body.industrial_park || null,
        body.floor_resistance || null,
        body.bedrooms || null,
        body.bathrooms || null,
        body.parking || null,
        body.pets_allowed || 0,
        body.is_furnished || 0,
        body.age || null,
        body.land_use || null,
        body.frontage || null,
        body.depth || null,
        body.topography || null,
    ];
    const [result] = await pool.query("CALL property_upsert(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", params);
    return result[0][0];
};
