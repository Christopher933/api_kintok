const db = require("../../_shared/bd");
const pool = db.pool;

exports.getHomeContent = async () => {
    const [result] = await pool.query("CALL home_content_get()");
    return {
        statistics: result[0],
        testimonials: result[1],
        services: result[2],
    };
};

exports.listTeam = async (query) => {
    const { page_number, page_size } = query;
    const [result] = await pool.query("CALL agent_list_team(?, ?)", [
        parseInt(page_number) || 1,
        parseInt(page_size) || 10,
    ]);
    return {
        meta: result[0][0],
        data: result[1],
    };
};
