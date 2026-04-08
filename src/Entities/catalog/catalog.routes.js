const express = require("express");
const router = express.Router();
const controller = require("./catalog.controller");

router.post("/city/upsert", controller.cityUpsert);
router.get("/city/list", controller.cityList);
router.post("/zone/upsert", controller.zoneUpsert);
router.get("/zone/list", controller.zoneList);
router.post("/amenity/upsert", controller.amenityUpsert);
router.get("/amenity/list", controller.amenityList);
router.post("/property-type/upsert", controller.propertyTypeUpsert);
router.get("/property-type/list", controller.propertyTypeList);
router.get("/operation/list", controller.operationList);
router.get("/publication-status/list", controller.publicationStatusList);
router.get("/business-status/list", controller.businessStatusList);

module.exports = router;
