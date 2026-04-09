const express = require("express");
const router = express.Router();
const controller = require("./user.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

const checkUserUpsertPermission = (req, res, next) => {
  const isCreate = !req.body?.id;
  const action = isCreate ? "create" : "update";
  const guard = authorizeModuleAction("user", action);
  return guard(req, res, next);
};

router.use(verifyAccess);

router.get("/list", authorizeModuleAction("user", "view"), controller.list);
router.get("/detail/:user_id", authorizeModuleAction("user", "view"), controller.detail);
router.post("/upsert", checkUserUpsertPermission, controller.upsert);
router.post("/change-password", authorizeModuleAction("user", "update"), controller.changePassword);

router.get("/roles", authorizeModuleAction("role_permission", "view"), controller.roles);
router.post("/role/upsert", authorizeModuleAction("role_permission", "update"), controller.roleUpsert);
router.delete("/role/:role_id", authorizeModuleAction("role_permission", "delete"), controller.roleDelete);
router.get("/permission/modules", authorizeModuleAction("role_permission", "view"), controller.permissionModules);
router.get("/role/:role_id/permissions", authorizeModuleAction("role_permission", "view"), controller.rolePermissions);
router.put("/role/:role_id/permissions", authorizeModuleAction("role_permission", "update"), controller.rolePermissionsUpsert);

module.exports = router;
