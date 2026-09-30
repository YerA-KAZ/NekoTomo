const express = require('express');
const router = express.Router();
const { getProgress, getInventory } = require('../controllers/progressController');
const { authMiddleware } = require('../middleware/auth');

router.use(authMiddleware);

router.get('/', getProgress);
router.get('/inventory', getInventory);

module.exports = router;
