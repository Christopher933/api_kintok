const express = require("express");
const router = express.Router();
const controller = require("./transaction.controller");

router.post("/register", controller.register);
router.get("/property/:property_id", controller.listByProperty);
router.get("/customer/:customer_id", controller.listByCustomer);

module.exports = router;
