require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const { testConnection } = require('./config/database');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Import Routes
app.use('/api/products', require('./routes/products'));

// Default Route (Health check)
app.get('/', (req, res) => {
    res.send('Server is running!');
});

// Error Handling
app.use((req, res) => res.status(404).json({ error: 'Route not found' }));
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ error: 'Internal Server Error' });
});

// Get port from .env or default to 4000
const PORT = process.env.PORT || 4000;

// Start Server
app.listen(PORT, async () => {
    console.log(`🚀 Server is starting...`);
    await testConnection(); // Check Database Connection
    console.log(`✨ Server running on http://localhost:${PORT}`);
});