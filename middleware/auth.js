// middleware/auth.js
const jwt = require('jsonwebtoken');
const User = require('../models/user');

module.exports = async (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Non authentifié' });
  try {
const payload = jwt.verify(token, process.env.JWT_SECRET2);

    const user = await User.findById(payload.id);
    if (!user) throw new Error();
    req.user = user;
    next();
  } catch {
    res.status(401).json({ error: 'Token invalide' });
  }
};
