import 'package:flutter/material.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/models/lesson.dart';

/// Card widget for lesson list
class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.lesson,
    this.onTap,
  });

  IconData _categoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'greetings':
        return Icons.waving_hand;
      case 'food':
        return Icons.restaurant;
      case 'animals':
        return Icons.pets;
      case 'numbers':
        return Icons.tag;
      case 'colors':
        return Icons.palette;
      case 'family':
        return Icons.family_restroom;
      case 'daily life':
        return Icons.wb_sunny;
      default:
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = lesson.completed;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCompleted
              ? AppColors.success.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.3)
                : AppColors.primaryLight.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: isCompleted
                    ? AppColors.success.withValues(alpha: 0.15)
                    : AppColors.primaryLight.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isCompleted ? Icons.check_circle : _categoryIcon(lesson.category),
                color: isCompleted ? AppColors.success : AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lesson.wordCount} words · ${lesson.exerciseCount} exercises',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (lesson.progress != null) ...[
                    const SizedBox(height: 8),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: lesson.progressPercent,
                        backgroundColor: AppColors.primaryLight.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation(
                          isCompleted ? AppColors.success : AppColors.primary,
                        ),
                        minHeight: 5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              color: AppColors.textHint,
            ),
          ],
        ),
      ),
    );
  }
}
