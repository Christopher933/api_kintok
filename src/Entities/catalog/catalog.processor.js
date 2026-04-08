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

exports.cityList = async () => {
    const [result] = await pool.query("SELECT * FROM city ORDER BY name ASC");
    return result;
};

exports.zoneList = async (city_id) => {
    const [result] = await pool.query("SELECT * FROM zone WHERE city_id = ? OR ? IS NULL ORDER BY name ASC", [city_id, city_id]);
    return result;
};

exports.amenityList = async () => {
    const [result] = await pool.query("SELECT * FROM amenity ORDER BY name ASC");
    return result;
};

exports.propertyTypeList = async () => {
    const [result] = await pool.query("SELECT * FROM property_type ORDER BY name ASC");
    return result;
};

exports.operationList = async () => {
    const [result] = await pool.query("SELECT * FROM operation ORDER BY name ASC");
    return result;
};

exports.publicationStatusList = async () => {
    const [result] = await pool.query("SELECT * FROM property_publication_status ORDER BY name ASC");
    return result;
};

exports.businessStatusList = async () => {
    const [result] = await pool.query("SELECT * FROM property_business_status ORDER BY name ASC");
    return result;
};
