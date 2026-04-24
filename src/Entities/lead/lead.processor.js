const db = require("../../_shared/bd");
const pool = db.pool;
const email = require("../../_shared/nodemailer");

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
    const { property_id, name, email: clientEmail, phone, comments } = body;
    if (!name || !clientEmail) {
        throw { status: 400, message: "name y email son requeridos" };
    }
    if (!validateEmail(clientEmail)) {
        throw { status: 400, message: "Formato de email inválido" };
    }
    if (phone && !validatePhone(phone)) {
        throw { status: 400, message: "Formato de teléfono inválido" };
    }

    try {
        const skipDuplicate = String(clientEmail).trim().toLowerCase() === "christopher.sandoval93@gmail.com" ? 1 : 0;

        const [result] = await pool.query("CALL lead_contact_register(?, ?, ?, ?, ?, ?)", [
            property_id ? Number(property_id) : null,
            String(name).trim(),
            String(clientEmail).trim().toLowerCase(),
            phone ? String(phone).trim() : null,
            comments || null,
            skipDuplicate,
        ]);

        const lead = result[0][0];

        let propertyTitle = "Información general";
        let propiedadBloque = "";

        if (property_id) {
            const [[p]] = await pool.query(
                `SELECT p.title, p.price_value, p.currency, p.address,
                        o.name AS operacion, pt.name AS tipo
                   FROM property p
                   LEFT JOIN operation o ON o.id = p.operation_id
                   LEFT JOIN property_type pt ON pt.id = p.property_type_id
                  WHERE p.id = ? LIMIT 1`,
                [Number(property_id)]
            );
            if (p) {
                propertyTitle = p.title;
                const precio = p.price_value
                    ? `${Number(p.price_value).toLocaleString("es-MX")} ${p.currency}`
                    : "Precio a consultar";
                propiedadBloque = `
                <table width="100%" cellpadding="0" cellspacing="0" style="border:1px solid #c9a84c; border-radius:6px; margin: 20px 0;">
                  <tr style="background-color:#1a1a2e;">
                    <td style="padding:10px 16px;">
                      <p style="color:#c9a84c; font-size:11px; font-weight:700; letter-spacing:1px; margin:0;">PROPIEDAD DE INTERÉS</p>
                    </td>
                  </tr>
                  <tr>
                    <td style="padding:14px 16px;">
                      <p style="font-size:16px; font-weight:700; color:#1a1a2e; margin-bottom:6px;">${p.title}</p>
                      ${p.tipo || p.operacion ? `<p style="font-size:13px; color:#888; margin-bottom:4px;">${[p.tipo, p.operacion].filter(Boolean).join(" · ")}</p>` : ""}
                      ${p.address ? `<p style="font-size:13px; color:#666; margin-bottom:4px;">${p.address}</p>` : ""}
                      <p style="font-size:15px; color:#c9a84c; font-weight:700; margin-top:8px;">${precio}</p>
                    </td>
                  </tr>
                </table>`;
            }
        }

        const templateVars = [
            { name: "{{NOMBRE}}",            value: String(name).trim() },
            { name: "{{EMAIL}}",             value: String(clientEmail).trim().toLowerCase() },
            { name: "{{TELEFONO}}",          value: phone ? String(phone).trim() : "No proporcionado" },
            { name: "{{INTERES}}",           value: propertyTitle },
            { name: "{{PROPIEDAD_BLOQUE}}", value: propiedadBloque },
            { name: "{{MENSAJE}}",  value: comments || "Sin mensaje" },
            { name: "{{FECHA}}",    value: new Date().toLocaleDateString("es-MX", { day: "2-digit", month: "long", year: "numeric" }) },
            { name: "{{ANIO}}",     value: String(new Date().getFullYear()) },
        ];

        // Correo al cliente — fire and forget
        email.sendEmail({
            template_path: "/templates/contact_form_client.html",
            variables_template: templateVars,
            data_email: { email: [String(clientEmail).trim().toLowerCase()], subject: "Recibimos tu mensaje — Kintok" },
        }).catch(() => {});

        // Correo al equipo interno — fire and forget
        email.sendEmail({
            template_path: "/templates/contact_form_internal.html",
            variables_template: templateVars,
            data_email: { email: ["inversiones@kintok.com.mx"], subject: `Nuevo lead: ${String(name).trim()}` },
        }).catch(() => {});

        return lead;
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

exports.deleteLead = async (id) => {
    const leadId = Number(id);
    if (!leadId || Number.isNaN(leadId)) {
        throw { status: 400, message: "lead_contact_id inválido" };
    }

    try {
        await pool.query("CALL lead_contact_delete(?)", [leadId]);
    } catch (error) {
        throw mapDbError(error);
    }

    return {
        message: "Lead eliminado correctamente",
        lead_contact_id: leadId,
    };
};
