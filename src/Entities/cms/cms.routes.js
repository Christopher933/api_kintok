const express = require("express");
const router = express.Router();
const controller = require("./cms.controller");

router.get("/home", controller.getHomeContent);
router.get("/team", controller.listTeam);

module.exports = router;
