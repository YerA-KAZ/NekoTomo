import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/services/api_service.dart';

class UserProgress {
  final String username;
  final String japaneseLevel;
  final int wordsLearned;
  final int lessonsCompleted;
  final int totalXp;
  final int streak;
  final int petLevel;
  final String petName;

  UserProgress({
    required this.username,
    required this.japaneseLevel,
    required this.wordsLearned,
    required this.lessonsCompleted,
    required this.totalXp,
    required this.streak,
    required this.petLevel,
    required this.petName,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      username: json['username'] ?? '',
      japaneseLevel: json['japaneseLevel'] ?? 'N5',
      wordsLearned: json['wordsLearned'] ?? 0,
      lessonsCompleted: json['lessonsCompleted'] ?? 0,
      totalXp: json['totalXp'] ?? 0,
      streak: json['streak'] ?? 0,
      petLevel: json['petLevel'] ?? 1,
      petName: json['petName'] ?? 'Neko',
    );
  }
}

class ProgressState {
  final UserProgress? progress;
  final bool isLoading;
  final String? error;

  ProgressState({this.progress, this.isLoading = false, this.error});
}

class ProgressNotifier extends StateNotifier<ProgressState> {
  final ApiService _api = ApiService();

  ProgressNotifier() : super(ProgressState());

  Future<void> loadProgress() async {
    try {
      state = ProgressState(isLoading: true);
      final response = await _api.getProgress();
      final progress = UserProgress.fromJson(response.data);
      state = ProgressState(progress: progress);
    } catch (e) {
      state = ProgressState(error: 'Failed to load progress');
    }
  }
}

final progressProvider =
    StateNotifierProvider<ProgressNotifier, ProgressState>((ref) {
  return ProgressNotifier();
});
