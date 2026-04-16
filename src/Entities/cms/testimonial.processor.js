const { pool } = require("../../_shared/bd");

const mapDbError = (error) => {
    if (error && error.sqlState === "45000") {
        const message = error.sqlMessage || error.message || "Error de negocio";
        if (String(message).toLowerCase().includes("no encontrado")) {
            return { status: 404, message };
        }
        return { status: 400, message };
    }
    return error;
};

exports.list = async (query) => {
    const onlyActive = query.only_active === "true" || query.only_active === "1" ? 1 : 0;
    const page = parseInt(query.page, 10) || 1;
    const limit = parseInt(query.limit, 10) || 10;
    try {
        const [result] = await pool.query("CALL testimonial_list(?, ?, ?)", [onlyActive, page, limit]);
        return {
            meta: result[0][0],
            data: result[1] || [],
        };
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.upsert = async (body) => {
    const params = [
        body.id || null,
        body.author_name || null,
        body.author_role || null,
        body.quote_text || null,
        body.avatar_url || null,
        body.is_active != null ? Number(body.is_active) : null,
        body.sort_order != null ? Number(body.sort_order) : null,
    ];
    try {
        const [result] = await pool.query(
            "CALL testimonial_upsert(?, ?, ?, ?, ?, ?, ?)",
            params
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.remove = async (id) => {
    const testimonialId = Number(id);
    if (!testimonialId) {
        throw { status: 400, message: "id inválido" };
    }
    try {
        const [result] = await pool.query("CALL testimonial_delete(?)", [testimonialId]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};
