const processor = require("./transaction.processor");

// ── Transacciones base ────────────────────────────────────────────────────────

exports.register = async (req, res) => {
    try {
        const data = await processor.register(req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.listByProperty = async (req, res) => {
    try {
        const data = await processor.listByProperty(req.params.property_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.listByCustomer = async (req, res) => {
    try {
        const data = await processor.listByCustomer(req.params.customer_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.cancelTransaction = async (req, res) => {
    try {
        const data = await processor.cancelTransaction(
            req.params.transaction_id,
            req.body,
            req.user?.id || null
        );
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.closeTransaction = async (req, res) => {
    try {
        const data = await processor.closeTransaction(
            req.params.transaction_id,
            req.body,
            req.user?.id || null
        );
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.getDetail = async (req, res) => {
    try {
        const data = await processor.getDetail(req.params.transaction_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

// ── Apartado ──────────────────────────────────────────────────────────────────

exports.saveReservation = async (req, res) => {
    try {
        const data = await processor.saveReservation(req.params.transaction_id, req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

// ── Venta financiada ──────────────────────────────────────────────────────────

exports.saveSale = async (req, res) => {
    try {
        const data = await processor.saveSale(req.params.transaction_id, req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.listSalePayments = async (req, res) => {
    try {
        const data = await processor.listSalePayments(req.params.transaction_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.listSalePartialities = async (req, res) => {
    try {
        const data = await processor.listSalePartialities(req.params.payment_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.addSalePartialPayment = async (req, res) => {
    try {
        const data = await processor.addSalePartialPayment(req.params.payment_id, req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.generateSalePayments = async (req, res) => {
    try {
        const data = await processor.generateSalePayments(req.params.transaction_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.updateSalePayment = async (req, res) => {
    try {
        const data = await processor.updateSalePayment(req.params.payment_id, req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

// ── Renta ─────────────────────────────────────────────────────────────────────

exports.saveRental = async (req, res) => {
    try {
        const data = await processor.saveRental(req.params.transaction_id, req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

// ── Pagos de renta ────────────────────────────────────────────────────────────

exports.listPayments = async (req, res) => {
    try {
        const data = await processor.listPayments(req.params.transaction_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.generatePayments = async (req, res) => {
    try {
        const data = await processor.generatePayments(req.params.transaction_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.updatePayment = async (req, res) => {
    try {
        const data = await processor.updatePayment(req.params.payment_id, req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.listPartialities = async (req, res) => {
    try {
        const data = await processor.listPartialities(req.params.payment_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.addPartialPayment = async (req, res) => {
    try {
        const data = await processor.addPartialPayment(req.params.payment_id, req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

// ── Documentos ────────────────────────────────────────────────────────────────

exports.listDocuments = async (req, res) => {
    try {
        const data = await processor.listDocuments(req.params.transaction_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.uploadDocument = async (req, res) => {
    try {
        const data = await processor.uploadDocument(req.params.transaction_id, req, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.deleteDocument = async (req, res) => {
    try {
        const data = await processor.deleteDocument(req.params.document_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
