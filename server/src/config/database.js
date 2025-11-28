const mysql = require('mysql2/promise');
require('dotenv').config();

// Tạo hồ bơi kết nối (Connection Pool)
const pool = mysql.createPool({
  host: process.env.DB_HOST || '127.0.0.1',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || '',
  database: process.env.DB_NAME || 'review_db',
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Hàm kiểm tra kết nối
async function testConnection() {
  try {
    const [rows] = await pool.query('SELECT 1');
    console.log('✅ Database connected successfully');
  } catch (err) {
    console.error('❌ Database connection failed:', err.message);
  }
}

module.exports = { pool, testConnection };