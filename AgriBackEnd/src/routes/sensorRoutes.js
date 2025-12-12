const router = require('express').Router();

router.get('/', (req, res) => {
  res.json({ message: 'sensor route ok (todo)' });
});

module.exports = router;
