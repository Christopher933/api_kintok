const processor = require("./testimonial.processor");

exports.list = async (req, res) => {
    try {
        const data = await processor.list(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.create = async (req, res) => {
    try {
        const data = await processor.upsert({ ...req.body, id: null });
        res.status(201).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.update = async (req, res) => {
    try {
        const data = await processor.upsert({ ...req.body, id: req.params.id });
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.remove = async (req, res) => {
    try {
        const data = await processor.remove(req.params.id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
