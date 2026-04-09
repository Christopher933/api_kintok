const JWT = require('jsonwebtoken');
const { pool } = require('./bd');

const DEFAULT_ROLE_MODULE_PERMISSIONS = {
  super_admin: {
    auth: { view: 1, create: 1, update: 1, delete: 1 },
    user: { view: 1, create: 1, update: 1, delete: 1 },
    role_permission: { view: 1, create: 1, update: 1, delete: 1 },
    property: { view: 1, create: 1, update: 1, delete: 1 },
    lead: { view: 1, create: 1, update: 1, delete: 1 },
    customer: { view: 1, create: 1, update: 1, delete: 1 },
    transaction: { view: 1, create: 1, update: 1, delete: 1 },
    catalog: { view: 1, create: 1, update: 1, delete: 1 },
    cms: { view: 1, create: 1, update: 1, delete: 1 },
  },
  admin: {
    auth: { view: 1, create: 1, update: 1, delete: 0 },
    user: { view: 1, create: 1, update: 1, delete: 0 },
    role_permission: { view: 1, create: 0, update: 1, delete: 0 },
    property: { view: 1, create: 1, update: 1, delete: 1 },
    lead: { view: 1, create: 1, update: 1, delete: 1 },
    customer: { view: 1, create: 1, update: 1, delete: 1 },
    transaction: { view: 1, create: 1, update: 1, delete: 1 },
    catalog: { view: 1, create: 1, update: 1, delete: 0 },
    cms: { view: 1, create: 1, update: 1, delete: 0 },
  },
  sales_agent: {
    auth: { view: 1, create: 0, update: 1, delete: 0 },
    user: { view: 0, create: 0, update: 0, delete: 0 },
    role_permission: { view: 0, create: 0, update: 0, delete: 0 },
    property: { view: 1, create: 1, update: 1, delete: 0 },
    lead: { view: 1, create: 1, update: 1, delete: 0 },
    customer: { view: 1, create: 1, update: 1, delete: 0 },
    transaction: { view: 1, create: 1, update: 1, delete: 0 },
    catalog: { view: 1, create: 0, update: 0, delete: 0 },
    cms: { view: 1, create: 0, update: 0, delete: 0 },
  },
};

const getDefaultPermissionsByRole = (roleName) => {
  const key = String(roleName || "").toLowerCase();
  return DEFAULT_ROLE_MODULE_PERMISSIONS[key] || {};
};

const normalizePermissionsRows = (rows = []) => {
  const permissions = {};
  for (const row of rows) {
    const moduleKey = String(row.module_key || "").trim();
    if (!moduleKey) continue;
    permissions[moduleKey] = {
      view: Number(row.can_view || 0),
      create: Number(row.can_create || 0),
      update: Number(row.can_update || 0),
      delete: Number(row.can_delete || 0),
    };
  }
  return permissions;
};

exports.generateToken = (data, expire_in = null) => {
  let token;
  try {
    if (data) {
      token = JWT.sign(data, process.env.TOKEN_KEY, {
        expiresIn: expire_in ? expire_in : '30d',
      });
    } else {
      token = "Didn't received Token";
    }
  } catch (err) {
    token = err;
  }
  return token;
};

exports.validateToken = (token) => {
  if (!token) return null;
  try {
    return JWT.verify(token, process.env.TOKEN_KEY);
  } catch (err) {
    return null;
  }
};

exports.verifyAccess = async (req, res, next) => {
  const auth = req.headers.authorization || "";
  const token = auth.startsWith("Bearer ") ? auth.slice(7) : auth;
  let decoded;

  if (!token) {
    return res.status(401).json({
      status: false,
      message: "jwt must be provided",
    });
  }

  try {
    decoded = JWT.verify(token, process.env.TOKEN_KEY);
  } catch (err) {
    return res.status(401).json({
      status: false,
      message: err.message || "Unauthorized access",
    });
  }

  if (!decoded?.id) {
    return res.status(401).json({
      status: false,
      message: "Unauthorized access",
    });
  }

  try {
    // Validar que el usuario exista y esté activo.
    // 401 solo para auth/token; usuario inactivo = 403 para no forzar logout automático.
    const [rows] = await pool.query(
      `SELECT u.id, u.username, u.email, u.role_id, u.is_active, r.name AS role_name
         FROM \`user\` u
         LEFT JOIN role r ON r.id = u.role_id
        WHERE u.id = ?
        LIMIT 1`,
      [decoded.id]
    );
    const user = rows[0];

    if (!user) {
      return res.status(401).json({
        status: false,
        message: "Unauthorized access",
      });
    }

    if (!user.is_active) {
      return res.status(403).json({
        status: false,
        message: "Account is inactive",
      });
    }

    let modulePermissions = getDefaultPermissionsByRole(user.role_name);
    try {
      const [permsRows] = await pool.query(
        `SELECT pm.module_key, rmp.can_view, rmp.can_create, rmp.can_update, rmp.can_delete
           FROM role_module_permission rmp
           INNER JOIN permission_module pm ON pm.id = rmp.module_id
          WHERE rmp.role_id = ?`,
        [user.role_id]
      );
      if (Array.isArray(permsRows) && permsRows.length) {
        modulePermissions = normalizePermissionsRows(permsRows);
      }
    } catch (_e) {
      // Si las tablas de permisos no existen aún, usar fallback por rol.
    }

    req.user = {
      id: user.id,
      username: user.username,
      email: user.email,
      role_id: user.role_id,
      role_name: user.role_name || null,
      permissions: modulePermissions,
    };
    return next();
  } catch (err) {
    return res.status(500).json({
      status: false,
      message: "Internal server error",
    });
  }
};

exports.authorizeRoles = (allowedRoles = []) => {
  const normalized = new Set((allowedRoles || []).map((r) => String(r).toLowerCase()));
  return (req, res, next) => {
    const roleName = String(req.user?.role_name || "").toLowerCase();
    if (!normalized.size || normalized.has(roleName)) return next();

    return res.status(403).json({
      status: false,
      message: "Forbidden",
    });
  };
};

exports.authorizeModuleAction = (moduleKey, action = "view") => {
  const normalizedModule = String(moduleKey || "").trim();
  const normalizedAction = String(action || "view").toLowerCase();
  return (req, res, next) => {
    const roleName = String(req.user?.role_name || "").toLowerCase();
    if (roleName === "super_admin") return next();

    const permissions = req.user?.permissions || {};
    const modulePerms = permissions[normalizedModule];
    if (!modulePerms) {
      return res.status(403).json({ status: false, message: "Forbidden" });
    }

    const hasPermission = Number(modulePerms[normalizedAction] || 0) === 1;
    if (!hasPermission) {
      return res.status(403).json({ status: false, message: "Forbidden" });
    }
    return next();
  };
};


exports.generateTokenEmail = (data) => {
  let token;
  try {
    if (data) {
      token = JWT.sign(data, process.env.TOKEN_EMAIL, {
        expiresIn: '60m',
      });
    } else {
      token = null;
    }
  } catch (err) {
    token = err;
  }
  return token;
};

exports.validateTokenEmail = (token) => {
  let token_verificated;
  JWT.verify(token, process.env.TOKEN_EMAIL, (err, verifiedJwt) => {
    if (err) {
      token_verificated = { message: err.message, status: false };
    } else {
      token_verificated = { message: "Token valido", status: true, info_token: verifiedJwt };
    }
  });
  return token_verificated;
};
