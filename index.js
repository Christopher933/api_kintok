const express = require("express");
const app = express();
const DOTENV = require("dotenv");
const bodyParser = require("body-parser");
const path = require("path");
const fs = require("fs");
const cors = require("cors");

DOTENV.config();

// CORS \\
app.use(cors());
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET,HEAD,OPTIONS,POST,PUT");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, x-client-key, x-client-token, x-client-secret, Authorization, app"
  );
  next();
});

// Función para crear carpeta si no existe
function ensureDir(dirPath) {
  if (!fs.existsSync(dirPath)) {
    fs.mkdirSync(dirPath, { recursive: true });
    console.log(`Carpeta creada: ${dirPath}`);
  }
}

// Rutas de tus carpetas
const publicDir = path.join(__dirname, "./src/public");
const privateDir = path.join(__dirname, "./src/private");

// Asegurarse de que existan
ensureDir(publicDir);
ensureDir(privateDir);

// Montar static
app.use("/api/public", express.static(publicDir));
app.use("/api/private", express.static(privateDir));

// PARSER \\
app.use(bodyParser.json({ limit: "50mb" }));
app.use(bodyParser.urlencoded({ limit: "50mb", extended: true, parameterLimit: 50000 }));

// ROUTES \\
const routes = require("./routes");
app.use("/api", routes);

app.get("/", (req, res) => {
  res.send(
    "<div style='width:100%;height:100%;display:flex;justify-content:center;align-items:center;'><h1>API KINTOK RUNNING</h1></div>"
  );
});

// SERVER \\
const PORT = process.env.PORT || 3005;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}.`);
});
