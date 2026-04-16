const express = require("express");
const router = express.Router();
const controller = require("./cms.controller");
const testimonialRoutes = require("./testimonial.routes");

router.get("/home", controller.getHomeContent);
router.get("/team", controller.listTeam);
router.use("/testimonials", testimonialRoutes);

module.exports = router;
