// src/controllers/authController.js

// Simple placeholder authentication (implement proper auth in production)
let users = [];

exports.register = async (req, res) => {
  try {
    const { username, email, password } = req.body;

    if (!username || !email || !password) {
      return res.status(400).json({ 
        error: 'Missing required fields: username, email, password' 
      });
    }

    // Check if user exists
    const existing = users.find(u => u.email === email);
    if (existing) {
      return res.status(400).json({ error: 'User already exists' });
    }

    const user = {
      id: Date.now().toString(),
      username,
      email,
      createdAt: new Date().toISOString()
    };

    users.push(user);

    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      user: { id: user.id, username: user.username, email: user.email }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;

    if (!email || !password) {
      return res.status(400).json({ 
        error: 'Missing required fields: email, password' 
      });
    }

    // Simple check (implement proper auth in production)
    const user = users.find(u => u.email === email);
    
    if (!user) {
      return res.status(401).json({ error: 'Invalid credentials' });
    }

    res.json({
      success: true,
      message: 'Login successful',
      user: { id: user.id, username: user.username, email: user.email }
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};