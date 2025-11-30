// src/config/database.js
const mysql = require('mysql2/promise');
require('dotenv').config();

// Build config (convert port to number)
const dbConfig = {
  host: process.env.DB_HOST || '127.0.0.1',
  port: process.env.DB_PORT ? Number(process.env.DB_PORT) : 3306,
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'review_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
};

// create pool
const pool = mysql.createPool(dbConfig);

// helpful debug (masked password)
console.log('DB CONFIG', {
  host: dbConfig.host,
  port: dbConfig.port,
  user: dbConfig.user,
  password: dbConfig.password ? '***' : '(empty)',
  database: dbConfig.database
});

// Function to test database connection + inspect DB + tables
async function testConnection(verbose = true) {
  try {
    const [dbRow] = await pool.query('SELECT DATABASE() AS db');
    if (verbose) console.log('✅ Database connected to:', dbRow[0].db);

    // optional: list tables (first 50)
    try {
      const [tables] = await pool.query("SHOW TABLES");
      if (verbose) console.log('Tables:', tables.slice(0, 50));
    } catch (tblErr) {
      if (verbose) console.warn('⚠️ Could not list tables:', tblErr.message);
    }

    return true;
  } catch (err) {
    console.error('❌ Database connection failed:', err.code || err.message);
    console.error(err);
    return false;
  }
}

module.exports = { pool, testConnection };
