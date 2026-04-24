const path = require("path");
const fs = require("fs");
const { pool } = require("../../_shared/bd");
const { uploadDoc, uploadDir } = require("../../_shared/multer_docs");
const { useS3, buildS3Key, uploadLocalFile, deleteByKey, keyFromUrl } = require("../../_shared/s3_storage");

const mapDbError = (error) => {
    if (error && error.sqlState === "45000") {
        return { status: 400, message: error.sqlMessage || error.message };
    }
    return error;
};

const extractFirstRow = (callResult) => {
    if (!Array.isArray(callResult)) return null;
    for (const set of callResult) {
        if (Array.isArray(set) && set.length > 0 && typeof set[0] === "object") {
            return set[0];
        }
    }
    return null;
};

const FINANCING_MIN_MONTHS = 1;
const FINANCING_MAX_MONTHS = 240;

const normalizeSaleType = (value) => {
    const raw = String(value || "credito").trim().toLowerCase();
    const norm = raw.replace(/[\s-]+/g, "_");

    if (["contado_unico", "contadounico", "pago_unico", "pagounico"].includes(norm)) {
        return { tipo: "contado", isContadoUnico: true };
    }
    if (norm.startsWith("contado")) {
        return { tipo: "contado", isContadoUnico: false };
    }
    return { tipo: "credito", isContadoUnico: false };
};

const normalizeSalePayload = (sale = {}) => {
    const { tipo, isContadoUnico } = normalizeSaleType(sale.tipo || sale.transaction_type);

    const saldoFinanciar = Number(sale.saldo_financiar);
    if (!Number.isFinite(saldoFinanciar) || saldoFinanciar <= 0) {
        throw { status: 400, message: "saldo_financiar es requerido y debe ser mayor a 0" };
    }

    let plazoMeses = sale.plazo_meses != null ? Number(sale.plazo_meses) : null;
    if (isContadoUnico) {
        plazoMeses = 1;
    } else if (tipo === "contado" && (plazoMeses == null || !Number.isFinite(plazoMeses) || plazoMeses < 1)) {
        plazoMeses = 1;
    }

    if (!Number.isInteger(plazoMeses) || plazoMeses < 1) {
        throw { status: 400, message: "plazo_meses es requerido y debe ser un entero mayor a 0" };
    }
    if (plazoMeses < FINANCING_MIN_MONTHS || plazoMeses > FINANCING_MAX_MONTHS) {
        throw {
            status: 400,
            message: `plazo_meses fuera de rango. Usa valores entre ${FINANCING_MIN_MONTHS} y ${FINANCING_MAX_MONTHS}`,
        };
    }

    let tasaInteresAnual = 0;
    if (tipo === "credito") {
        if (sale.tasa_interes_anual == null || sale.tasa_interes_anual === "") {
            throw { status: 400, message: "tasa_interes_anual es requerida para ventas a crédito" };
        }
        tasaInteresAnual = Number(sale.tasa_interes_anual);
        if (!Number.isFinite(tasaInteresAnual) || tasaInteresAnual < 0) {
            throw { status: 400, message: "tasa_interes_anual debe ser mayor o igual a 0" };
        }
    }

    return {
        tipo,
        start_date: sale.start_date || new Date().toISOString().slice(0, 10),
        payment_day: sale.payment_day || 1,
        enganche: sale.enganche || 0,
        saldo_financiar: saldoFinanciar,
        tasa_interes_anual: tasaInteresAnual,
        plazo_meses: plazoMeses,
    };
};

// ── Transacciones base ────────────────────────────────────────────────────────

