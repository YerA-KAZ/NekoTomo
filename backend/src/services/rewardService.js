const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

/**
 * Calculate reward for exercise/lesson completion
 */
const REWARDS = {
  CORRECT_ANSWER: { xp: 10, coins: 5, food: 0 },
  LESSON_COMPLETE: { xp: 50, coins: 20, food: 1 },
  PERFECT_LESSON: { xp: 80, coins: 40, food: 2 },
  FEED_PET: { happiness: 5, hunger: 20 },
  PLAY_PET: { happiness: 10 },
};

module.exports = { REWARDS };
