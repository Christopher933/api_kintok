const mysql = require('mysql2/promise');

const createPool = mysql.createPool({
    host: process.env.HOST,
    user: process.env.USER_DB,
    database: process.env.DB,
    password: process.env.PASS_DB,
    waitForConnections: true,
    connectionLimit: 10,
    maxIdle: 10, // max idle connections, the default value is the same as `connectionLimit`
    idleTimeout: 60000, // idle connections timeout, in milliseconds, the default value 60000
    queueLimit: 0,
    enableKeepAlive: true,
    keepAliveInitialDelay: 0,
});

exports.pool = createPool;