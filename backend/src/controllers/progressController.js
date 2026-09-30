const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function getProgress(req, res) {
  try {
    const userId = req.userId;

    const pet = await prisma.pet.findUnique({ where: { userId } });
    const progress = await prisma.userProgress.findMany({
      where: { userId },
      include: { lesson: true },
    });
    const learnedWords = await prisma.userVocabulary.count({
      where: { userId, learned: true },
    });
    const completedLessons = progress.filter(p => p.completed).length;

    // Calculate streak (simplified: count consecutive days with activity)
    const streak = await calculateStreak(userId);

    res.json({
      username: (await prisma.user.findUnique({ where: { id: userId } }))?.username,
      japaneseLevel: 'N5',
      wordsLearned: learnedWords,
      lessonsCompleted: completedLessons,
      totalXp: pet ? pet.xp + (pet.level - 1) * 100 : 0,
      streak,
      petLevel: pet?.level || 1,
      petName: pet?.name || 'Neko',
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function getInventory(req, res) {
  try {
    const inventory = await prisma.inventory.findMany({
      where: { userId: req.userId },
    });
    res.json(inventory);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
}

async function calculateStreak(userId) {
  // Simplified streak based on progress completion dates
  const recentProgress = await prisma.userProgress.findMany({
    where: { userId, completed: true },
    orderBy: { completedAt: 'desc' },
    take: 30,
  });

  if (recentProgress.length === 0) return 0;

  let streak = 0;
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  for (let i = 0; i < 30; i++) {
    const checkDate = new Date(today);
    checkDate.setDate(checkDate.getDate() - i);

    const hasActivity = recentProgress.some(p => {
      if (!p.completedAt) return false;
      const pDate = new Date(p.completedAt);
      pDate.setHours(0, 0, 0, 0);
      return pDate.getTime() === checkDate.getTime();
    });

    if (hasActivity || i === 0) {
      if (hasActivity) streak++;
    } else {
      break;
    }
  }

  return streak;
}

module.exports = { getProgress, getInventory };
