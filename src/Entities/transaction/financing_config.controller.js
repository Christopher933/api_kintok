const processor = require("./financing_config.processor");

exports.getConfig = async (req, res) => {
    try {
        const data = await processor.getConfig();
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.updateConfig = async (req, res) => {
    try {
        const data = await processor.updateConfig(req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.simulatePlan = async (req, res) => {
    try {
        const data = await processor.simulatePlan(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
