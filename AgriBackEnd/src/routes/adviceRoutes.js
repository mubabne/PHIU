const router = require('express').Router();

router.get('/', (req, res) => {
  res.json({ message: 'advice route ok (todo)' });
});

module.exports = router;
