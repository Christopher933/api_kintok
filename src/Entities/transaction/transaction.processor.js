const path = require("path");
const fs = require("fs");
const { pool } = require("../../_shared/bd");
const { uploadDoc, uploadDir } = require("../../_shared/multer_docs");
const { useS3, buildS3Key, uploadLocalFile, deleteByKey, keyFromUrl } = require("../../_shared/s3_storage");

// ── Transacciones base ────────────────────────────────────────────────────────

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

exports.register = async (body, actorUserId = null) => {
    if (!body?.property_id || !body?.customer_id || !body?.transaction_type || !body?.currency) {
        throw { status: 400, message: "property_id, customer_id, transaction_type y currency son requeridos" };
    }

    const transactionType = String(body.transaction_type || "").toLowerCase();
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
            [
                body.property_id,
                body.customer_id,
                transactionType,
                body.final_price || null,
                body.currency,
                body.notes || null,
                actorUserId,
            ]
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
                [
                    transaction_id,
                    r.deposit_amount || null,
                    r.deposit_currency || "MXN",
                    r.expires_at || null,
                    r.applied_to_sale != null ? Number(r.applied_to_sale) : 0,
                    r.cancellation_policy || null,
                ]
            );
        }

        if (transactionType === "renta" && body.rental) {
            const r = body.rental;
            await conn.query(
                "CALL transaction_rental_save(?, ?, ?, ?, ?, ?, ?, ?)",
                [
                    transaction_id,
                    r.start_date,
                    r.end_date || null,
                    r.monthly_rent,
                    r.deposit_amount || null,
                    r.deposit_currency || "MXN",
                    r.payment_day || 1,
                    r.auto_renew != null ? Number(r.auto_renew) : 0,
                ]
            );
            await conn.query("CALL rent_payment_generate(?)", [transaction_id]);
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
    const [result] = await pool.query(
        "CALL property_transaction_list_by_property(?)",
        [property_id]
    );
    return result[0];
};

exports.listByCustomer = async (customer_id) => {
    const [result] = await pool.query(
        "CALL property_transaction_list_by_customer(?)",
        [customer_id]
    );
    return result[0];
};

