const express = require("express");
const router = express.Router();
const controller = require("./property.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

router.get("/featured", controller.listFeatured);
router.get("/detail/:id", controller.getDetail);
router.post("/visit", controller.visitIncrement);
router.post("/search", controller.search);
router.post("/upsert", verifyAccess, authorizeModuleAction("property", "create"), controller.upsert);

// Imágenes
router.post("/image/upload", verifyAccess, authorizeModuleAction("property", "update"), controller.uploadImages);
router.post("/image/sort", verifyAccess, authorizeModuleAction("property", "update"), controller.sortImages);
router.delete("/image/:id", verifyAccess, authorizeModuleAction("property", "delete"), controller.deleteImage);
router.post("/status/update", verifyAccess, authorizeModuleAction("property", "update"), controller.updateStatus);

module.exports = router;
