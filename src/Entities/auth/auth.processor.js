const db = require("../../_shared/bd");
const pool = db.pool;
const bcrypt = require("bcrypt");
const tokenHelper = require("../../_shared/token");

exports.login = async (body) => {
    const { email, password } = body;

    if (!email || !password) {
        throw { status: 400, message: "Email and password are required" };
    }

    // 1. Get user data
    const [rows] = await pool.query("CALL user_login_get(?)", [email]);
    const user = rows[0][0];

    if (!user) {
        throw { status: 403, message: "Invalid credentials" };
    }

    // 2. Check if locked
    if (user.locked_until && new Date(user.locked_until) > new Date()) {
        throw { status: 403, message: "Account is temporarily locked. Try again later." };
    }

    if (!user.is_active) {
        throw { status: 403, message: "Account is inactive" };
    }

    // 3. Verify password
    const cleanPassword = password.toString().trim();
    const match = await bcrypt.compare(cleanPassword, user.password_hash.trim());
    if (match) {
        // 4. Update success
        await pool.query("CALL user_login_success(?)", [user.id]);

        let module_permissions = {};
        try {
            const [permRows] = await pool.query(
                `SELECT pm.module_key, rmp.can_view, rmp.can_create, rmp.can_update, rmp.can_delete
                   FROM role_module_permission rmp
                   INNER JOIN permission_module pm ON pm.id = rmp.module_id
                  WHERE rmp.role_id = ?`,
                [user.role_id]
            );
            if (Array.isArray(permRows)) {
                for (const row of permRows) {
                    const key = String(row.module_key || "").trim();
                    if (!key) continue;
                    module_permissions[key] = {
                        view: Number(row.can_view || 0),
                        create: Number(row.can_create || 0),
                        update: Number(row.can_update || 0),
                        delete: Number(row.can_delete || 0),
                    };
                }
            }
        } catch (_e) {
            module_permissions = {};
        }

        // 5. Generate token
        const token = tokenHelper.generateToken({
            id: user.id,
            username: user.username,
            email: user.email,
            role_id: user.role_id,
            role_name: user.role_name,
            permissions: module_permissions,
        });

        // Remove hash from response
        delete user.password_hash;

        return {
            message: "Login successful",
            user,
            permissions: module_permissions,
            token,
        };
    } else {
        // 6. Update failure
        await pool.query("CALL user_login_failed(?)", [user.id]);
        throw { status: 403, message: "Invalid credentials" };
    }
};
