const processor = require("./catalog.processor");

exports.cityUpsert = async (req, res) => {
    try {
        const data = await processor.cityUpsert(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.zoneUpsert = async (req, res) => {
    try {
        const data = await processor.zoneUpsert(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.amenityUpsert = async (req, res) => {
    try {
        const data = await processor.amenityUpsert(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.propertyTypeUpsert = async (req, res) => {
    try {
        const data = await processor.propertyTypeUpsert(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};
