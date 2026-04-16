const { pool } = require("../../_shared/bd");

exports.summary = async (query) => {
    const date_from = query.date_from || null;
    const date_to   = query.date_to   || null;

    const [result] = await pool.query("CALL dashboard_summary(?, ?)", [date_from, date_to]);

    return {
        leads: {
            summary:           result[0][0],
            top_properties:    result[1],
        },
        customers: {
            new_by_month:         result[2],
            by_type:              result[3],
            by_source:            result[4],
            by_agent:             result[5],
            followup_overdue:     result[6][0].clientes_seguimiento_vencido,
        },
        properties: {
            top_viewed:           result[7],
            by_business_status:   result[8],
            by_publication_status:result[9],
            visits_by_day:        result[10],
            featured_active:      result[11][0].propiedades_destacadas,
        },
        transactions: {
            summary:              result[12][0],
            active_reservations:  result[13],
        },
        rent_payments: {
            current_month:        result[14][0],
            income_by_month:      result[15],
            auto_renew_contracts: result[16][0].contratos_auto_renovacion,
        },
    };
};
