const multer = require("multer");
const path = require("path");
const fs = require("fs");
const sharp = require("sharp");

// Ruta del directorio de almacenamiento
const uploadDir = path.join(__dirname, "../uploads");

// Verificar si el directorio uploads existe, si no, crearlo
if (!fs.existsSync(uploadDir)) {
  fs.mkdirSync(uploadDir);
}

// Configuración de Multer para el almacenamiento de archivos
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadDir); // Carpeta donde se almacenarán los archivos
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname); // Nombre de archivo personalizado
  },
});

// Límite de tamaño para la imagen
const MAX_WIDTH = 1200; // Máximo ancho de la imagen
const MAX_HEIGHT = 630; // Máxima altura de la imagen

// Función para redimensionar la imagen
const resizeImage = (filePath, width, height) => {
  return sharp(filePath)
    .resize(width, height, {
      fit: sharp.fit.inside, // Redimensiona manteniendo las proporciones
      withoutEnlargement: true, // No aumentar la imagen si es más pequeña
    })
    .toBuffer(); // Devuelve el buffer de la imagen redimensionada
};

// Configuración de Multer con opciones
const upload = multer({ 
  storage: storage,
  limits: {
    // Establecer límites para el tamaño de los datos
    // fieldSize: 1024 * 1024 * 10,
    // fileSize: 1024 * 1024 * 10,  
  },
}).single("file"); // Cambia "file" si tu campo se llama de otra manera

// Middleware para redimensionar la imagen si excede los límites
const processImage = async (req, res, next) => {
  if (req.file) {
    const filePath = path.join(uploadDir, req.file.filename);

    // Obtener las dimensiones de la imagen
    const { width, height } = await sharp(filePath).metadata();

    // Verificar si la imagen excede los límites
    if (width > MAX_WIDTH || height > MAX_HEIGHT) {
      // Redimensionar la imagen
      try {
        const resizedBuffer = await resizeImage(filePath, MAX_WIDTH, MAX_HEIGHT);

        // Sobrescribir el archivo original con la versión redimensionada
        fs.writeFileSync(filePath, resizedBuffer);

        console.log(`Imagen redimensionada a ${MAX_WIDTH}x${MAX_HEIGHT}`);
      } catch (error) {
        console.error("Error al redimensionar la imagen:", error);
      }
    }
  }

  next();
};

// Exportar el middleware para usarlo en las rutas
module.exports = { upload, processImage };
