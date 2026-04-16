const express = require("express");
const router = express.Router();
const controller = require("./dashboard.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

router.use(verifyAccess);
router.get("/summary", authorizeModuleAction("dashboard", "view"), controller.summary);

module.exports = router;
