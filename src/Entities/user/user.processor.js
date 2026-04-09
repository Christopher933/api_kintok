const bcrypt = require("bcrypt");
const { pool } = require("../../_shared/bd");

const mapDbError = (error) => {
  if (error && error.sqlState === "45000") {
    const message = error.sqlMessage || error.message || "Error de negocio";
    if (String(message).toLowerCase().includes("no encontrado")) {
      return { status: 404, message };
    }
    return { status: 400, message };
  }
  return error;
};

const normalizeMaybeNull = (value) => {
  const raw = String(value ?? "").trim();
  const low = raw.toLowerCase();
  if (!raw || low === "undefined" || low === "null") return null;
  return raw;
};

const isSuperAdminActor = (actorUser) => String(actorUser?.role_name || "").toLowerCase() === "super_admin";

exports.list = async (query, actorUser = null) => {
  const search = normalizeMaybeNull(query.search ?? query.search_text);
  const roleIdRaw = normalizeMaybeNull(query.role_id);
  const role_id = roleIdRaw ? Number(roleIdRaw) : null;
  const isActiveRaw = normalizeMaybeNull(query.is_active);
  const is_active = isActiveRaw == null ? null : Number(isActiveRaw) ? 1 : 0;
  const page_number = parseInt(query.page_number || query.page || 1, 10) || 1;
  const page_size = parseInt(query.page_size || query.limit || 10, 10) || 10;
  const canSeeSuperAdmin = isSuperAdminActor(actorUser);

  const [metaRows] = await pool.query(
    `SELECT COUNT(*) AS total_records
       FROM \`user\` u
       INNER JOIN role r ON r.id = u.role_id
      WHERE (? IS NULL OR u.username LIKE CONCAT('%', ?, '%') OR u.full_name LIKE CONCAT('%', ?, '%') OR u.email LIKE CONCAT('%', ?, '%'))
        AND (? IS NULL OR u.role_id = ?)
        AND (? IS NULL OR u.is_active = ?)
        AND (? = 1 OR r.name <> 'super_admin')`,
    [search, search, search, search, role_id, role_id, is_active, is_active, canSeeSuperAdmin ? 1 : 0]
  );

  const total_records = Number(metaRows[0]?.total_records || 0);
  const total_pages = Math.max(1, Math.ceil(total_records / page_size));
  const offset = (page_number - 1) * page_size;

  const [rows] = await pool.query(
    `SELECT u.id, u.username, u.full_name, u.email, u.role_id, r.name AS role_name,
            u.is_active, u.last_login_at, u.failed_login_attempts, u.locked_until,
            u.created_at, u.updated_at
       FROM \`user\` u
       INNER JOIN role r ON r.id = u.role_id
      WHERE (? IS NULL OR u.username LIKE CONCAT('%', ?, '%') OR u.full_name LIKE CONCAT('%', ?, '%') OR u.email LIKE CONCAT('%', ?, '%'))
        AND (? IS NULL OR u.role_id = ?)
        AND (? IS NULL OR u.is_active = ?)
        AND (? = 1 OR r.name <> 'super_admin')
      ORDER BY u.created_at DESC, u.id DESC
      LIMIT ? OFFSET ?`,
    [search, search, search, search, role_id, role_id, is_active, is_active, canSeeSuperAdmin ? 1 : 0, page_size, offset]
  );

  return {
    meta: { total_records, page_number, page_size, total_pages },
    data: rows,
  };
};

exports.detail = async (userId, actorUser = null) => {
  const id = Number(userId);
  if (!id) throw { status: 400, message: "user_id inválido" };
  const canSeeSuperAdmin = isSuperAdminActor(actorUser);

  const [rows] = await pool.query(
    `SELECT u.id, u.username, u.full_name, u.email, u.role_id, r.name AS role_name,
            u.is_active, u.last_login_at, u.failed_login_attempts, u.locked_until,
            u.created_at, u.updated_at
       FROM \`user\` u
       INNER JOIN role r ON r.id = u.role_id
      WHERE u.id = ?
        AND (? = 1 OR r.name <> 'super_admin')
      LIMIT 1`,
    [id, canSeeSuperAdmin ? 1 : 0]
  );

  if (!rows.length) throw { status: 404, message: "Usuario no encontrado" };
  return rows[0];
};

