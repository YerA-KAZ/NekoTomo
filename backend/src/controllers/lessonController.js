const lessonService = require('../services/lessonService');

async function getLessons(req, res) {
  try {
    const lessons = await lessonService.getLessons(req.userId);
    res.json(lessons);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getLessonDetail(req, res) {
  try {
    const lessonId = parseInt(req.params.id);
    const lesson = await lessonService.getLessonDetail(lessonId, req.userId);
    res.json(lesson);
  } catch (error) {
    res.status(404).json({ error: error.message });
  }
}

module.exports = { getLessons, getLessonDetail };
