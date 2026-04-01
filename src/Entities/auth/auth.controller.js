const processor = require("./auth.processor");

exports.login = async (req, res) => {
    try {
        const data = await processor.login(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
