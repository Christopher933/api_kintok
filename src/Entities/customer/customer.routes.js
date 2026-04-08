const express = require("express");
const router = express.Router();
const controller = require("./customer.controller");

router.post("/upsert", controller.upsert);
router.get("/list", controller.list);

module.exports = router;
