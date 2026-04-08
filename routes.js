const express = require("express");
const router = express.Router();

const auth = require('./src/Entities/auth/auth.routes');
const property = require('./src/Entities/property/property.routes');
const lead = require('./src/Entities/lead/lead.routes');
const catalog = require('./src/Entities/catalog/catalog.routes');
const cms = require('./src/Entities/cms/cms.routes');
const customer = require('./src/Entities/customer/customer.routes');
const transaction = require('./src/Entities/transaction/transaction.routes');

// Usar la ruta
router.use("/auth", auth);
router.use("/property", property);
router.use("/lead", lead);
router.use("/catalog", catalog);
router.use("/cms", cms);
router.use("/customer", customer);
router.use("/transaction", transaction);

module.exports = router;
