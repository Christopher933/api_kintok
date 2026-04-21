const db = require("../../_shared/bd");
const pool = db.pool;
const { uploadMulti, uploadDir } = require("../../_shared/multer_multi");
const { processToWebP } = require("../../_shared/image_processor");
const { useS3, buildS3Key, uploadLocalFile, deleteByKey, keyFromUrl } = require("../../_shared/s3_storage");
const path = require("path");
const fs = require("fs");

exports.listFeatured = async (query) => {
    const { page_number, page_size } = query;
    const [result] = await pool.query("CALL property_list_featured(?, ?)", [
        parseInt(page_number) || 1,
        parseInt(page_size) || 10,
    ]);
    return {
        meta: result[0][0],
        data: result[1],
    };
};

const normalizeOverdueStatus = (value) => {
    if (value === undefined || value === null) return null;
    const normalized = String(value).trim().toLowerCase();
    if (!normalized || normalized === "undefined" || normalized === "null" || normalized === "todos") {
        return null;
    }
    if (!["atrasado", "parcial"].includes(normalized)) {
        throw { status: 400, message: "status inválido. Usa: atrasado, parcial o todos" };
    }
    return normalized;
};

exports.getDetail = async (id) => {
    const [result] = await pool.query("CALL property_get_detail(?)", [id]);
    if (!result?.[0]?.[0]) {
        throw { status: 404, message: "Propiedad no encontrada" };
    }
    return {
        property: result[0][0],
        industrial: result[1][0] || null,
        residential: result[2][0] || null,
        land: result[3][0] || null,
        amenities: result[4],
        images: result[5],
        agents: result[6],
        active_transaction: result[7][0] || null,
        current_payment: result[8][0] || null,
    };
};

exports.visitIncrement = async (body) => {
    const { property_id, ip_address, user_agent } = body;
    await pool.query("CALL property_visit_increment(?, ?, ?)", [property_id, ip_address, user_agent]);
    return { message: "Visit incremented" };
};

exports.search = async (body) => {
    const {
        property_type_id,
        operation_id,
        city_id,
        zone_id,
        min_area,
        max_area,
        min_price,
        max_price,
        target_currency,
        featured_only,
        search_text,
        // Advanced: Residential
        min_bedrooms,
        min_bathrooms,
        min_parking,
        pets_allowed,
        // Advanced: Industrial
        min_clear_height,
        min_docks,
        min_power_kva,
        industrial_park,
        // Advanced: Land
        land_use_id,
        // Amenities (array of names)
        amenities,
        // Pagination
        page_number,
        page_size,
        // Status filters (admin)
        publication_status,
        business_status,
    } = body;

    // Convert amenities array to comma-separated string for the SP
    const amenitiesStr = Array.isArray(amenities) && amenities.length > 0
        ? amenities.join(',')
        : null;

    const [result] = await pool.query(
        "CALL property_search(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        [
            property_type_id || null,
            operation_id || null,
            city_id || null,
            zone_id || null,
            min_area || null,
            max_area || null,
            min_price || null,
            max_price || null,
            target_currency || null,
            featured_only === undefined ? null : featured_only,
            search_text || null,
            min_bedrooms || null,
            min_bathrooms || null,
            min_parking || null,
            pets_allowed === undefined ? null : (pets_allowed ? 1 : null),
            min_clear_height || null,
            min_docks || null,
            min_power_kva || null,
            industrial_park === undefined ? null : (industrial_park ? 1 : null),
            land_use_id || null,
            amenitiesStr,
            parseInt(page_number) || 1,
            parseInt(page_size) || 10,
            publication_status || null,
            business_status || null,
        ]
    );
    return {
        meta: result[0][0],
        data: result[1],
    };
};

exports.upsert = async (body) => {
    const amenitiesJson = Array.isArray(body.amenities) && body.amenities.length > 0
        ? JSON.stringify(body.amenities)
        : null;

    const params = [
        body.id || null,
        body.property_type_id,
        body.operation_id,
        body.city_id,
        body.zone_id,
        body.address || null,
        body.latitude || null,        // NEW
        body.longitude || null,       // NEW
        body.title,
        body.description || null,
        body.construction_area ?? body.area_value ?? null,
        body.land_area ?? null,
        body.price_value || null,
        body.enganche || null,
        body.currency,
        body.is_featured || 0,
        body.publication_status_id || null,
        body.business_status_id || null,
        body.clear_height || null,
        body.docks || null,
        body.power_kva || null,
        body.industrial_park || null,
        body.floor_resistance || null,
        body.bedrooms || null,
        body.bathrooms || null,
        body.parking || null,
        body.pets_allowed || 0,
        body.is_furnished || 0,
        body.age || null,
        body.land_use_id || null,
        body.frontage || null,
        body.depth || null,
        body.topography_id || null,
        amenitiesJson,
    ];
    const [result] = await pool.query(
        "CALL property_upsert(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
        params
    );
    return result[0][0];
};

