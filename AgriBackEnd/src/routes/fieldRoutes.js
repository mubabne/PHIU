// src/routes/fieldRoutes.js
const express = require('express');
const router = express.Router();
const fieldController = require('../controllers/fieldController');

// Field management routes
router.post('/create', fieldController.createField);
router.get('/all', fieldController.getAllFields);
router.get('/:id', fieldController.getFieldById);
router.put('/:id', fieldController.updateField);
router.delete('/:id', fieldController.deleteField);

module.exports = router;