/**
 * XP calculation utilities for pet leveling
 */

// XP required for each level
const LEVEL_XP = {
  1: 0,
  2: 100,
  3: 150,
  4: 200,
  5: 300,
  6: 400,
  7: 500,
  8: 650,
  9: 800,
  10: 1000,
};

const MAX_LEVEL = 10;

/**
 * Calculate total XP needed to reach a specific level
 */
function totalXpForLevel(level) {
  let total = 0;
  for (let i = 2; i <= level; i++) {
    total += LEVEL_XP[i] || 1000;
  }
  return total;
}

/**
 * Calculate new level and remaining XP after adding XP
 */
function calculateLevelUp(currentLevel, currentXp, addedXp) {
  let level = currentLevel;
  let xp = currentXp + addedXp;
  let leveledUp = false;

  while (level < MAX_LEVEL) {
    const xpNeeded = LEVEL_XP[level + 1] || 1000;
    if (xp >= xpNeeded) {
      xp -= xpNeeded;
      level++;
      leveledUp = true;
    } else {
      break;
    }
  }

  // Cap XP at max level
  if (level >= MAX_LEVEL) {
    level = MAX_LEVEL;
  }

  return { level, xp, leveledUp };
}

/**
 * Get XP needed for next level
 */
function xpForNextLevel(currentLevel) {
  if (currentLevel >= MAX_LEVEL) return 0;
  return LEVEL_XP[currentLevel + 1] || 1000;
}

/**
 * Clamp a value between min and max
 */
function clamp(value, min = 0, max = 100) {
  return Math.max(min, Math.min(max, value));
}

module.exports = {
  LEVEL_XP,
  MAX_LEVEL,
  totalXpForLevel,
  calculateLevelUp,
  xpForNextLevel,
  clamp,
};
