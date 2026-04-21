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

exports.landUseList = async () => {
    const [result] = await pool.query("SELECT * FROM land_use ORDER BY name ASC");
    return result;
};

exports.topographyList = async () => {
    const [result] = await pool.query("SELECT * FROM topography ORDER BY name ASC");
    return result;
};

exports.searchFilters = async () => {
    const [property_types] = await pool.query(`
        SELECT DISTINCT pt.id, pt.name
        FROM property_type pt
        INNER JOIN property p ON p.property_type_id = pt.id AND p.publication_status_id = 1
        ORDER BY pt.name ASC
    `);
    const [operations] = await pool.query(`
        SELECT DISTINCT o.id, o.name
        FROM operation o
        INNER JOIN property p ON p.operation_id = o.id AND p.publication_status_id = 1
        ORDER BY o.name ASC
    `);
    const [cities] = await pool.query(`
        SELECT DISTINCT c.id, c.name
        FROM city c
        INNER JOIN property p ON p.city_id = c.id AND p.publication_status_id = 1
        ORDER BY c.name ASC
    `);
    const [amenities] = await pool.query(`
        SELECT DISTINCT a.id, a.name
        FROM amenity a
        INNER JOIN property_amenity pa ON pa.amenity_id = a.id
        INNER JOIN property p ON p.id = pa.property_id AND p.publication_status_id = 1
        ORDER BY a.name ASC
    `);
    const [zones] = await pool.query(`
        SELECT DISTINCT z.id, z.name, z.city_id
        FROM zone z
        INNER JOIN property p ON p.zone_id = z.id AND p.publication_status_id = 1
        ORDER BY z.name ASC
    `);
    const [land_uses] = await pool.query(`
        SELECT DISTINCT lu.id, lu.name
        FROM land_use lu
        INNER JOIN property_land pl ON pl.land_use_id = lu.id
        INNER JOIN property p ON p.id = pl.property_id AND p.publication_status_id = 1
        ORDER BY lu.name ASC
    `);
    const [topographies] = await pool.query(`
        SELECT DISTINCT tp.id, tp.name
        FROM topography tp
        INNER JOIN property_land pl ON pl.topography_id = tp.id
        INNER JOIN property p ON p.id = pl.property_id AND p.publication_status_id = 1
        ORDER BY tp.name ASC
    `);
    return { property_types, operations, cities, zones, amenities, land_uses, topographies };
};

exports.documentTypeList = async (applicable_to) => {
    if (applicable_to && applicable_to !== "todos") {
        const [result] = await pool.query(
            "SELECT * FROM document_type WHERE applicable_to = ? OR applicable_to = 'todos' ORDER BY name ASC",
            [applicable_to]
        );
        return result;
    }
    const [result] = await pool.query("SELECT * FROM document_type ORDER BY name ASC");
    return result;
};
