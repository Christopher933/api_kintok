const { pool } = require("../../_shared/bd");

exports.register = async (body) => {
    const params = [
        body.property_id,
        body.customer_id,
        body.transaction_type,
        body.final_price || null,
        body.currency,
        body.notes || null,
        body.created_by || null,
    ];
    const [result] = await pool.query("CALL property_transaction_register(?, ?, ?, ?, ?, ?, ?)", params);
    return result[0][0];
};

exports.listByProperty = async (property_id) => {
    const [result] = await pool.query("CALL property_transaction_list_by_property(?)", [property_id]);
    return result[0];
};

exports.listByCustomer = async (customer_id) => {
    const [result] = await pool.query("CALL property_transaction_list_by_customer(?)", [customer_id]);
    return result[0];
};
