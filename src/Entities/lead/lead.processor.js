const db = require("../../_shared/bd");
const pool = db.pool;

exports.register = async (body) => {
    const { property_id, name, email, phone, comments } = body;
    const [result] = await pool.query("CALL lead_contact_register(?, ?, ?, ?, ?)", [
        property_id,
        name,
        email,
        phone || null,
        comments || null,
    ]);
    return result[0][0];
};

exports.list = async (query) => {
    const { status, page_number, page_size } = query;
    const [result] = await pool.query("CALL lead_contact_list_with_customer(?, ?, ?)", [
        status || null,
        parseInt(page_number) || 1,
        parseInt(page_size) || 10,
    ]);
    return {
        meta: result[0][0],
        data: result[1],
    };
};

exports.statusUpdate = async (body) => {
    const { lead_contact_id, status } = body;
    const [result] = await pool.query("CALL lead_contact_status_update(?, ?)", [lead_contact_id, status]);
    return result[0][0];
};

exports.convertToCustomer = async (body) => {
    const { lead_contact_id, customer_type, notes } = body;
    const [result] = await pool.query("CALL lead_contact_convert_to_customer(?, ?, ?)", [
        lead_contact_id,
        customer_type || 'comprador',
        notes || null,
    ]);
    return result[0][0];
};