exports.upsert = async (body, actorUser = null) => {
  const id = body.id ? Number(body.id) : null;
  const username = String(body.username || "").trim();
  const full_name = String(body.full_name || "").trim();
  const email = String(body.email || "").trim().toLowerCase();
  const role_id = Number(body.role_id || 0);
  const is_active = body.is_active == null ? 1 : (Number(body.is_active) ? 1 : 0);
  const password = body.password != null ? String(body.password) : null;
  const actorUserId = Number(actorUser?.id || 0) || null;
  const actorIsSuperAdmin = isSuperAdminActor(actorUser);

  if (!username || !full_name || !email || !role_id) {
    throw { status: 400, message: "username, full_name, email y role_id son requeridos" };
  }

  if (!id && (!password || password.length < 8)) {
    throw { status: 400, message: "password es requerido y debe tener al menos 8 caracteres para crear usuario" };
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [existingByEmail] = await conn.query(
      "SELECT id FROM `user` WHERE email = ? AND (? IS NULL OR id <> ?) LIMIT 1",
      [email, id, id]
    );
    if (existingByEmail.length) throw { status: 400, message: "Ya existe un usuario con ese email" };

    const [existingByUsername] = await conn.query(
      "SELECT id FROM `user` WHERE username = ? AND (? IS NULL OR id <> ?) LIMIT 1",
      [username, id, id]
    );
    if (existingByUsername.length) throw { status: 400, message: "Ya existe un usuario con ese username" };

    const [targetRoleRows] = await conn.query("SELECT id, name FROM role WHERE id = ? LIMIT 1", [role_id]);
    if (!targetRoleRows.length) throw { status: 400, message: "role_id inválido" };
    const targetRoleName = String(targetRoleRows[0].name || "").toLowerCase();
    if (targetRoleName === "super_admin" && !actorIsSuperAdmin) {
      throw { status: 403, message: "Solo super_admin puede asignar el rol super_admin" };
    }

    if (id) {
      const [targetUserRows] = await conn.query(
        `SELECT r.name AS role_name
           FROM \`user\` u
           INNER JOIN role r ON r.id = u.role_id
          WHERE u.id = ?
          LIMIT 1`,
        [id]
      );
      if (!targetUserRows.length) throw { status: 404, message: "Usuario no encontrado" };
      const targetUserRoleName = String(targetUserRows[0].role_name || "").toLowerCase();
      if (targetUserRoleName === "super_admin" && !actorIsSuperAdmin) {
        throw { status: 403, message: "Solo super_admin puede modificar usuarios super_admin" };
      }
    }

    if (!id) {
      const password_hash = await bcrypt.hash(password, 10);
      const [insertRes] = await conn.query(
        `INSERT INTO \`user\` (username, password_hash, full_name, email, role_id, is_active, failed_login_attempts, locked_until, created_at, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, 0, NULL, NOW(), NOW())`,
        [username, password_hash, full_name, email, role_id, is_active]
      );
      await conn.commit();
      return { user_id: insertRes.insertId, action: "created" };
    }

    const [updateRes] = await conn.query(
      `UPDATE \`user\`
          SET username = ?,
              full_name = ?,
              email = ?,
              role_id = ?,
              is_active = ?,
              updated_at = NOW(),
              failed_login_attempts = CASE WHEN ? = 1 THEN 0 ELSE failed_login_attempts END,
              locked_until = CASE WHEN ? = 1 THEN NULL ELSE locked_until END
        WHERE id = ?`,
      [username, full_name, email, role_id, is_active, is_active, is_active, id]
    );

    if (!updateRes.affectedRows) throw { status: 404, message: "Usuario no encontrado" };

    if (password && password.length >= 8) {
      const password_hash = await bcrypt.hash(password, 10);
      await conn.query("UPDATE `user` SET password_hash = ?, updated_at = NOW() WHERE id = ?", [password_hash, id]);
    }

    await conn.commit();
    return { user_id: id, action: "updated" };
  } catch (error) {
    await conn.rollback();
    throw mapDbError(error);
  } finally {
    conn.release();
  }
};

