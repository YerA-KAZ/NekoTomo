const express = require('express');
const router = express.Router();
const { getExercises, answerExercise } = require('../controllers/exerciseController');
const { authMiddleware } = require('../middleware/auth');

router.use(authMiddleware);

router.get('/:lessonId', getExercises);
router.post('/:id/answer', answerExercise);

module.exports = router;
