const processor = require("./property.processor");

exports.listFeatured = async (req, res) => {
    try {
        const data = await processor.listFeatured(req.query);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.getDetail = async (req, res) => {
    try {
        const data = await processor.getDetail(req.params.id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.visitIncrement = async (req, res) => {
    try {
        const data = await processor.visitIncrement(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.search = async (req, res) => {
    try {
        const data = await processor.search(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.upsert = async (req, res) => {
    try {
        const data = await processor.upsert(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.uploadImages = async (req, res) => {
    try {
        const data = await processor.uploadImages(req);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.sortImages = async (req, res) => {
    try {
        const data = await processor.sortImages(req.body);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.deleteImage = async (req, res) => {
    try {
        const data = await processor.deleteImage(req.params.id);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};

exports.updateStatus = async (req, res) => {
    try {
        const data = await processor.updateStatus(req.body, req.user?.id || null);
        res.status(200).send(data);
    } catch (error) {
        res.status(error.status || 500).send({ message: error.message });
    }
};