exports.changePassword = async (body, actorUser) => {
  const rawUserId = String(body.user_id ?? "").trim().toLowerCase();
  const hasExplicitTarget =
    rawUserId !== "" &&
    rawUserId !== "undefined" &&
    rawUserId !== "null";
  const targetUserId = hasExplicitTarget ? Number(body.user_id) : Number(actorUser?.id || 0);
  const current_password = body.current_password != null ? String(body.current_password) : null;
  const new_password = body.new_password != null ? String(body.new_password) : "";

  if (!targetUserId) throw { status: 400, message: "user_id inválido" };
  if (!new_password || new_password.length < 8) {
    throw { status: 400, message: "new_password debe tener al menos 8 caracteres" };
  }

  const isSelfChange = Number(actorUser?.id || 0) === targetUserId;

  const [rows] = await pool.query("SELECT id, password_hash FROM `user` WHERE id = ? LIMIT 1", [targetUserId]);
  if (!rows.length) throw { status: 404, message: "Usuario no encontrado" };

  // En flujo admin, si viene user_id explícito, no exigir current_password.
  if (isSelfChange && !hasExplicitTarget) {
    if (!current_password) throw { status: 400, message: "current_password es requerido" };
    const ok = await bcrypt.compare(current_password, String(rows[0].password_hash || "").trim());
    if (!ok) throw { status: 400, message: "current_password incorrecto" };
  }

  const password_hash = await bcrypt.hash(new_password, 10);
  await pool.query(
    "UPDATE `user` SET password_hash = ?, failed_login_attempts = 0, locked_until = NULL, updated_at = NOW() WHERE id = ?",
    [password_hash, targetUserId]
  );
  return { affected_rows: 1, user_id: targetUserId };
};

exports.roles = async (actorUser = null) => {
  const canSeeSuperAdmin = isSuperAdminActor(actorUser);
  const [rows] = await pool.query(
    "SELECT id, name FROM role WHERE (? = 1 OR name <> 'super_admin') ORDER BY id",
    [canSeeSuperAdmin ? 1 : 0]
  );
  return { data: rows };
};

exports.roleUpsert = async (body, actorUser = null) => {
  const id = body.id ? Number(body.id) : null;
  const name = String(body.name || "").trim().toLowerCase();
  const permissions = Array.isArray(body.permissions) ? body.permissions : null;
  const actorUserId = Number(actorUser?.id || 0) || null;
  const actorIsSuperAdmin = isSuperAdminActor(actorUser);
  if (!name) throw { status: 400, message: "name es requerido" };

  if (name === "super_admin" && !actorIsSuperAdmin) {
    throw { status: 403, message: "Solo super_admin puede crear o editar el rol super_admin" };
  }

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [dup] = await conn.query(
      "SELECT id FROM role WHERE name = ? AND (? IS NULL OR id <> ?) LIMIT 1",
      [name, id, id]
    );
    if (dup.length) throw { status: 400, message: "Ya existe un rol con ese nombre" };

    let role_id = id;
    let action = "updated";

    if (!id) {
      const [ins] = await conn.query("INSERT INTO role (name) VALUES (?)", [name]);
      role_id = ins.insertId;
      action = "created";

      // Inicializar permisos del rol en 0 para todos los módulos.
      await conn.query(
        `INSERT INTO role_module_permission (role_id, module_id, can_view, can_create, can_update, can_delete, updated_by, updated_at)
         SELECT ?, pm.id, 0, 0, 0, 0, ?, NOW()
         FROM permission_module pm
         ON DUPLICATE KEY UPDATE updated_by = VALUES(updated_by), updated_at = NOW()`,
        [role_id, actorUserId || null]
      );
    } else {
      const [upd] = await conn.query("UPDATE role SET name = ? WHERE id = ?", [name, id]);
      if (!upd.affectedRows) throw { status: 404, message: "Rol no encontrado" };
    }

    if (permissions && permissions.length) {
      for (const p of permissions) {
        const module_id = Number(p.module_id || 0);
        if (!module_id) {
          throw { status: 400, message: "permissions[].module_id es requerido" };
        }

        const [moduleRows] = await conn.query(
          "SELECT id FROM permission_module WHERE id = ? LIMIT 1",
          [module_id]
        );
        if (!moduleRows.length) {
          throw { status: 400, message: `Módulo inválido: ${module_id}` };
        }

        await conn.query(
          `INSERT INTO role_module_permission (
              role_id, module_id, can_view, can_create, can_update, can_delete, updated_by, updated_at
           ) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
           ON DUPLICATE KEY UPDATE
              can_view = VALUES(can_view),
              can_create = VALUES(can_create),
              can_update = VALUES(can_update),
              can_delete = VALUES(can_delete),
              updated_by = VALUES(updated_by),
              updated_at = NOW()`,
          [
            role_id,
            module_id,
            Number(p.can_view) ? 1 : 0,
            Number(p.can_create) ? 1 : 0,
            Number(p.can_update) ? 1 : 0,
            Number(p.can_delete) ? 1 : 0,
            actorUserId || null,
          ]
        );
      }
    }

    await conn.commit();
    return { role_id, action };
  } catch (error) {
    await conn.rollback();
    throw mapDbError(error);
  } finally {
    conn.release();
  }
};

