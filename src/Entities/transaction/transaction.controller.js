const processor = require("./transaction.processor");

exports.register = async (req, res) => {
    try {
        const data = await processor.register(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.listByProperty = async (req, res) => {
    try {
        const data = await processor.listByProperty(req.params.property_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.listByCustomer = async (req, res) => {
    try {
        const data = await processor.listByCustomer(req.params.customer_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};
