require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const { testConnection } = require('./config/database'); // Import hàm test DB

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Import Routes
app.use('/api/products', require('./routes/products'));

// Route mặc định (Health check)
app.get('/', (req, res) => {
    res.send('Server is running!');
});

// Error Handling
app.use((req, res) => res.status(404).json({ error: 'Route not found' }));
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal Server Error' });
});

// Lấy cổng từ file .env hoặc mặc định là 4000
const PORT = process.env.PORT || 4000;

// --- QUAN TRỌNG NHẤT: LỆNH KHỞI ĐỘNG SERVER ---
app.listen(PORT, async () => {
    console.log(`🚀 Server is starting...`);
    await testConnection(); // Kiểm tra kết nối MySQL
    console.log(`✨ Server running on http://localhost:${PORT}`);
});