exports.register = async (body, actorUserId = null) => {
    if (!body?.property_id || !body?.customer_id || !body?.transaction_type || !body?.currency) {
        throw { status: 400, message: "property_id, customer_id, transaction_type y currency son requeridos" };
    }

    const transactionType = String(body.transaction_type).toLowerCase();
    if (!["apartado", "venta", "renta"].includes(transactionType)) {
        throw { status: 400, message: "transaction_type inválido. Usa: apartado, venta o renta" };
    }

    if (transactionType === "renta" && !body?.rental?.start_date) {
        throw { status: 400, message: "rental.start_date es requerido para transacciones de renta" };
    }

    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();

        const [result] = await conn.query(
            "CALL property_transaction_register(?, ?, ?, ?, ?, ?, ?)",
            [body.property_id, body.customer_id, transactionType, body.final_price || null, body.currency, body.notes || null, actorUserId]
        );
        const firstRow = extractFirstRow(result);
        const transaction_id = Number(firstRow?.property_transaction_id || 0);
        if (!transaction_id) {
            throw { status: 500, message: "No se pudo obtener property_transaction_id al registrar la transacción" };
        }

        if (transactionType === "apartado" && body.reservation) {
            const r = body.reservation;
            await conn.query(
                "CALL transaction_reservation_save(?, ?, ?, ?, ?, ?)",
                [transaction_id, r.deposit_amount || null, r.deposit_currency || "MXN", r.expires_at || null, r.applied_to_sale != null ? Number(r.applied_to_sale) : 0, r.cancellation_policy || null]
            );
        }

        if (transactionType === "venta" && body.sale) {
            const s = normalizeSalePayload(body.sale);
            // SP internamente genera los pagos (sale_payment_generate)
            await conn.query(
                "CALL transaction_sale_save(?, ?, ?, ?, ?, ?, ?, ?)",
                [transaction_id, s.tipo, s.start_date, s.payment_day, s.enganche, s.saldo_financiar, s.tasa_interes_anual, s.plazo_meses]
            );
        }

        if (transactionType === "renta" && body.rental) {
            const r = body.rental;
            // SP internamente genera los pagos (rent_payment_generate)
            await conn.query(
                "CALL transaction_rental_save(?, ?, ?, ?, ?, ?, ?, ?)",
                [transaction_id, r.start_date, r.end_date || null, r.monthly_rent, r.deposit_amount || null, r.deposit_currency || "MXN", r.payment_day || 1, r.auto_renew != null ? Number(r.auto_renew) : 0]
            );
        }

        await conn.commit();
        return { property_transaction_id: transaction_id };
    } catch (error) {
        await conn.rollback();
        throw mapDbError(error);
    } finally {
        conn.release();
    }
};

exports.listByProperty = async (property_id) => {
    const [result] = await pool.query("CALL property_transaction_list_by_property(?)", [property_id]);
    return result[0];
};

exports.listByCustomer = async (customer_id) => {
    const [result] = await pool.query("CALL property_transaction_list_by_customer(?)", [customer_id]);
    return result[0];
};

