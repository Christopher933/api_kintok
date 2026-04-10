const db = require("../../_shared/bd");
const pool = db.pool;

const ALLOWED_LEAD_STATUS = ["nuevo", "contactado", "calificado", "cerrado"];

const mapDbError = (error) => {
    if (error && error.sqlState === "45000") {
        const message = error.sqlMessage || error.message || "Error de negocio";
        if (String(message).toLowerCase().includes("no encontrado")) {
            return { status: 404, message };
        }
        return { status: 400, message: error.sqlMessage || error.message };
    }
    return error;
};

const validateEmail = (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(String(value || "").trim());
const validatePhone = (value) => /^[0-9+\-()\s]{7,20}$/.test(String(value || "").trim());

exports.register = async (body) => {
    const { property_id, name, email, phone, comments } = body;
    if (!property_id || !name || !email) {
        throw { status: 400, message: "property_id, name y email son requeridos" };
    }
    if (!validateEmail(email)) {
        throw { status: 400, message: "Formato de email inválido" };
    }
    if (phone && !validatePhone(phone)) {
        throw { status: 400, message: "Formato de teléfono inválido" };
    }

    try {
        const [result] = await pool.query("CALL lead_contact_register(?, ?, ?, ?, ?)", [
            Number(property_id),
            String(name).trim(),
            String(email).trim().toLowerCase(),
            phone ? String(phone).trim() : null,
            comments || null,
        ]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.list = async (query) => {
    const { status, page_number, page_size } = query;
    const normalizedStatusRaw = String(status ?? "").trim().toLowerCase();
    const normalizedStatus = (
        normalizedStatusRaw === "" ||
        normalizedStatusRaw === "undefined" ||
        normalizedStatusRaw === "null"
    )
        ? null
        : normalizedStatusRaw;

    if (normalizedStatus && !ALLOWED_LEAD_STATUS.includes(normalizedStatus)) {
        throw { status: 400, message: `status inválido. Usa: ${ALLOWED_LEAD_STATUS.join(", ")}` };
    }
    const [result] = await pool.query("CALL lead_contact_list_with_customer(?, ?, ?)", [
        normalizedStatus,
        parseInt(page_number) || 1,
        parseInt(page_size) || 10,
    ]);
    return {
        meta: result[0][0],
        data: result[1],
    };
};

exports.detail = async (lead_contact_id) => {
    const id = Number(lead_contact_id);
    if (!id || Number.isNaN(id)) {
        throw { status: 400, message: "lead_contact_id inválido" };
    }

    const [rows] = await pool.query(
        `SELECT
            l.id,
            l.property_id,
            p.title AS property_title,
            l.name,
            l.email,
            l.phone,
            l.comments,
            l.status,
            l.customer_id,
            c.full_name AS customer_name,
            c.email AS customer_email,
            c.phone AS customer_phone,
            IF(l.customer_id IS NULL, 0, 1) AS is_converted,
            l.changed_by,
            uc.full_name AS changed_by_name,
            l.converted_by,
            uv.full_name AS converted_by_name,
            l.converted_at,
            l.conversion_notes,
            l.created_at,
            l.updated_at
        FROM lead_contact l
        LEFT JOIN property p ON p.id = l.property_id
        LEFT JOIN customer c ON c.id = l.customer_id
        LEFT JOIN \`user\` uc ON uc.id = l.changed_by
        LEFT JOIN \`user\` uv ON uv.id = l.converted_by
        WHERE l.id = ?
        LIMIT 1`,
        [id]
    );

    if (!rows.length) {
        throw { status: 404, message: "Lead no encontrado" };
    }

    const [notesResult] = await pool.query("CALL lead_contact_notes_list(?)", [id]);

    return {
        lead: rows[0],
        notes: notesResult?.[0] || [],
    };
};

exports.statusCatalog = async () => {
    return {
        statuses: ALLOWED_LEAD_STATUS.map((value) => ({ value, label: value })),
    };
};

exports.statusUpdate = async (body, actorUserId = null) => {
    const { lead_contact_id, status } = body;
    if (!lead_contact_id || !status) {
        throw { status: 400, message: "lead_contact_id y status son requeridos" };
    }
    const normalizedStatus = String(status).toLowerCase();
    if (!ALLOWED_LEAD_STATUS.includes(normalizedStatus)) {
        throw { status: 400, message: `status inválido. Usa: ${ALLOWED_LEAD_STATUS.join(", ")}` };
    }
    try {
        const [result] = await pool.query("CALL lead_contact_status_update(?, ?, ?)", [
            Number(lead_contact_id),
            normalizedStatus,
            actorUserId || null,
        ]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.notesAdd = async (body, actorUserId = null) => {
    const { lead_contact_id } = body;
    const noteRaw = body.note != null ? body.note : body.notes;
    const note = noteRaw != null ? String(noteRaw).trim() : "";
    if (!lead_contact_id) {
        throw { status: 400, message: "lead_contact_id es requerido" };
    }
    if (!note) {
        throw { status: 400, message: "note es requerida" };
    }
    try {
        const [result] = await pool.query("CALL lead_contact_notes_update(?, ?, ?)", [
            Number(lead_contact_id),
            note,
            actorUserId || null,
        ]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.notesList = async (query) => {
    const { lead_contact_id } = query;
    if (!lead_contact_id) {
        throw { status: 400, message: "lead_contact_id es requerido" };
    }
    try {
        const [result] = await pool.query("CALL lead_contact_notes_list(?)", [Number(lead_contact_id)]);
        return {
            lead_contact_id: Number(lead_contact_id),
            data: result[0],
        };
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.convertToCustomer = async (body, actorUserId = null) => {
    const { lead_contact_id, customer_type, notes } = body;
    if (!lead_contact_id) {
        throw { status: 400, message: "lead_contact_id es requerido" };
    }
    try {
        const [result] = await pool.query("CALL lead_contact_convert_to_customer(?, ?, ?, ?)", [
            Number(lead_contact_id),
            customer_type || "comprador",
            notes || null,
            actorUserId || null,
        ]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};
