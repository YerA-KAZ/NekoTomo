class User {
  final int id;
  final String username;
  final String email;
  final Pet? pet;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.pet,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      pet: json['pet'] != null ? Pet.fromJson(json['pet']) : null,
    );
  }
}

class Pet {
  final int id;
  final int userId;
  final String name;
  final int level;
  final int xp;
  final int hunger;
  final int happiness;
  final String mood;
  final int xpForNextLevel;
  final DateTime? lastFed;
  final DateTime? lastPlayed;

  Pet({
    required this.id,
    required this.userId,
    required this.name,
    required this.level,
    required this.xp,
    required this.hunger,
    required this.happiness,
    required this.mood,
    this.xpForNextLevel = 100,
    this.lastFed,
    this.lastPlayed,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      name: json['name'] ?? 'Neko',
      level: json['level'] ?? 1,
      xp: json['xp'] ?? 0,
      hunger: json['hunger'] ?? 80,
      happiness: json['happiness'] ?? 80,
      mood: json['mood'] ?? 'idle',
      xpForNextLevel: json['xpForNextLevel'] ?? 100,
      lastFed: json['lastFed'] != null ? DateTime.parse(json['lastFed']) : null,
      lastPlayed: json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed']) : null,
    );
  }

  /// Determine the visual state based on stats
  PetState get currentState {
    if (hunger < 25) return PetState.hungry;
    if (happiness < 25) return PetState.sad;
    return PetState.idle;
  }
}

enum PetState {
  idle,
  happy,
  sad,
  hungry,
  eating,
  playing,
  sleeping,
  excited,
}