exports.cancelTransaction = async (transaction_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query("CALL property_transaction_cancel(?, ?, ?)", [Number(transaction_id), body.cancel_reason || null, actorUserId]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.closeTransaction = async (transaction_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query("CALL property_transaction_close(?, ?, ?)", [Number(transaction_id), body.close_reason || null, actorUserId]);
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.getDetail = async (transaction_id) => {
    try {
        // SP devuelve 2 result sets: [0] transacción base, [1] detalle por tipo
        const [result] = await pool.query("CALL property_transaction_detail(?)", [Number(transaction_id)]);
        const transaction = result[0]?.[0];
        if (!transaction) throw { status: 404, message: "Transacción no encontrada" };

        const detail = result[1]?.[0] || null;
        const typeKey = { apartado: "reservation", venta: "sale", renta: "rental" }[transaction.transaction_type];

        return { transaction, [typeKey]: detail };
    } catch (error) {
        throw mapDbError(error);
    }
};

// ── Apartado ──────────────────────────────────────────────────────────────────

exports.saveReservation = async (transaction_id, body) => {
    try {
        const [result] = await pool.query(
            "CALL transaction_reservation_save(?, ?, ?, ?, ?, ?)",
            [Number(transaction_id), body.deposit_amount || null, body.deposit_currency || "MXN", body.expires_at || null, body.applied_to_sale != null ? Number(body.applied_to_sale) : 0, body.cancellation_policy || null]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

// ── Venta ─────────────────────────────────────────────────────────────────────

exports.saveSale = async (transaction_id, body) => {
    const s = normalizeSalePayload(body);
    try {
        // SP internamente genera los pagos (sale_payment_generate)
        const [result] = await pool.query(
            "CALL transaction_sale_save(?, ?, ?, ?, ?, ?, ?, ?)",
            [Number(transaction_id), s.tipo, s.start_date, s.payment_day, s.enganche, s.saldo_financiar, s.tasa_interes_anual, s.plazo_meses]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.listSalePayments = async (transaction_id) => {
    const [result] = await pool.query("CALL sale_payment_list(?)", [Number(transaction_id)]);
    return result[0];
};

exports.listSalePartialities = async (payment_id) => {
    const [result] = await pool.query("CALL sale_payment_partial_list(?)", [Number(payment_id)]);
    return result[0];
};

exports.addSalePartialPayment = async (payment_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query(
            "CALL sale_payment_partial_add(?, ?, ?, ?, ?, ?)",
            [Number(payment_id), body.amount, body.paid_at || null, body.late_fee != null ? body.late_fee : null, body.notes || null, actorUserId]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.generateSalePayments = async (transaction_id) => {
    const [result] = await pool.query("CALL sale_payment_generate(?)", [Number(transaction_id)]);
    return result[0][0];
};

exports.updateSalePayment = async (payment_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query(
            "CALL sale_payment_update(?, ?, ?, ?, ?, ?)",
            [Number(payment_id), body.amount_paid, body.paid_at || null, body.late_fee || null, body.notes || null, actorUserId]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

// ── Renta ─────────────────────────────────────────────────────────────────────

exports.saveRental = async (transaction_id, body) => {
    if (!body?.start_date) {
        throw { status: 400, message: "start_date es requerido" };
    }
    try {
        // SP internamente genera los pagos (rent_payment_generate)
        const [result] = await pool.query(
            "CALL transaction_rental_save(?, ?, ?, ?, ?, ?, ?, ?)",
            [Number(transaction_id), body.start_date, body.end_date || null, body.monthly_rent, body.deposit_amount || null, body.deposit_currency || "MXN", body.payment_day || 1, body.auto_renew != null ? Number(body.auto_renew) : 0]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

// ── Pagos de renta ────────────────────────────────────────────────────────────

exports.listPayments = async (transaction_id) => {
    const [result] = await pool.query("CALL rent_payment_list(?)", [Number(transaction_id)]);
    return result[0];
};

exports.generatePayments = async (transaction_id) => {
    const [result] = await pool.query("CALL rent_payment_generate(?)", [Number(transaction_id)]);
    return result[0][0];
};

exports.updatePayment = async (payment_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query(
            "CALL rent_payment_update(?, ?, ?, ?, ?, ?)",
            [Number(payment_id), body.amount_paid, body.paid_at || null, body.late_fee || null, body.notes || null, actorUserId]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.listPartialities = async (payment_id) => {
    const [result] = await pool.query("CALL rent_payment_partial_list(?)", [Number(payment_id)]);
    return result[0];
};

exports.addPartialPayment = async (payment_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query(
            "CALL rent_payment_partial_add(?, ?, ?, ?, ?, ?)",
            [Number(payment_id), body.amount, body.paid_at || null, body.late_fee != null ? body.late_fee : null, body.notes || null, actorUserId]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

// ── Documentos ────────────────────────────────────────────────────────────────

exports.listDocuments = async (transaction_id) => {
    const [result] = await pool.query("CALL transaction_document_list(?)", [Number(transaction_id)]);
    return result[0];
};

exports.uploadDocument = (transaction_id, req, actorUserId = null) => {
    return new Promise((resolve, reject) => {
        uploadDoc(req, null, async (err) => {
            if (err) return reject(err);
            try {
                if (!req.file) return reject({ status: 400, message: "No se recibió ningún archivo" });
                const { document_type_id, notes } = req.body;
                if (!document_type_id) return reject({ status: 400, message: "document_type_id es requerido" });

                const apiBase = (process.env.API || "http://localhost:3005/api").replace(/\/+$/, "");
                let fileUrl = `${apiBase}/public/uploads/docs/${req.file.filename}`;

                if (useS3) {
                    const [txRows] = await pool.query(
                        "SELECT customer_id FROM property_transaction WHERE id = ? LIMIT 1",
                        [Number(transaction_id)]
                    );
                    const customerIdRef = txRows?.[0]?.customer_id ? `cust${txRows[0].customer_id}` : "custna";
                    const key = buildS3Key({
                        folder: "transaction-documents",
                        entityType: "transaction",
                        entityId: Number(transaction_id),
                        fileType: "document",
                        reference: customerIdRef,
                        originalName: req.file.originalname || req.file.filename,
                        contentType: req.file.mimetype,
                    });
                    const uploaded = await uploadLocalFile({ localPath: req.file.path, key, contentType: req.file.mimetype });
                    fileUrl = uploaded.url;
                    if (fs.existsSync(req.file.path)) fs.unlinkSync(req.file.path);
                }

                const [result] = await pool.query(
                    "CALL transaction_document_add(?, ?, ?, ?, ?, ?)",
                    [Number(transaction_id), Number(document_type_id), fileUrl, req.file.originalname, notes || null, actorUserId]
                );
                resolve({
                    message: "Documento subido correctamente",
                    document_id: result[0][0].transaction_document_id,
                    file_url: fileUrl,
                    file_name: req.file.originalname,
                });
            } catch (error) {
                reject(mapDbError(error));
            }
        });
    });
};

exports.deleteDocument = async (document_id) => {
    const [result] = await pool.query("CALL transaction_document_delete(?)", [Number(document_id)]);
    const row = result[0][0];

    if (row.deleted > 0 && row.file_url) {
        try {
            if (useS3) {
                const s3Key = keyFromUrl(row.file_url);
                if (s3Key) await deleteByKey(s3Key);
            } else {
                const filePath = path.join(uploadDir, path.basename(row.file_url));
                if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
            }
        } catch (_) {
            // Fallo en borrado físico no interrumpe la respuesta
        }
    }

    return { message: "Documento eliminado", deleted: row.deleted };
};
