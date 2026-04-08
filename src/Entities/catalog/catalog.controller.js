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

exports.cityList = async (req, res) => {
    try {
        const data = await processor.cityList();
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.zoneList = async (req, res) => {
    try {
        const data = await processor.zoneList(req.query.city_id);
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.amenityList = async (req, res) => {
    try {
        const data = await processor.amenityList();
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.propertyTypeList = async (req, res) => {
    try {
        const data = await processor.propertyTypeList();
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.operationList = async (req, res) => {
    try {
        const data = await processor.operationList();
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.publicationStatusList = async (req, res) => {
    try {
        const data = await processor.publicationStatusList();
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};

exports.businessStatusList = async (req, res) => {
    try {
        const data = await processor.businessStatusList();
        res.status(200).send(data);
    } catch (error) {
        res.status(500).send({ message: error.message });
    }
};
