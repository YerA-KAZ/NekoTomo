import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/models/lesson.dart';
import 'package:nekotomo_app/models/exercise.dart';
import 'package:nekotomo_app/services/api_service.dart';

class LessonState {
  final List<Lesson> lessons;
  final Lesson? currentLesson;
  final List<Exercise> exercises;
  final bool isLoading;
  final String? error;

  LessonState({
    this.lessons = const [],
    this.currentLesson,
    this.exercises = const [],
    this.isLoading = false,
    this.error,
  });

  LessonState copyWith({
    List<Lesson>? lessons,
    Lesson? currentLesson,
    List<Exercise>? exercises,
    bool? isLoading,
    String? error,
  }) {
    return LessonState(
      lessons: lessons ?? this.lessons,
      currentLesson: currentLesson ?? this.currentLesson,
      exercises: exercises ?? this.exercises,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LessonNotifier extends StateNotifier<LessonState> {
  final ApiService _api = ApiService();

  LessonNotifier() : super(LessonState());

  Future<void> loadLessons() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.getLessons();
      final lessons = (response.data as List)
          .map((json) => Lesson.fromJson(json))
          .toList();
      state = LessonState(lessons: lessons);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load lessons');
    }
  }

  Future<void> loadLessonDetail(int id) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.getLessonDetail(id);
      final lesson = Lesson.fromJson(response.data);
      state = state.copyWith(currentLesson: lesson, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load lesson');
    }
  }

  Future<void> loadExercises(int lessonId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      final response = await _api.getExercises(lessonId);
      final exercises = (response.data as List)
          .map((json) => Exercise.fromJson(json))
          .toList();
      state = state.copyWith(exercises: exercises, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load exercises');
    }
  }

  Future<ExerciseResult?> answerExercise(int exerciseId, String answer) async {
    try {
      final response = await _api.answerExercise(exerciseId, answer);
      return ExerciseResult.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }

  Future<LessonCompleteResult?> completeLesson(int lessonId) async {
    try {
      final response = await _api.completeLesson(lessonId);
      return LessonCompleteResult.fromJson(response.data);
    } catch (e) {
      return null;
    }
  }
}

final lessonProvider = StateNotifierProvider<LessonNotifier, LessonState>((ref) {
  return LessonNotifier();
});
