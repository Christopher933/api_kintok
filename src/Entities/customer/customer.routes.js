const express = require("express");
const router = express.Router();
const controller = require("./customer.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

router.use(verifyAccess);
router.get("/list", authorizeModuleAction("customer", "view"), controller.list);
router.get("/detail/:customer_id", authorizeModuleAction("customer", "view"), controller.detail);
router.post("/upsert", authorizeModuleAction("customer", "update"), controller.upsert);
router.get("/notes", authorizeModuleAction("customer", "view"), controller.notesList);
router.post("/notes", authorizeModuleAction("customer", "create"), controller.notesAdd);
router.put("/notes", authorizeModuleAction("customer", "create"), controller.notesAdd);
router.delete("/:customer_id", authorizeModuleAction("customer", "delete"), controller.deleteCustomer);

module.exports = router;
