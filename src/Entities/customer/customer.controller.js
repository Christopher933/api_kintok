const processor = require("./customer.processor");

exports.upsert = async (req, res) => {
    try {
        const data = await processor.upsert(req.body);
        res.status(200).send(data);
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
