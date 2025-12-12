// App.js
require('dotenv').config();
const express = require('express');

const authRoutes = require('./src/routes/authRoutes');
const adviceRoutes = require('./src/routes/adviceRoutes');
const fieldRoutes = require('./src/routes/fieldRoutes');
const sensorRoutes = require('./src/routes/sensorRoutes');

const app = express();

// middlewares
app.use(express.json());

// routes
app.use('/auth', authRoutes);
app.use('/advice', adviceRoutes);
app.use('/fields', fieldRoutes);
app.use('/sensors', sensorRoutes);

// health check
app.get('/', (req, res) => res.send('API is running ✅'));

const port = process.env.PORT || 5000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
