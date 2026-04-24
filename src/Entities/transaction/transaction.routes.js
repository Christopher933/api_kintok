const express = require("express");
const router = express.Router();
const controller = require("./transaction.controller");
const { verifyAccess, authorizeModuleAction } = require("../../_shared/token");

router.use(verifyAccess);

router.post("/register", authorizeModuleAction("transaction", "create"), controller.register);
router.get("/property/:property_id", authorizeModuleAction("transaction", "view"), controller.listByProperty);
router.get("/customer/:customer_id", authorizeModuleAction("transaction", "view"), controller.listByCustomer);
router.post("/:transaction_id/cancel", authorizeModuleAction("transaction", "update"), controller.cancelTransaction);
router.post("/:transaction_id/close", authorizeModuleAction("transaction", "update"), controller.closeTransaction);

router.get("/:transaction_id/detail", authorizeModuleAction("transaction", "view"), controller.getDetail);
router.post("/:transaction_id/reservation", authorizeModuleAction("transaction", "update"), controller.saveReservation);
router.post("/:transaction_id/sale", authorizeModuleAction("transaction", "update"), controller.saveSale);
router.post("/:transaction_id/rental", authorizeModuleAction("transaction", "update"), controller.saveRental);

router.get("/:transaction_id/payments", authorizeModuleAction("transaction", "view"), controller.listPayments);
router.post("/:transaction_id/payments/generate", authorizeModuleAction("transaction", "update"), controller.generatePayments);
router.put("/payment/:payment_id", authorizeModuleAction("transaction", "update"), controller.updatePayment);

router.get("/:transaction_id/sale-payments", authorizeModuleAction("transaction", "view"), controller.listSalePayments);
router.post("/:transaction_id/sale-payments/generate", authorizeModuleAction("transaction", "update"), controller.generateSalePayments);
router.put("/sale-payment/:payment_id", authorizeModuleAction("transaction", "update"), controller.updateSalePayment);
router.get("/sale-payment/:payment_id/partialities", authorizeModuleAction("transaction", "view"), controller.listSalePartialities);
router.post("/sale-payment/:payment_id/partial", authorizeModuleAction("transaction", "update"), controller.addSalePartialPayment);
router.get("/payment/:payment_id/partialities", authorizeModuleAction("transaction", "view"), controller.listPartialities);
router.post("/payment/:payment_id/partial", authorizeModuleAction("transaction", "update"), controller.addPartialPayment);

router.get("/:transaction_id/documents", authorizeModuleAction("transaction", "view"), controller.listDocuments);
router.post("/:transaction_id/documents", authorizeModuleAction("transaction", "create"), controller.uploadDocument);
router.delete("/document/:document_id", authorizeModuleAction("transaction", "delete"), controller.deleteDocument);

module.exports = router;
