const express = require("express");
const router = express.Router();
const controller = require("./testimonial.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

router.use(verifyAccess);
router.get("/", authorizeModuleAction("cms", "view"), controller.list);
router.post("/", authorizeModuleAction("cms", "create"), controller.create);
router.put("/:id", authorizeModuleAction("cms", "update"), controller.update);
router.delete("/:id", authorizeModuleAction("cms", "delete"), controller.remove);

module.exports = router;
