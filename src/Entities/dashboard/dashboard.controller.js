const processor = require("./dashboard.processor");

exports.summary = async (req, res) => {
    try {
        const data = await processor.summary(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
