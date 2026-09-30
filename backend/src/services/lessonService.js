const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

/**
 * Get all lessons with user progress
 */
async function getLessons(userId) {
  const lessons = await prisma.lesson.findMany({
    orderBy: { orderIndex: 'asc' },
    include: {
      _count: {
        select: {
          exercises: true,
          vocabulary: true,
        },
      },
      progress: {
        where: { userId },
        take: 1,
      },
    },
  });

  return lessons.map(lesson => ({
    id: lesson.id,
    title: lesson.title,
    description: lesson.description,
    level: lesson.level,
    category: lesson.category,
    orderIndex: lesson.orderIndex,
    wordCount: lesson._count.vocabulary,
    exerciseCount: lesson._count.exercises,
    progress: lesson.progress[0] || null,
    completed: lesson.progress[0]?.completed || false,
  }));
}

/**
 * Get lesson detail with vocabulary
 */
async function getLessonDetail(lessonId, userId) {
  const lesson = await prisma.lesson.findUnique({
    where: { id: lessonId },
    include: {
      vocabulary: {
        include: { vocabulary: true },
        orderBy: { orderIndex: 'asc' },
      },
      _count: { select: { exercises: true } },
      progress: {
        where: { userId },
        take: 1,
      },
    },
  });

  if (!lesson) {
    throw new Error('Lesson not found');
  }

  return {
    id: lesson.id,
    title: lesson.title,
    description: lesson.description,
    level: lesson.level,
    category: lesson.category,
    exerciseCount: lesson._count.exercises,
    vocabulary: lesson.vocabulary.map(lv => lv.vocabulary),
    progress: lesson.progress[0] || null,
  };
}

module.exports = { getLessons, getLessonDetail };
