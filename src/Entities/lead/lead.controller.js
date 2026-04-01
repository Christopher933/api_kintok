const processor = require("./lead.processor");

exports.register = async (req, res) => {
    try {
        const data = await processor.register(req.body);
        res.status(201).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.list = async (req, res) => {
    try {
        const data = await processor.list(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.statusUpdate = async (req, res) => {
    try {
        const data = await processor.statusUpdate(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};
