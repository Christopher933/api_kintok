const sharp = require("sharp");
const path = require("path");
const fs = require("fs");

/**
 * Procesa una imagen: la redimensiona (opcional) y la convierte a WebP con calidad optimizada.
 * @param {string} inputPath Ruta del archivo original
 * @param {string} outputDir Directorio de salida
 * @returns {Promise<string>} Nombre del nuevo archivo WebP
 */
exports.processToWebP = async (inputPath, outputDir) => {
    const filename = path.parse(inputPath).name + "-" + Date.now() + ".webp";
    const outputPath = path.join(outputDir, filename);

    await sharp(inputPath)
        .resize(1200, 800, {
            fit: "inside",
            withoutEnlargement: true,
        })
        .webp({ quality: 80 }) // Calidad 80 es un buen balance entre peso y calidad
        .toFile(outputPath);

    // Eliminar el original despues de procesar
    if (fs.existsSync(inputPath)) {
        fs.unlinkSync(inputPath);
    }

    return filename;
};
