const processor = require("./customer.processor");

exports.upsert = async (req, res) => {
    try {
        const data = await processor.upsert(req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.list = async (req, res) => {
    try {
        const data = await processor.list(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.detail = async (req, res) => {
    try {
        const data = await processor.detail(req.params.customer_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.notesList = async (req, res) => {
    try {
        const data = await processor.notesList(req.query.customer_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.notesAdd = async (req, res) => {
    try {
        const data = await processor.notesAdd(req.body, req.user?.id || null);
        res.status(201).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.deleteCustomer = async (req, res) => {
    try {
        const data = await processor.deleteCustomer(req.params.customer_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