exports.uploadImages = (req) => {
    return new Promise((resolve, reject) => {
        uploadMulti(req, null, async (err) => {
            if (err) return reject(err);
            try {
                if (!req.files || req.files.length === 0) {
                    return reject({ status: 400, message: "No files uploaded" });
                }

                let property_id = req.body.property_id;
                if (!property_id || property_id === "undefined") {
                    return reject({ status: 400, message: "property_id is required and must be valid" });
                }
                property_id = Number(property_id);
                if (isNaN(property_id)) return reject({ status: 400, message: "property_id must be a number" });

                const savedImages = [];
                const apiBase = (process.env.API || "http://localhost:3005/api").replace(/\/+$/, "");
                for (const file of req.files) {
                    const webpFilename = await processToWebP(file.path, uploadDir);
                    const webpPath = path.join(uploadDir, webpFilename);
                    let imageUrl = `${apiBase}/public/uploads/${webpFilename}`;

                    if (useS3) {
                        const key = buildS3Key({
                            folder: "property-photos",
                            entityType: "property",
                            entityId: property_id,
                            fileType: "photo",
                            reference: `prop${property_id}`,
                            originalName: webpFilename,
                            contentType: "image/webp",
                        });
                        const uploaded = await uploadLocalFile({
                            localPath: webpPath,
                            key,
                            contentType: "image/webp",
                        });
                        imageUrl = uploaded.url;
                        if (fs.existsSync(webpPath)) fs.unlinkSync(webpPath);
                    }

                    // Guardar en DB usando el nuevo SP
                    const [result] = await pool.query(
                        "CALL property_image_add(?, ?, ?)",
                        [property_id, imageUrl, 0] // 0 para que el SP calcule el siguiente orden
                    );

                    savedImages.push({ id: result[0][0].property_image_id, url: imageUrl });
                }

                resolve({ message: "Images uploaded successfully", images: savedImages });
            } catch (error) {
                reject(error);
            }
        });
    });
};

exports.sortImages = async (body) => {
    const { property_id, images } = body; // images: Array de { id, order }
    await pool.query("CALL property_image_reorder_all(?, ?)", [property_id, JSON.stringify(images)]);
    return { message: "Images sorted successfully" };
};

exports.deleteImage = async (id) => {
    // Buscar la ruta del archivo primero
    const [rows] = await pool.query("SELECT image_url FROM property_image WHERE id = ?", [id]);
    if (rows.length > 0) {
        const imageUrl = rows[0].image_url;
        if (useS3) {
            const s3Key = keyFromUrl(imageUrl);
            if (s3Key) {
                await deleteByKey(s3Key);
            }
        } else {
            const filename = path.basename(imageUrl);
            const filePath = path.join(uploadDir, filename);
            if (fs.existsSync(filePath)) {
                fs.unlinkSync(filePath);
            }
        }
    }

    await pool.query("CALL property_image_delete(?)", [id]);
    return { message: "Image deleted successfully" };
};

exports.updateStatus = async (body, actorUserId = null) => {
    const params = [
        body.property_id,
        body.publication_status_id || null,
        body.business_status_id || null,
        actorUserId,
        body.change_notes || null,
    ];
    await pool.query("CALL property_status_update(?, ?, ?, ?, ?)", params);
    return { message: "Status updated successfully" };
};

exports.listOverdue = async (query) => {
    const status = normalizeOverdueStatus(query.status);
    const normalizeOptionalInt = (value) => {
        if (value === undefined || value === null) return null;
        const asText = String(value).trim().toLowerCase();
        if (!asText || asText === "undefined" || asText === "null") return null;
        const numberValue = Number(value);
        return Number.isNaN(numberValue) ? null : numberValue;
    };
    const searchText = (() => {
        if (query.search_text === undefined || query.search_text === null) return null;
        const value = String(query.search_text).trim();
        if (!value || value === "undefined" || value === "null") return null;
        return value;
    })();

    const [result] = await pool.query(
        "CALL property_overdue_list(?, ?, ?, ?, ?, ?)",
        [
            searchText,
            normalizeOptionalInt(query.city_id),
            normalizeOptionalInt(query.zone_id),
            status,
            parseInt(query.page_number, 10) || 1,
            parseInt(query.page_size, 10) || 15,
        ]
    );

    return {
        meta: result?.[0]?.[0] || { total_records: 0, page_number: 1, page_size: 15, total_pages: 0 },
        data: result?.[1] || [],
    };
};

exports.deleteProperty = async (id) => {
    const propertyId = Number(id);
    if (!propertyId || Number.isNaN(propertyId)) {
        throw { status: 400, message: "property_id inválido" };
    }

    try {
        const [result] = await pool.query("CALL property_delete(?)", [propertyId]);
        
        // result[0] contiene los image_urls
        // result[1] contiene los file_urls
        if (result && result[0]) {
            imageUrls = result[0].map((r) => r.image_url).filter(Boolean);
        }
        if (result && result[1]) {
            docUrls = result[1].map((r) => r.file_url).filter(Boolean);
        }
    } catch (error) {
        throw mapDbError(error);
    }

    // Limpieza física despues del commit para no romper integridad de DB si falla S3/local.
    const cleanupErrors = [];
    const allFiles = [...imageUrls, ...docUrls];

    for (const fileUrl of allFiles) {
        try {
            if (useS3) {
                const s3Key = keyFromUrl(fileUrl);
                if (s3Key) {
                    await deleteByKey(s3Key);
                }
            } else {
                const filename = path.basename(fileUrl);
                // Distinguir si es imagen o documento por la ruta local
                const isDoc = fileUrl.includes("/docs/");
                const filePath = isDoc 
                    ? path.join(__dirname, "../../../public/uploads/docs", filename)
                    : path.join(uploadDir, filename);
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
        message: "Propiedad eliminada correctamente",
        property_id: propertyId,
        cleanup_warnings: cleanupErrors,
    };
};
