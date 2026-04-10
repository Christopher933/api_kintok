const { S3Client, PutObjectCommand, DeleteObjectCommand } = require("@aws-sdk/client-s3");
const fs = require("fs");
const path = require("path");

const region = process.env.AWS_REGION;
const bucket = process.env.S3_BUCKET;
const accessKeyId = process.env.AWS_ACCESS_KEY_ID;
const secretAccessKey = process.env.AWS_SECRET_ACCESS_KEY;
const basePrefix = (process.env.S3_PREFIX || "uploads").replace(/^\/+|\/+$/g, "");

const useS3 = Boolean(region && bucket && accessKeyId && secretAccessKey);

let client = null;
if (useS3) {
    client = new S3Client({
        region,
        credentials: {
            accessKeyId,
            secretAccessKey,
        },
    });
}

const sanitizeSegment = (segment) => {
    return String(segment || "")
        .trim()
        .toLowerCase()
        .replace(/[^a-z0-9-_./]+/g, "-")
        .replace(/\/+/g, "/")
        .replace(/^\/+|\/+$/g, "");
};

const extFromNameOrType = (fileName, contentType) => {
    const extFromName = path.extname(fileName || "");
    if (extFromName) return extFromName.toLowerCase();

    const map = {
        "image/jpeg": ".jpg",
        "image/png": ".png",
        "image/webp": ".webp",
        "application/pdf": ".pdf",
        "application/msword": ".doc",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document": ".docx",
    };
    return map[contentType] || "";
};

const buildS3Key = ({
    folder,
    entityType,
    entityId,
    fileType,
    reference,
    originalName,
    contentType,
    // Compatibilidad con versión anterior:
    area,
    kind,
}) => {
    const safeFolder = sanitizeSegment(folder || area || "misc");
    const safeEntityType = sanitizeSegment(entityType || "entity");
    const safeEntityId = sanitizeSegment(entityId || "0");
    const safeFileType = sanitizeSegment(fileType || kind || "file");
    const safeReference = sanitizeSegment(reference || "");
    const extension = extFromNameOrType(originalName, contentType);
    const timestamp = Date.now();
    const random = Math.round(Math.random() * 1e6);
    const refPart = safeReference ? `_${safeReference}` : "";
    const fileName = `${safeEntityType}_${safeEntityId}${refPart}_${safeFileType}_${timestamp}_${random}${extension}`;

    return [basePrefix, safeFolder, `${safeEntityType}_${safeEntityId}`, fileName]
        .filter(Boolean)
        .join("/");
};

const toPublicUrl = (key) => {
    return `https://${bucket}.s3.${region}.amazonaws.com/${key}`;
};

const uploadLocalFile = async ({ localPath, key, contentType }) => {
    if (!useS3) {
        throw new Error("S3 no configurado. Revisa AWS_REGION, S3_BUCKET, AWS_ACCESS_KEY_ID y AWS_SECRET_ACCESS_KEY");
    }

    const body = fs.readFileSync(localPath);
    await client.send(
        new PutObjectCommand({
            Bucket: bucket,
            Key: key,
            Body: body,
            ContentType: contentType || "application/octet-stream",
        })
    );

    return {
        key,
        url: toPublicUrl(key),
        bucket,
        region,
    };
};

const deleteByKey = async (key) => {
    if (!useS3 || !key) return;
    await client.send(
        new DeleteObjectCommand({
            Bucket: bucket,
            Key: key,
        })
    );
};

const keyFromUrl = (url) => {
    if (!url) return null;
    try {
        const u = new URL(url);
        const hostA = `${bucket}.s3.${region}.amazonaws.com`;
        const hostB = `${bucket}.s3.amazonaws.com`;
        if (u.hostname === hostA || u.hostname === hostB) {
            return u.pathname.replace(/^\//, "");
        }
        return null;
    } catch (_) {
        return null;
    }
};

module.exports = {
    useS3,
    bucket,
    region,
    buildS3Key,
    uploadLocalFile,
    deleteByKey,
    keyFromUrl,
};
