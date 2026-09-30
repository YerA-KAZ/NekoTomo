const exerciseService = require('../services/exerciseService');

async function getExercises(req, res) {
  try {
    const lessonId = parseInt(req.params.lessonId);
    const exercises = await exerciseService.getExercises(lessonId);
    res.json(exercises);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function answerExercise(req, res) {
  try {
    const exerciseId = parseInt(req.params.id);
    const { answer } = req.body;

    if (!answer) {
      return res.status(400).json({ error: 'Answer is required' });
    }

    const result = await exerciseService.answerExercise(exerciseId, req.userId, answer);
    res.json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

async function completeLesson(req, res) {
  try {
    const lessonId = parseInt(req.params.id);
    const result = await exerciseService.completeLesson(lessonId, req.userId);
    res.json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

module.exports = { getExercises, answerExercise, completeLesson };
