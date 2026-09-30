require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Health check
app.get('/api/health', (req, res) => {
  res.json({ 
    status: 'ok', 
    message: 'NekoTomo API is running 🐱',
    timestamp: new Date().toISOString()
  });
});

// Routes will be added in Phase 2+
// app.use('/api/auth', authRoutes);
// app.use('/api/pet', petRoutes);
// app.use('/api/lessons', lessonRoutes);
// app.use('/api/exercises', exerciseRoutes);
// app.use('/api/progress', progressRoutes);
// app.use('/api/inventory', inventoryRoutes);

app.listen(PORT, () => {
  console.log(`🐱 NekoTomo API running on port ${PORT}`);
});

module.exports = app;
