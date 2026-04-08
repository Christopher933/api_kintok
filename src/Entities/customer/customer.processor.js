const { pool } = require("../../_shared/bd");

exports.upsert = async (body) => {
    const params = [
        body.id || null,
        body.full_name,
        body.email || null,
        body.phone || null,
        body.customer_type || null,
        body.notes || null,
    ];
    const [result] = await pool.query("CALL customer_upsert(?, ?, ?, ?, ?, ?)", params);
    return result[0][0];
};

exports.list = async (query) => {
    const search_text = query.search || query.search_text || null;
    const page = parseInt(query.page) || 1;
    const limit = parseInt(query.limit) || 10;

    const [result] = await pool.query("CALL customer_list(?, ?, ?)", [search_text, page, limit]);

    // Si el SP devuelve dos conjuntos (metadatos y datos)
    if (result.length > 1) {
        return {
            meta: result[0][0],
            data: result[1]
        };
    }

    // Fallback por si aún no han actualizado el SP
    return {
        meta: { total_records: result[0].length, page_number: page, page_size: limit, total_pages: 1 },
        data: result[0]
    };
};
