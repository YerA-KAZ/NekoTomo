const express = require('express');
const router = express.Router();
const { getPet, feedPet, playWithPet } = require('../controllers/petController');
const { authMiddleware } = require('../middleware/auth');

router.use(authMiddleware);

router.get('/', getPet);
router.post('/feed', feedPet);
router.post('/play', playWithPet);

module.exports = router;
