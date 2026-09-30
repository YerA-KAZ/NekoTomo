import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/providers/lesson_provider.dart';
import 'package:nekotomo_app/widgets/lesson_card.dart';
import 'package:nekotomo_app/screens/learn/lesson_detail_screen.dart';

class LearnScreen extends ConsumerStatefulWidget {
  const LearnScreen({super.key});

  @override
  ConsumerState<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends ConsumerState<LearnScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(lessonProvider.notifier).loadLessons();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(lessonProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Japanese N5',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Learn basic Japanese vocabulary',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 20),

              // Lessons list
              Expanded(
                child: state.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : state.error != null
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('😿', style: TextStyle(fontSize: 48)),
                                const SizedBox(height: 16),
                                Text(
                                  state.error!,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () => ref.read(lessonProvider.notifier).loadLessons(),
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          )
                        : state.lessons.isEmpty
                            ? const Center(
                                child: Text('No lessons available yet'),
                              )
                            : RefreshIndicator(
                                onRefresh: () => ref.read(lessonProvider.notifier).loadLessons(),
                                child: ListView.builder(
                                  itemCount: state.lessons.length,
                                  itemBuilder: (context, index) {
                                    final lesson = state.lessons[index];
                                    return LessonCard(
                                      lesson: lesson,
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => LessonDetailScreen(
                                              lessonId: lesson.id,
                                              lessonTitle: lesson.title,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
