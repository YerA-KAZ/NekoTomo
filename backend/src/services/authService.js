const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const { JWT_SECRET } = require('../middleware/auth');

const prisma = new PrismaClient();
const SALT_ROUNDS = 10;

/**
 * Register a new user and create their pet
 */
async function register(username, email, password) {
  // Check if user exists
  const existing = await prisma.user.findFirst({
    where: { OR: [{ email }, { username }] },
  });

  if (existing) {
    throw new Error('User with this email or username already exists');
  }

  const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);

  // Create user with default pet
  const user = await prisma.user.create({
    data: {
      username,
      email,
      passwordHash,
      pet: {
        create: {
          name: 'Neko',
          level: 1,
          xp: 0,
          hunger: 80,
          happiness: 80,
          mood: 'idle',
        },
      },
      // Give starter food
      inventory: {
        create: {
          itemType: 'food',
          itemName: 'Onigiri',
          quantity: 3,
        },
      },
    },
    include: { pet: true },
  });

  const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '30d' });

  return {
    token,
    user: {
      id: user.id,
      username: user.username,
      email: user.email,
      pet: user.pet,
    },
  };
}

/**
 * Login user
 */
async function login(email, password) {
  const user = await prisma.user.findUnique({
    where: { email },
    include: { pet: true },
  });

  if (!user) {
    throw new Error('Invalid email or password');
  }

  const isValid = await bcrypt.compare(password, user.passwordHash);
  if (!isValid) {
    throw new Error('Invalid email or password');
  }

  const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '30d' });

  return {
    token,
    user: {
      id: user.id,
      username: user.username,
      email: user.email,
      pet: user.pet,
    },
  };
}

/**
 * Get current user info
 */
async function getMe(userId) {
  const user = await prisma.user.findUnique({
    where: { id: userId },
    include: { pet: true },
  });

  if (!user) {
    throw new Error('User not found');
  }

  return {
    id: user.id,
    username: user.username,
    email: user.email,
    pet: user.pet,
  };
}

module.exports = { register, login, getMe };
