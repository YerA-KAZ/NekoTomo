import 'package:flutter/foundation.dart';

/// API and app-wide constants
class ApiConstants {
  ApiConstants._();

  /// Base URL dynamically resolved for platform:
  /// - Web / Windows Desktop / iOS: http://localhost:3000/api
  /// - Android Emulator: http://10.0.2.2:3000/api
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000/api';
    } else {
      return 'http://localhost:3000/api';
    }
  }

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String me = '/auth/me';

  // Pet endpoints
  static const String pet = '/pet';
  static const String petFeed = '/pet/feed';
  static const String petPlay = '/pet/play';

  // Lesson endpoints
  static const String lessons = '/lessons';

  // Exercise endpoints
  static const String exercises = '/exercises';

  // Progress endpoints
  static const String progress = '/progress';

  // Inventory endpoints
  static const String inventory = '/inventory';
}

/// Pet asset paths
class PetAssets {
  PetAssets._();

  static const String basePath = 'assets/NEWNekoPetPhoto';
  static const String idle = '$basePath/IDLE.png';
  static const String happy = '$basePath/HAPPY.png';
  static const String sad = '$basePath/SAD.png';
  static const String hungry = '$basePath/HUNGRY.png';
  static const String eating = '$basePath/EATING.png';
  static const String playing = '$basePath/PLAYING.png';
  static const String sleeping = '$basePath/SLEEPING.png';
  static const String excited = '$basePath/EXCITED.png';
}

/// Room asset paths
class RoomAssets {
  RoomAssets._();

  static const String basePath = 'assets/RoomPhoto';
  static const String home = '$basePath/Home.jpg';
  static const String kitchen = '$basePath/Kitchen.jpg';
  static const String gameRoom = '$basePath/GameRoom.jpg';
}

/// XP required for each level
class XpConstants {
  XpConstants._();

  static const Map<int, int> levelXpRequired = {
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
}