exports.cancelTransaction = async (transaction_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query(
            "CALL property_transaction_cancel(?, ?, ?)",
            [
                Number(transaction_id),
                body.cancel_reason || null,
                actorUserId,
            ]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.closeTransaction = async (transaction_id, body, actorUserId = null) => {
    try {
        const [result] = await pool.query(
            "CALL property_transaction_close(?, ?, ?)",
            [
                Number(transaction_id),
                body.close_reason || null,
                actorUserId,
            ]
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

exports.getDetail = async (transaction_id) => {
    const [base] = await pool.query(
        `SELECT pt.*,
                p.title AS property_title,
                c.full_name AS customer_name, c.email AS customer_email, c.phone AS customer_phone,
                u.full_name AS registered_by
           FROM property_transaction pt
           JOIN property p  ON p.id = pt.property_id
           JOIN customer c  ON c.id = pt.customer_id
           LEFT JOIN \`user\` u ON u.id = pt.created_by
          WHERE pt.id = ?`,
        [transaction_id]
    );

    if (!base.length) throw { status: 404, message: "Transacción no encontrada" };

    const transaction = base[0];
    const result = { transaction };

    if (transaction.transaction_type === "apartado") {
        const [res] = await pool.query(
            "SELECT * FROM transaction_reservation WHERE transaction_id = ?",
            [transaction_id]
        );
        result.reservation = res[0] || null;
    }

    if (transaction.transaction_type === "renta") {
        const [res] = await pool.query(
            "SELECT * FROM transaction_rental WHERE transaction_id = ?",
            [transaction_id]
        );
        result.rental = res[0] || null;
    }

    return result;
};

// ── Apartado ──────────────────────────────────────────────────────────────────

exports.saveReservation = async (transaction_id, body) => {
    const params = [
        Number(transaction_id),
        body.deposit_amount || null,
        body.deposit_currency || "MXN",
        body.expires_at || null,
        body.applied_to_sale != null ? Number(body.applied_to_sale) : 0,
        body.cancellation_policy || null,
    ];
    const [result] = await pool.query(
        "CALL transaction_reservation_save(?, ?, ?, ?, ?, ?)",
        params
    );
    return result[0][0];
};

// ── Renta ─────────────────────────────────────────────────────────────────────

exports.saveRental = async (transaction_id, body) => {
    if (!body?.start_date) {
        throw { status: 400, message: "start_date es requerido" };
    }

    const params = [
        Number(transaction_id),
        body.start_date,
        body.end_date || null,
        body.monthly_rent,
        body.deposit_amount || null,
        body.deposit_currency || "MXN",
        body.payment_day || 1,
        body.auto_renew != null ? Number(body.auto_renew) : 0,
    ];
    const conn = await pool.getConnection();
    try {
        await conn.beginTransaction();
        const [result] = await conn.query(
            "CALL transaction_rental_save(?, ?, ?, ?, ?, ?, ?, ?)",
            params
        );
        // Mantener consistencia con register: renta siempre genera pagos.
        await conn.query("CALL rent_payment_generate(?)", [Number(transaction_id)]);
        await conn.commit();
        return result[0][0];
    } catch (error) {
        await conn.rollback();
        throw mapDbError(error);
    } finally {
        conn.release();
    }
};

// ── Pagos de renta ────────────────────────────────────────────────────────────

exports.listPayments = async (transaction_id) => {
    const [result] = await pool.query("CALL rent_payment_list(?)", [transaction_id]);
    return result[0];
};

exports.generatePayments = async (transaction_id) => {
    const [result] = await pool.query("CALL rent_payment_generate(?)", [transaction_id]);
    return result[0][0];
};

exports.updatePayment = async (payment_id, body, actorUserId = null) => {
    const params = [
        Number(payment_id),
        body.amount_paid,
        body.paid_at || null,
        body.late_fee || null,
        body.notes || null,
        actorUserId,
    ];
    try {
        const [result] = await pool.query(
            "CALL rent_payment_update(?, ?, ?, ?, ?, ?)",
            params
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
    const params = [
        Number(payment_id),
        body.amount,
        body.paid_at || null,
        body.late_fee != null ? body.late_fee : null,
        body.notes || null,
        actorUserId,
    ];
    try {
        const [result] = await pool.query(
            "CALL rent_payment_partial_add(?, ?, ?, ?, ?, ?)",
            params
        );
        return result[0][0];
    } catch (error) {
        throw mapDbError(error);
    }
};

// ── Documentos ────────────────────────────────────────────────────────────────

exports.listDocuments = async (transaction_id) => {
    const [result] = await pool.query("CALL transaction_document_list(?)", [transaction_id]);
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
                    const uploaded = await uploadLocalFile({
                        localPath: req.file.path,
                        key,
                        contentType: req.file.mimetype,
                    });
                    fileUrl = uploaded.url;
                    if (fs.existsSync(req.file.path)) fs.unlinkSync(req.file.path);
                }

                const [result] = await pool.query(
                    "CALL transaction_document_add(?, ?, ?, ?, ?, ?)",
                    [
                        Number(transaction_id),
                        Number(document_type_id),
                        fileUrl,
                        req.file.originalname,
                        notes || null,
                        actorUserId,
                    ]
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
    const [result] = await pool.query("CALL transaction_document_delete(?)", [document_id]);
    const row = result[0][0];

    if (row.deleted > 0 && row.file_url) {
        try {
            if (useS3) {
                const s3Key = keyFromUrl(row.file_url);
                if (s3Key) await deleteByKey(s3Key);
            } else {
                const filename = path.basename(row.file_url);
                const filePath = path.join(uploadDir, filename);
                if (fs.existsSync(filePath)) fs.unlinkSync(filePath);
            }
        } catch (_) {
            // Si falla el borrado físico no interrumpimos la respuesta
        }
    }

    return { message: "Documento eliminado", deleted: row.deleted };
};
