const processor = require("./property.processor");

exports.listFeatured = async (req, res) => {
    try {
        const data = await processor.listFeatured(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.getDetail = async (req, res) => {
    try {
        const data = await processor.getDetail(req.params.id);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.visitIncrement = async (req, res) => {
    try {
        const data = await processor.visitIncrement(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.search = async (req, res) => {
    try {
        const data = await processor.search(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.upsert = async (req, res) => {
    try {
        const data = await processor.upsert(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};
