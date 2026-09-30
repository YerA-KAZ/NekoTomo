const { PrismaClient } = require('@prisma/client');
const { calculateLevelUp, xpForNextLevel, clamp } = require('../utils/xpCalculator');

const prisma = new PrismaClient();

/**
 * Get exercises for a lesson
 */
async function getExercises(lessonId) {
  const exercises = await prisma.exercise.findMany({
    where: { lessonId },
  });

  // Don't send correct answer to client
  return exercises.map(ex => ({
    id: ex.id,
    lessonId: ex.lessonId,
    type: ex.type,
    question: ex.question,
    options: ex.options,
  }));
}

/**
 * Answer an exercise - returns reward if correct
 */
async function answerExercise(exerciseId, userId, answer) {
  const exercise = await prisma.exercise.findUnique({
    where: { id: exerciseId },
  });

  if (!exercise) {
    throw new Error('Exercise not found');
  }

  const isCorrect = answer === exercise.correctAnswer;

  if (isCorrect) {
    // Award XP to pet
    const pet = await prisma.pet.findUnique({ where: { userId } });
    if (pet) {
      const { level, xp, leveledUp } = calculateLevelUp(
        pet.level,
        pet.xp,
        exercise.xpReward
      );

      const happinessBonus = leveledUp ? 20 : 0;

      await prisma.pet.update({
        where: { userId },
        data: {
          level,
          xp,
          happiness: clamp(pet.happiness + happinessBonus),
          mood: leveledUp ? 'excited' : pet.mood,
        },
      });

      // Update progress
      await prisma.userProgress.upsert({
        where: { userId_lessonId: { userId, lessonId: exercise.lessonId } },
        create: {
          userId,
          lessonId: exercise.lessonId,
          exercisesCompleted: 1,
          exercisesTotal: await prisma.exercise.count({
            where: { lessonId: exercise.lessonId },
          }),
          score: 1,
        },
        update: {
          exercisesCompleted: { increment: 1 },
          score: { increment: 1 },
        },
      });

      return {
        correct: true,
        xpEarned: exercise.xpReward,
        coinsEarned: exercise.coinReward,
        leveledUp,
        newLevel: level,
        newXp: xp,
      };
    }
  }

  return {
    correct: false,
    correctAnswer: exercise.correctAnswer,
    xpEarned: 0,
    coinsEarned: 0,
    leveledUp: false,
  };
}

/**
 * Complete a lesson - bonus rewards
 */
async function completeLesson(lessonId, userId) {
  const lesson = await prisma.lesson.findUnique({
    where: { id: lessonId },
    include: { _count: { select: { exercises: true } } },
  });

  if (!lesson) throw new Error('Lesson not found');

  // Get or create progress
  const progress = await prisma.userProgress.upsert({
    where: { userId_lessonId: { userId, lessonId } },
    create: {
      userId,
      lessonId,
      exercisesCompleted: lesson._count.exercises,
      exercisesTotal: lesson._count.exercises,
      completed: true,
      completedAt: new Date(),
    },
    update: {
      completed: true,
      completedAt: new Date(),
      exercisesTotal: lesson._count.exercises,
    },
  });

  // Bonus XP and rewards for lesson completion
  const bonusXp = 50;
  const bonusCoins = 20;
  const isPerfect = progress.score >= lesson._count.exercises;

  const totalBonusXp = isPerfect ? 80 : bonusXp;
  const totalBonusCoins = isPerfect ? 40 : bonusCoins;
  const foodReward = isPerfect ? 2 : 1;

  // Apply to pet
  const pet = await prisma.pet.findUnique({ where: { userId } });
  if (pet) {
    const { level, xp, leveledUp } = calculateLevelUp(pet.level, pet.xp, totalBonusXp);

    await prisma.pet.update({
      where: { userId },
      data: {
        level,
        xp,
        happiness: clamp(pet.happiness + 5),
        mood: leveledUp ? 'excited' : 'happy',
      },
    });

    // Add food to inventory
    await prisma.inventory.upsert({
      where: { userId_itemName: { userId, itemName: 'Onigiri' } },
      create: {
        userId,
        itemType: 'food',
        itemName: 'Onigiri',
        quantity: foodReward,
      },
      update: {
        quantity: { increment: foodReward },
      },
    });

    return {
      completed: true,
      isPerfect,
      xpEarned: totalBonusXp,
      coinsEarned: totalBonusCoins,
      foodEarned: foodReward,
      leveledUp,
      newLevel: level,
      score: progress.score,
      total: lesson._count.exercises,
    };
  }

  throw new Error('Pet not found');
}

module.exports = { getExercises, answerExercise, completeLesson };
