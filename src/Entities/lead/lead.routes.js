const express = require("express");
const router = express.Router();
const controller = require("./lead.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

// Público (formulario app)
router.post("/register", controller.register);

// Admin
router.use(verifyAccess);

router.get("/list", authorizeModuleAction("lead", "view"), controller.list);
router.get("/status/catalog", authorizeModuleAction("lead", "view"), controller.statusCatalog);
router.put("/status", authorizeModuleAction("lead", "update"), controller.statusUpdate);
router.get("/notes", authorizeModuleAction("lead", "view"), controller.notesList);
router.post("/notes", authorizeModuleAction("lead", "create"), controller.notesAdd);
router.put("/notes", authorizeModuleAction("lead", "create"), controller.notesAdd); // compatibilidad con front actual
router.post("/convert", authorizeModuleAction("lead", "update"), controller.convertToCustomer);

module.exports = router;
