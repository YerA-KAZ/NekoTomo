const petService = require('../services/petService');

async function getPet(req, res) {
  try {
    const pet = await petService.getPet(req.userId);
    res.json(pet);
  } catch (error) {
    res.status(404).json({ error: error.message });
  }
}

async function feedPet(req, res) {
  try {
    const { itemName } = req.body;
    const result = await petService.feedPet(req.userId, itemName || 'Onigiri');
    res.json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

async function playWithPet(req, res) {
  try {
    const result = await petService.playWithPet(req.userId);
    res.json(result);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
}

module.exports = { getPet, feedPet, playWithPet };
