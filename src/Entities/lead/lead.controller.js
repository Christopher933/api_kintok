const processor = require("./lead.processor");

exports.register = async (req, res) => {
    try {
        const data = await processor.register(req.body);
        res.status(201).send(data);
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

exports.statusCatalog = async (_req, res) => {
    try {
        const data = await processor.statusCatalog();
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.statusUpdate = async (req, res) => {
    try {
        const data = await processor.statusUpdate(req.body, req.user?.id || null);
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

exports.notesList = async (req, res) => {
    try {
        const data = await processor.notesList(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.convertToCustomer = async (req, res) => {
    try {
        const data = await processor.convertToCustomer(req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
