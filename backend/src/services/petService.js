const { PrismaClient } = require('@prisma/client');
const { calculateLevelUp, xpForNextLevel, clamp } = require('../utils/xpCalculator');

const prisma = new PrismaClient();

const PLAY_COOLDOWN_MS = 30 * 1000; // 30 seconds

/**
 * Get pet for user
 */
async function getPet(userId) {
  const pet = await prisma.pet.findUnique({
    where: { userId },
  });

  if (!pet) {
    throw new Error('Pet not found');
  }

  return {
    ...pet,
    xpForNextLevel: xpForNextLevel(pet.level),
  };
}

/**
 * Feed pet from inventory
 */
async function feedPet(userId, itemName = 'Onigiri') {
  // Check inventory
  const inventoryItem = await prisma.inventory.findUnique({
    where: { userId_itemName: { userId, itemName } },
  });

  if (!inventoryItem || inventoryItem.quantity <= 0) {
    throw new Error('You don\'t have any food. Complete a lesson to earn food.');
  }

  // Get current pet
  const pet = await prisma.pet.findUnique({ where: { userId } });
  if (!pet) throw new Error('Pet not found');

  // Calculate new stats
  const hungerGain = 20;
  const happinessGain = 5;

  const newHunger = clamp(pet.hunger + hungerGain);
  const newHappiness = clamp(pet.happiness + happinessGain);

  // Update pet and inventory in transaction
  const [updatedPet] = await prisma.$transaction([
    prisma.pet.update({
      where: { userId },
      data: {
        hunger: newHunger,
        happiness: newHappiness,
        mood: 'eating',
        lastFed: new Date(),
      },
    }),
    prisma.inventory.update({
      where: { userId_itemName: { userId, itemName } },
      data: { quantity: inventoryItem.quantity - 1 },
    }),
  ]);

  return {
    pet: { ...updatedPet, xpForNextLevel: xpForNextLevel(updatedPet.level) },
    hungerGain,
    happinessGain,
    remainingFood: inventoryItem.quantity - 1,
  };
}

/**
 * Play with pet
 */
async function playWithPet(userId) {
  const pet = await prisma.pet.findUnique({ where: { userId } });
  if (!pet) throw new Error('Pet not found');

  // Cooldown check
  const now = new Date();
  const timeSinceLastPlay = now.getTime() - pet.lastPlayed.getTime();
  if (timeSinceLastPlay < PLAY_COOLDOWN_MS) {
    const remainingSeconds = Math.ceil((PLAY_COOLDOWN_MS - timeSinceLastPlay) / 1000);
    throw new Error(`Please wait ${remainingSeconds} seconds before playing again.`);
  }

  const happinessGain = 10;
  const newHappiness = clamp(pet.happiness + happinessGain);

  const updatedPet = await prisma.pet.update({
    where: { userId },
    data: {
      happiness: newHappiness,
      mood: 'playing',
      lastPlayed: now,
    },
  });

  return {
    pet: { ...updatedPet, xpForNextLevel: xpForNextLevel(updatedPet.level) },
    happinessGain,
  };
}

module.exports = { getPet, feedPet, playWithPet };
