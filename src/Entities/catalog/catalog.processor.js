const db = require("../../_shared/bd");
const pool = db.pool;

exports.cityUpsert = async (body) => {
    const { id, name } = body;
    const [result] = await pool.query("CALL city_upsert(?, ?)", [id || null, name]);
    return result[0][0];
};

exports.zoneUpsert = async (body) => {
    const { id, city_id, name } = body;
    const [result] = await pool.query("CALL zone_upsert(?, ?, ?)", [id || null, city_id, name]);
    return result[0][0];
};

exports.amenityUpsert = async (body) => {
    const { id, name } = body;
    const [result] = await pool.query("CALL amenity_upsert(?, ?)", [id || null, name]);
    return result[0][0];
};

exports.propertyTypeUpsert = async (body) => {
    const { id, name } = body;
    const [result] = await pool.query("CALL property_type_upsert(?, ?)", [id || null, name]);
    return result[0][0];
};
