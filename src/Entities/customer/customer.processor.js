const db = require("../../_shared/bd");
const pool = db.pool;
const path = require("path");
const fs = require("fs");
const { useS3, deleteByKey, keyFromUrl } = require("../../_shared/s3_storage");

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

exports.upsert = async (body, actorUserId = null) => {
    if (!String(body.full_name || "").trim()) {
        throw { status: 400, message: "full_name es requerido" };
    }

    const params = [
        body.id || null,
        String(body.full_name).trim(),
        body.email || null,
        body.phone || null,
        body.customer_type || null,
        body.notes || null,
        body.status ? String(body.status).trim().toLowerCase() : null,
        body.source || null,
        body.assigned_agent_id || null,
        body.last_contact_at || null,
        body.next_follow_up_at || null,
        body.rfc || null,
        body.curp || null,
        body.business_name || null,
        body.razon_social || null,
        body.tipo_persona || null,
        body.billing_email || null,
        body.address_line || null,
        body.address_street || null,
        body.address_number || null,
        body.address_neighborhood || null,
        body.address_city || null,
        body.address_state || null,
        body.address_zip || null,
        body.address_country || null,
        body.preferred_currency || null,
        body.interest_type || null,
        body.interest_zones || null,
        body.interest_property_types || null,
        actorUserId || null,
    ];
    try {
        const [result] = await pool.query(
            "CALL customer_upsert(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            params
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.list = async (query) => {
    const searchRaw = String(query.search ?? query.search_text ?? "").trim();
    const searchLower = searchRaw.toLowerCase();
    const search_text = (
        searchLower === "" ||
        searchLower === "undefined" ||
        searchLower === "null"
    ) ? null : searchRaw;
    const page = parseInt(query.page || query.page_number, 10) || 1;
    const limit = parseInt(query.limit || query.page_size, 10) || 10;
    const statusRaw = String(query.status ?? "").trim().toLowerCase();
    const status = (
        statusRaw === "" ||
        statusRaw === "undefined" ||
        statusRaw === "null"
    ) ? null : statusRaw;
    const customerTypeRaw = String(query.customer_type ?? "").trim();
    const customerTypeLower = customerTypeRaw.toLowerCase();
    const customer_type = (
        customerTypeLower === "" ||
        customerTypeLower === "undefined" ||
        customerTypeLower === "null"
    ) ? null : customerTypeRaw;
    const assignedAgentRaw = String(query.assigned_agent_id ?? "").trim().toLowerCase();
    const assignedAgentNumber = Number(query.assigned_agent_id);
    const assigned_agent_id = (
        assignedAgentRaw === "" ||
        assignedAgentRaw === "undefined" ||
        assignedAgentRaw === "null" ||
        Number.isNaN(assignedAgentNumber)
    ) ? null : assignedAgentNumber;
    try {
        const [result] = await pool.query(
            "CALL customer_list(?, ?, ?, ?, ?, ?)",
            [search_text, status || null, customer_type || null, assigned_agent_id || null, page, limit]
        );

        if (result.length > 1) {
            return {
                meta: result[0][0],
                data: result[1],
            };
        }

        return {
            meta: { total_records: result[0].length, page_number: page, page_size: limit, total_pages: 1 },
            data: result[0],
        };
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.detail = async (customerId) => {
    const id = Number(customerId);
    if (!id) {
        throw { status: 400, message: "customer_id inválido" };
    }
    try {
        const [result] = await pool.query("CALL customer_detail(?)", [id]);
        const customer = result?.[0]?.[0];
        if (!customer) {
            throw { status: 404, message: "Cliente no encontrado" };
        }
        return {
            customer,
            leads: result?.[1] || [],
            transactions: result?.[2] || [],
            payments: result?.[3] || [],
            notes: result?.[4] || [],
        };
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.notesList = async (customerId) => {
    const id = Number(customerId);
    if (!id) {
        throw { status: 400, message: "customer_id inválido" };
    }
    try {
        const [result] = await pool.query("CALL customer_note_list(?)", [id]);
        return {
            customer_id: id,
            data: result?.[0] || [],
        };
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.notesAdd = async (body, actorUserId = null) => {
    const customer_id = Number(body.customer_id);
    const noteRaw = body.note != null ? body.note : body.notes;
    const note = String(noteRaw || "").trim();
    if (!customer_id) {
        throw { status: 400, message: "customer_id es requerido" };
    }
    if (!note) {
        throw { status: 400, message: "note es requerida" };
    }
    try {
        const [result] = await pool.query("CALL customer_note_add(?, ?, ?)", [
            customer_id,
            note,
            actorUserId || null,
        ]);
        return result?.[0]?.[0] || null;
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.deleteCustomer = async (id) => {
    const customerId = Number(id);
    if (!customerId || Number.isNaN(customerId)) {
        throw { status: 400, message: "customer_id inválido" };
    }

    let docUrls = [];
    try {
        const [result] = await pool.query("CALL customer_delete(?)", [customerId]);

        // result[0] contiene los file_urls de documentos transaccionales
        if (result && result[0]) {
            docUrls = result[0].map((r) => r.file_url).filter(Boolean);
        }
    } catch (error) {
        throw mapDbError(error);
    }

    const cleanupErrors = [];
    for (const fileUrl of docUrls) {
        try {
            if (useS3) {
                const s3Key = keyFromUrl(fileUrl);
                if (s3Key) {
                    await deleteByKey(s3Key);
                }
            } else {
                const filename = path.basename(fileUrl);
                const filePath = path.join(__dirname, "../../../public/uploads/docs", filename);
                if (fs.existsSync(filePath)) {
                    fs.unlinkSync(filePath);
                }
            }
        } catch (cleanupError) {
            cleanupErrors.push({
                file_url: fileUrl,
                message: cleanupError?.message || "No se pudo eliminar archivo",
            });
        }
    }

    return {
        message: "Cliente eliminado correctamente",
        customer_id: customerId,
        cleanup_warnings: cleanupErrors,
    };
};
