import 'package:nekotomo_app/models/vocabulary.dart';

class Lesson {
  final int id;
  final String title;
  final String description;
  final String level;
  final String category;
  final int orderIndex;
  final int wordCount;
  final int exerciseCount;
  final LessonProgress? progress;
  final bool completed;
  final List<Vocabulary>? vocabulary;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.category,
    required this.orderIndex,
    this.wordCount = 0,
    this.exerciseCount = 0,
    this.progress,
    this.completed = false,
    this.vocabulary,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      level: json['level'] ?? 'N5',
      category: json['category'] ?? '',
      orderIndex: json['orderIndex'] ?? json['order_index'] ?? 0,
      wordCount: json['wordCount'] ?? 0,
      exerciseCount: json['exerciseCount'] ?? 0,
      progress: json['progress'] != null
          ? LessonProgress.fromJson(json['progress'])
          : null,
      completed: json['completed'] ?? false,
      vocabulary: json['vocabulary'] != null
          ? (json['vocabulary'] as List)
              .map((v) => Vocabulary.fromJson(v))
              .toList()
          : null,
    );
  }

  double get progressPercent {
    if (progress == null || progress!.exercisesTotal == 0) return 0;
    return progress!.exercisesCompleted / progress!.exercisesTotal;
  }
}

class LessonProgress {
  final int exercisesCompleted;
  final int exercisesTotal;
  final int score;
  final bool completed;

  LessonProgress({
    required this.exercisesCompleted,
    required this.exercisesTotal,
    required this.score,
    required this.completed,
  });

  factory LessonProgress.fromJson(Map<String, dynamic> json) {
    return LessonProgress(
      exercisesCompleted: json['exercisesCompleted'] ?? json['exercises_completed'] ?? 0,
      exercisesTotal: json['exercisesTotal'] ?? json['exercises_total'] ?? 0,
      score: json['score'] ?? 0,
      completed: json['completed'] ?? false,
    );
  }
}
