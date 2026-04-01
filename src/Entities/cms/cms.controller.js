const processor = require("./cms.processor");

exports.getHomeContent = async (req, res) => {
    try {
        const data = await processor.getHomeContent();
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.listTeam = async (req, res) => {
    try {
        const data = await processor.listTeam(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};
