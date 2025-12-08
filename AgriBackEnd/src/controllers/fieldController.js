// src/controllers/fieldController.js

// In-memory storage (replace with database in production)
let fields = [];

exports.createField = async (req, res) => {
  try {
    const { size, location, crop, plantingDate } = req.body;
    
    // Validation
    if (!size || !location || !crop) {
      return res.status(400).json({ 
        error: 'Missing required fields: size, location, crop' 
      });
    }

    const field = {
      id: Date.now().toString(),
      size: parseFloat(size),
      location,
      crop: crop.toLowerCase(),
      plantingDate: plantingDate || null,
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString()
    };

    fields.push(field);

    res.status(201).json({
      success: true,
      message: 'Field created successfully',
      field
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getAllFields = async (req, res) => {
  try {
    res.json({
      success: true,
      count: fields.length,
      fields
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.getFieldById = async (req, res) => {
  try {
    const field = fields.find(f => f.id === req.params.id);
    
    if (!field) {
      return res.status(404).json({ error: 'Field not found' });
    }

    res.json({
      success: true,
      field
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.updateField = async (req, res) => {
  try {
    const index = fields.findIndex(f => f.id === req.params.id);
    
    if (index === -1) {
      return res.status(404).json({ error: 'Field not found' });
    }

    fields[index] = {
      ...fields[index],
      ...req.body,
      id: fields[index].id, // Keep original ID
      updatedAt: new Date().toISOString()
    };

    res.json({
      success: true,
      message: 'Field updated successfully',
      field: fields[index]
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.deleteField = async (req, res) => {
  try {
    const index = fields.findIndex(f => f.id === req.params.id);
    
    if (index === -1) {
      return res.status(404).json({ error: 'Field not found' });
    }

    fields.splice(index, 1);

    res.json({
      success: true,
      message: 'Field deleted successfully'
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};