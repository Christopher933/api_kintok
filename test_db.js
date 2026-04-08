const mysql = require('mysql2/promise');
const dotenv = require('dotenv');
dotenv.config();

async function test() {
    const pool = mysql.createPool({
        host: process.env.DB_HOST || 'localhost',
        user: process.env.DB_USER || 'root',
        password: process.env.DB_PASSWORD || '',
        database: process.env.DB_NAME || 'kintok',
    });

    try {
        // Simulamos una llamada a un SP que devuelve un SELECT
        const [rows] = await pool.query("CALL city_list()"); // city_list simplemente hace SELECT * FROM city
        console.log("ROWS structure:", JSON.stringify(rows, null, 2));
        if (rows[0] && rows[0][0]) {
            console.log("ROWS[0][0]:", rows[0][0]);
        }
    } catch (err) {
        console.error(err);
    } finally {
        await pool.end();
    }
}

test();
