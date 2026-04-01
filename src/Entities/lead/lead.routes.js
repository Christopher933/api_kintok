const express = require("express");
const router = express.Router();
const controller = require("./lead.controller");

router.post("/register", controller.register);
router.get("/list", controller.list);
router.put("/status", controller.statusUpdate);

module.exports = router;
