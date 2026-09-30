class Exercise {
  final int id;
  final int lessonId;
  final String type;
  final Map<String, dynamic> question;
  final List<String>? options;

  Exercise({
    required this.id,
    required this.lessonId,
    required this.type,
    required this.question,
    this.options,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      lessonId: json['lessonId'] ?? json['lesson_id'] ?? 0,
      type: json['type'] ?? 'multiple_choice',
      question: json['question'] is Map<String, dynamic>
          ? json['question']
          : {},
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
    );
  }

  String get questionText => question['text'] ?? '';
  String? get questionJapanese => question['japanese'];
  String? get questionReading => question['reading'];
}

class ExerciseResult {
  final bool correct;
  final String? correctAnswer;
  final int xpEarned;
  final int coinsEarned;
  final bool leveledUp;
  final int? newLevel;

  ExerciseResult({
    required this.correct,
    this.correctAnswer,
    required this.xpEarned,
    required this.coinsEarned,
    required this.leveledUp,
    this.newLevel,
  });

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      correct: json['correct'] ?? false,
      correctAnswer: json['correctAnswer'],
      xpEarned: json['xpEarned'] ?? 0,
      coinsEarned: json['coinsEarned'] ?? 0,
      leveledUp: json['leveledUp'] ?? false,
      newLevel: json['newLevel'],
    );
  }
}

class LessonCompleteResult {
  final bool completed;
  final bool isPerfect;
  final int xpEarned;
  final int coinsEarned;
  final int foodEarned;
  final bool leveledUp;
  final int? newLevel;
  final int score;
  final int total;

  LessonCompleteResult({
    required this.completed,
    required this.isPerfect,
    required this.xpEarned,
    required this.coinsEarned,
    required this.foodEarned,
    required this.leveledUp,
    this.newLevel,
    required this.score,
    required this.total,
  });

  factory LessonCompleteResult.fromJson(Map<String, dynamic> json) {
    return LessonCompleteResult(
      completed: json['completed'] ?? false,
      isPerfect: json['isPerfect'] ?? false,
      xpEarned: json['xpEarned'] ?? 0,
      coinsEarned: json['coinsEarned'] ?? 0,
      foodEarned: json['foodEarned'] ?? 0,
      leveledUp: json['leveledUp'] ?? false,
      newLevel: json['newLevel'],
      score: json['score'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}
