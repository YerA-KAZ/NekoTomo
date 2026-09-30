import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/models/user.dart';
import 'package:nekotomo_app/providers/auth_provider.dart';
import 'package:nekotomo_app/providers/pet_provider.dart';
import 'package:nekotomo_app/widgets/pet_widget.dart';
import 'package:nekotomo_app/widgets/stat_bar.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Load pet data
    Future.microtask(() {
      ref.read(petProvider.notifier).loadPet();
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final petState = ref.watch(petProvider);
    final pet = petState.pet;
    final username = authState.user?.username ?? 'Friend';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting
              Text(
                '${_getGreeting()}, $username! 👋',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'How is your Japanese learning going?',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Pet card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.5),
                      AppColors.secondaryLight.withValues(alpha: 0.3),
                    ],
                  ),
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
                    // Pet
                    PetWidget(
                      petState: pet?.currentState ?? PetState.idle,
                      size: 180,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pet?.name ?? 'Neko',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      'Level ${pet?.level ?? 1}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.xp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Stats
                    StatBar(
                      label: 'XP',
                      icon: '⭐',
                      value: pet?.xp ?? 0,
                      maxValue: pet?.xpForNextLevel ?? 100,
                      color: AppColors.xp,
                    ),
                    const SizedBox(height: 12),
                    StatBar(
                      label: 'Happiness',
                      icon: '❤️',
                      value: pet?.happiness ?? 80,
                      maxValue: 100,
                      color: AppColors.happiness,
                    ),
                    const SizedBox(height: 12),
                    StatBar(
                      label: 'Hunger',
                      icon: '🍗',
                      value: pet?.hunger ?? 80,
                      maxValue: 100,
                      color: AppColors.hunger,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Quick actions
              Text(
                'Quick Actions',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _QuickActionButton(
                      icon: '📚',
                      label: 'Learn',
                      color: AppColors.info,
                      onTap: () {
                        // Navigate to Learn tab
                        // This is handled by the parent MainShell
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionButton(
                      icon: '🍙',
                      label: 'Feed',
                      color: AppColors.hunger,
                      onTap: () async {
                        await ref.read(petProvider.notifier).feedPet();
                        if (mounted) {
                          final state = ref.read(petProvider);
                          if (state.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          } else if (state.message != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🍙 Fed Neko! ${state.message}'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _QuickActionButton(
                      icon: '🎮',
                      label: 'Play',
                      color: AppColors.happiness,
                      onTap: () async {
                        await ref.read(petProvider.notifier).playWithPet();
                        if (mounted) {
                          final state = ref.read(petProvider);
                          if (state.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(state.error!)),
                            );
                          } else if (state.message != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🎮 Played with Neko! ${state.message}'),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
