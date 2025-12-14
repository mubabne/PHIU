// src/routes/authRoutes.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

// Authentication routes (placeholder for future implementation)
router.post('/register', authController.register);
router.post('/login', authController.login);

module.exports = router;

// aan back endpoint ni boltsiin bshd te
//harin tiim bha deer erka suuj bicij ugsiin
// tiim bna2