exports.roleDelete = async (roleId, actorUser = null) => {
  const id = Number(roleId);
  if (!id) throw { status: 400, message: "role_id inválido" };
  const actorIsSuperAdmin = isSuperAdminActor(actorUser);

  const [roleRows] = await pool.query("SELECT id, name FROM role WHERE id = ? LIMIT 1", [id]);
  if (!roleRows.length) throw { status: 404, message: "Rol no encontrado" };

  const roleName = String(roleRows[0].name || "").toLowerCase();
  if (roleName === "super_admin" && !actorIsSuperAdmin) {
    throw { status: 403, message: "Solo super_admin puede administrar este rol" };
  }
  if (["super_admin", "admin", "sales_agent"].includes(roleName)) {
    throw { status: 400, message: "No se puede eliminar un rol base del sistema" };
  }

  const [inUse] = await pool.query("SELECT COUNT(*) AS c FROM `user` WHERE role_id = ?", [id]);
  if (Number(inUse[0]?.c || 0) > 0) {
    throw { status: 400, message: "No se puede eliminar el rol porque está asignado a usuarios" };
  }

  const [result] = await pool.query("DELETE FROM role WHERE id = ?", [id]);
  return { affected_rows: result.affectedRows || 0, role_id: id };
};

exports.permissionModules = async () => {
  const [rows] = await pool.query("SELECT id, module_key, display_name FROM permission_module ORDER BY id");
  return { data: rows };
};

exports.rolePermissions = async (roleId, actorUser = null) => {
  const id = Number(roleId);
  if (!id) throw { status: 400, message: "role_id inválido" };
  const actorIsSuperAdmin = isSuperAdminActor(actorUser);

  const [roleRows] = await pool.query("SELECT id, name FROM role WHERE id = ? LIMIT 1", [id]);
  if (!roleRows.length) throw { status: 404, message: "Rol no encontrado" };
  if (String(roleRows[0].name || "").toLowerCase() === "super_admin" && !actorIsSuperAdmin) {
    throw { status: 403, message: "Solo super_admin puede ver este rol" };
  }

  const [rows] = await pool.query(
    `SELECT pm.id AS module_id, pm.module_key, pm.display_name,
            IFNULL(rmp.can_view,0) AS can_view,
            IFNULL(rmp.can_create,0) AS can_create,
            IFNULL(rmp.can_update,0) AS can_update,
            IFNULL(rmp.can_delete,0) AS can_delete
       FROM permission_module pm
       LEFT JOIN role_module_permission rmp
         ON rmp.module_id = pm.id
        AND rmp.role_id = ?
      ORDER BY pm.id`,
    [id]
  );

  return {
    role: roleRows[0],
    permissions: rows,
  };
};

exports.rolePermissionsUpsert = async (roleId, body, actorUser = null) => {
  const id = Number(roleId);
  if (!id) throw { status: 400, message: "role_id inválido" };
  const permissions = Array.isArray(body?.permissions) ? body.permissions : [];
  if (!permissions.length) throw { status: 400, message: "permissions es requerido" };
  const actorUserId = Number(actorUser?.id || 0) || null;
  const actorIsSuperAdmin = isSuperAdminActor(actorUser);

  const conn = await pool.getConnection();
  try {
    await conn.beginTransaction();

    const [roleRows] = await conn.query("SELECT id, name FROM role WHERE id = ? LIMIT 1", [id]);
    if (!roleRows.length) throw { status: 404, message: "Rol no encontrado" };
    if (String(roleRows[0].name || "").toLowerCase() === "super_admin" && !actorIsSuperAdmin) {
      throw { status: 403, message: "Solo super_admin puede modificar permisos de super_admin" };
    }

    for (const p of permissions) {
      const module_id = Number(p.module_id || 0);
      if (!module_id) continue;

      await conn.query(
        `INSERT INTO role_module_permission (
            role_id, module_id, can_view, can_create, can_update, can_delete, updated_by, updated_at
         ) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())
         ON DUPLICATE KEY UPDATE
            can_view = VALUES(can_view),
            can_create = VALUES(can_create),
            can_update = VALUES(can_update),
            can_delete = VALUES(can_delete),
            updated_by = VALUES(updated_by),
            updated_at = NOW()`,
        [
          id,
          module_id,
          Number(p.can_view) ? 1 : 0,
          Number(p.can_create) ? 1 : 0,
          Number(p.can_update) ? 1 : 0,
          Number(p.can_delete) ? 1 : 0,
          actorUserId || null,
        ]
      );
    }

    await conn.commit();
    return { role_id: id, affected_rows: permissions.length };
  } catch (error) {
    await conn.rollback();
    throw mapDbError(error);
  } finally {
    conn.release();
  }
};
