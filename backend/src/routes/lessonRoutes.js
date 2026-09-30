const express = require('express');
const router = express.Router();
const { getLessons, getLessonDetail } = require('../controllers/lessonController');
const { completeLesson } = require('../controllers/exerciseController');
const { authMiddleware } = require('../middleware/auth');

router.use(authMiddleware);

router.get('/', getLessons);
router.get('/:id', getLessonDetail);
router.post('/:id/complete', completeLesson);

module.exports = router;
