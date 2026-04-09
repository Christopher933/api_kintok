const processor = require("./user.processor");

exports.list = async (req, res) => {
  try {
    const data = await processor.list(req.query, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.detail = async (req, res) => {
  try {
    const data = await processor.detail(req.params.user_id, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.upsert = async (req, res) => {
  try {
    const data = await processor.upsert(req.body, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.changePassword = async (req, res) => {
  try {
    const data = await processor.changePassword(req.body, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.roles = async (req, res) => {
  try {
    const data = await processor.roles(req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.roleUpsert = async (req, res) => {
  try {
    const data = await processor.roleUpsert(req.body, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.roleDelete = async (req, res) => {
  try {
    const data = await processor.roleDelete(req.params.role_id, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.permissionModules = async (_req, res) => {
  try {
    const data = await processor.permissionModules();
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.rolePermissions = async (req, res) => {
  try {
    const data = await processor.rolePermissions(req.params.role_id, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};

exports.rolePermissionsUpsert = async (req, res) => {
  try {
    const data = await processor.rolePermissionsUpsert(req.params.role_id, req.body, req.user);
    res.status(200).send(data);
  } catch (error) {
    res.status(error.status || 500).send({ message: error.message });
  }
};
