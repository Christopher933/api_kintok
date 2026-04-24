const express = require("express");
const router = express.Router();
const controller = require("./financing_config.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

router.use(verifyAccess);

router.get("/", authorizeModuleAction("transaction", "view"), controller.getConfig);
router.put("/", authorizeModuleAction("transaction", "update"), controller.updateConfig);
router.post("/simulate", authorizeModuleAction("transaction", "view"), controller.simulatePlan);

module.exports = router;
