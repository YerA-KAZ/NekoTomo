import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/core/localization/app_localizations.dart';
import 'package:nekotomo_app/models/exercise.dart';
import 'package:nekotomo_app/providers/language_provider.dart';
import 'package:nekotomo_app/providers/lesson_provider.dart';
import 'package:nekotomo_app/providers/pet_provider.dart';

class LessonDetailScreen extends ConsumerStatefulWidget {
  final int lessonId;
  final String lessonTitle;

  const LessonDetailScreen({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  ConsumerState<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends ConsumerState<LessonDetailScreen> {

  bool _showingVocab = true;
  int _vocabIndex = 0;
  int _exerciseIndex = 0;
  int _correctAnswers = 0;
  int _totalXpEarned = 0;
  String? _selectedAnswer;
  bool? _answerCorrect;
  bool _lessonComplete = false;
  LessonCompleteResult? _result;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(lessonProvider.notifier).loadLessonDetail(widget.lessonId);
      ref.read(lessonProvider.notifier).loadExercises(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonProvider);
    final loc = ref.watch(localizationsProvider);

    if (state.isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.categoryName(widget.lessonTitle))),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    if (_lessonComplete) {
      return _buildCompletionScreen();
    }

    final lesson = state.currentLesson;
    final exercises = state.exercises;
    final vocab = lesson?.vocabulary ?? [];

    // Show vocabulary first, then exercises
    if (_showingVocab && vocab.isNotEmpty && _vocabIndex < vocab.length) {
      return _buildVocabStep(vocab[_vocabIndex]);
    }

    if (!_showingVocab && _exerciseIndex < exercises.length) {
      return _buildExerciseStep(exercises[_exerciseIndex]);
    }

    return _buildCompletionScreen();
  }

  Widget _buildVocabStep(dynamic vocab) {
    final state = ref.watch(lessonProvider);
    final loc = ref.watch(localizationsProvider);
    final currentLang = ref.watch(languageProvider);
    final totalVocab = state.currentLesson?.vocabulary?.length ?? 0;

    final primaryMeaning = currentLang == AppLanguage.kk
        ? vocab.meaningKk
        : (currentLang == AppLanguage.ru ? vocab.meaningRu : (vocab.meaningKk.isNotEmpty ? vocab.meaningKk : vocab.meaningRu));
    final secondaryMeaning = currentLang == AppLanguage.kk
        ? vocab.meaningRu
        : (currentLang == AppLanguage.ru ? vocab.meaningKk : vocab.meaningRu);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(loc.categoryName(widget.lessonTitle)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: totalVocab > 0 ? (_vocabIndex + 1) / totalVocab : 0,
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            // Japanese word
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    loc.newWord,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    vocab.japanese,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vocab.reading,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          primaryMeaning,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (secondaryMeaning.isNotEmpty && secondaryMeaning != primaryMeaning) ...[
                          const SizedBox(height: 4),
                          Text(
                            secondaryMeaning,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (vocab.exampleSentence != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      vocab.exampleSentence!,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            const Spacer(),
            // Next button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _vocabIndex++;
                    final totalVocab = ref.read(lessonProvider).currentLesson?.vocabulary?.length ?? 0;
                    if (_vocabIndex >= totalVocab) {
                      _showingVocab = false;
                    }
                  });
                },
                child: Text(loc.next),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseStep(Exercise exercise) {
    final exercises = ref.watch(lessonProvider).exercises;
    final loc = ref.watch(localizationsProvider);
    final totalExercises = exercises.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(loc.exerciseProgress(_exerciseIndex + 1, totalExercises)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: totalExercises > 0 ? (_exerciseIndex + 1) / totalExercises : 0,
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.3),
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Question
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                exercise.questionText,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),

            // Options
            if (exercise.options != null)
              ...exercise.options!.map((option) {
                final isSelected = _selectedAnswer == option;
                final bool showResult = _answerCorrect != null;

                Color borderColor = AppColors.primaryLight.withValues(alpha: 0.3);
                Color bgColor = AppColors.surface;

                if (showResult && isSelected) {
                  borderColor = _answerCorrect! ? AppColors.success : AppColors.error;
                  bgColor = (_answerCorrect! ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.1);
                } else if (isSelected) {
                  borderColor = AppColors.primary;
                  bgColor = AppColors.primary.withValues(alpha: 0.05);
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: _answerCorrect != null
                        ? null
                        : () {
                            setState(() {
                              _selectedAnswer = option;
                            });
                          },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: borderColor, width: 2),
                      ),
                      child: Text(
                        option,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }),

            const Spacer(),

            // Feedback
            if (_answerCorrect != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: (_answerCorrect! ? AppColors.success : AppColors.error)
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      _answerCorrect! ? Icons.check_circle : Icons.cancel,
                      color: _answerCorrect! ? AppColors.success : AppColors.error,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _answerCorrect! ? loc.correctExerciseFeedback : loc.wrongExerciseFeedback,
                        style: TextStyle(
                          color: _answerCorrect! ? AppColors.success : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Submit / Next button
            ElevatedButton(
              onPressed: _selectedAnswer == null
                  ? null
                  : _answerCorrect != null
                      ? _nextExercise
                      : _submitAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: _answerCorrect != null
                    ? AppColors.primary
                    : AppColors.primary,
              ),
              child: Text(_answerCorrect != null ? loc.next : loc.check),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitAnswer() async {
    if (_selectedAnswer == null) return;

    final exercises = ref.read(lessonProvider).exercises;
    final exercise = exercises[_exerciseIndex];
    final result = await ref.read(lessonProvider.notifier).answerExercise(
      exercise.id,
      _selectedAnswer!,
    );

    if (result != null) {
      setState(() {
        _answerCorrect = result.correct;
        if (result.correct) {
          _correctAnswers++;
          _totalXpEarned += result.xpEarned;
        }
      });
    }
  }

  void _nextExercise() {
    final exercises = ref.read(lessonProvider).exercises;
    if (_exerciseIndex + 1 < exercises.length) {
      setState(() {
        _exerciseIndex++;
        _selectedAnswer = null;
        _answerCorrect = null;
      });
    } else {
      _completeLesson();
    }
  }

  Future<void> _completeLesson() async {
    final result = await ref.read(lessonProvider.notifier).completeLesson(widget.lessonId);
    // Refresh pet data
    ref.read(petProvider.notifier).loadPet();

    setState(() {
      _lessonComplete = true;
      _result = result;
    });
  }

  Widget _buildCompletionScreen() {
    final loc = ref.watch(localizationsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cat emoji
              const Text('🎉', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              Text(
                loc.lessonCompletedTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Results card
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _resultRow(loc.scoreLabel, '${_result?.score ?? _correctAnswers} / ${_result?.total ?? ref.read(lessonProvider).exercises.length}'),
                    const SizedBox(height: 12),
                    _resultRow(loc.xpEarnedLabel, '+${_result?.xpEarned ?? _totalXpEarned} ⭐'),
                    const SizedBox(height: 12),
                    _resultRow(loc.coinsLabel, '+${_result?.coinsEarned ?? 0} 🪙'),
                    const SizedBox(height: 12),
                    _resultRow(loc.foodRewardLabel, '+${_result?.foodEarned ?? 1} 🍙'),
                    if (_result?.leveledUp == true) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('✨', style: TextStyle(fontSize: 24)),
                            const SizedBox(width: 8),
                            Text(
                              loc.levelUpNotice(_result?.newLevel ?? 1),
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: AppColors.warning,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('✨', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                loc.nekoHappyMessage,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(loc.continueButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
