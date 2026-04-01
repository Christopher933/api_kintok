const db = require("../../_shared/bd");
const pool = db.pool;
const bcrypt = require("bcrypt");
const tokenHelper = require("../../_shared/token");

exports.login = async (body) => {
    const { username, password } = body;

    if (!username || !password) {
        throw { status: 400, message: "Username and password are required" };
    }

    // 1. Get user data
    const [rows] = await pool.query("CALL user_login_get(?)", [username]);
    const user = rows[0][0];

    if (!user) {
        throw { status: 401, message: "Invalid credentials" };
    }

    // 2. Check if locked
    if (user.locked_until && new Date(user.locked_until) > new Date()) {
        throw { status: 403, message: "Account is temporarily locked. Try again later." };
    }

    if (!user.is_active) {
        throw { status: 403, message: "Account is inactive" };
    }

    // 3. Verify password
    const match = await bcrypt.compare(password, user.password_hash);

    if (match) {
        // 4. Update success
        await pool.query("CALL user_login_success(?)", [user.id]);

        // 5. Generate token
        const token = tokenHelper.generateToken({
            id: user.id,
            username: user.username,
            role_id: user.role_id,
            role_name: user.role_name,
        });

        // Remove hash from response
        delete user.password_hash;

        return {
            message: "Login successful",
            user,
            token,
        };
    } else {
        // 6. Update failure
        await pool.query("CALL user_login_failed(?)", [user.id]);
        throw { status: 401, message: "Invalid credentials" };
    }
};
