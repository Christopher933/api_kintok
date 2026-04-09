const express = require("express");
const router = express.Router();
const controller = require("./catalog.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

router.post("/city/upsert", verifyAccess, authorizeModuleAction("catalog", "update"), controller.cityUpsert);
router.get("/city/list", controller.cityList);
router.post("/zone/upsert", verifyAccess, authorizeModuleAction("catalog", "update"), controller.zoneUpsert);
router.get("/zone/list", controller.zoneList);
router.post("/amenity/upsert", verifyAccess, authorizeModuleAction("catalog", "update"), controller.amenityUpsert);
router.get("/amenity/list", controller.amenityList);
router.post("/property-type/upsert", verifyAccess, authorizeModuleAction("catalog", "update"), controller.propertyTypeUpsert);
router.get("/property-type/list", controller.propertyTypeList);
router.get("/operation/list", controller.operationList);
router.get("/publication-status/list", controller.publicationStatusList);
router.get("/business-status/list", controller.businessStatusList);
router.get("/document-type/list", controller.documentTypeList);

module.exports = router;
