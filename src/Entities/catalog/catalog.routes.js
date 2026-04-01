const express = require("express");
const router = express.Router();
const controller = require("./catalog.controller");

router.post("/city/upsert", controller.cityUpsert);
router.post("/zone/upsert", controller.zoneUpsert);
router.post("/amenity/upsert", controller.amenityUpsert);
router.post("/property-type/upsert", controller.propertyTypeUpsert);

module.exports = router;
