const express = require("express");
const router = express.Router();
const controller = require("./property.controller");

router.get("/featured", controller.listFeatured);
router.get("/detail/:id", controller.getDetail);
router.post("/visit", controller.visitIncrement);
router.post("/search", controller.search);
router.post("/upsert", controller.upsert);

// Imágenes
router.post("/image/upload", controller.uploadImages);
router.post("/image/sort", controller.sortImages);
router.delete("/image/:id", controller.deleteImage);
router.post("/status/update", controller.updateStatus);

module.exports = router;
