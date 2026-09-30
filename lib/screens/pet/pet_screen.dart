import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/models/user.dart';
import 'package:nekotomo_app/providers/pet_provider.dart';
import 'package:nekotomo_app/widgets/pet_widget.dart';
import 'package:nekotomo_app/widgets/stat_bar.dart';

class PetScreen extends ConsumerStatefulWidget {
  const PetScreen({super.key});

  @override
  ConsumerState<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends ConsumerState<PetScreen> {
  PetState _animationState = PetState.idle;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(petProvider.notifier).loadPet();
    });
  }

  @override
  Widget build(BuildContext context) {
    final petState = ref.watch(petProvider);
    final pet = petState.pet;

    // Update animation state based on pet mood
    if (pet != null) {
      _animationState = pet.currentState;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Pet display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primaryLight.withValues(alpha: 0.4),
                      AppColors.background,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  children: [
                    PetWidget(
                      petState: _animationState,
                      size: 260,
                      onTap: () {
                        setState(() {
                          _animationState = PetState.happy;
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          if (mounted) {
                            setState(() {
                              _animationState = pet?.currentState ?? PetState.idle;
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      pet?.name ?? 'Neko',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.level.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Level ${pet?.level ?? 1}',
                        style: TextStyle(
                          color: AppColors.level,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Stats card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow.withValues(alpha: 0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    StatBar(
                      label: 'XP',
                      icon: '⭐',
                      value: pet?.xp ?? 0,
                      maxValue: pet?.xpForNextLevel ?? 100,
                      color: AppColors.xp,
                    ),
                    const SizedBox(height: 16),
                    StatBar(
                      label: 'Hunger',
                      icon: '🍗',
                      value: pet?.hunger ?? 80,
                      maxValue: 100,
                      color: AppColors.hunger,
                    ),
                    const SizedBox(height: 16),
                    StatBar(
                      label: 'Happiness',
                      icon: '❤️',
                      value: pet?.happiness ?? 80,
                      maxValue: 100,
                      color: AppColors.happiness,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: '🍙',
                      label: 'Feed',
                      subtitle: 'Give food',
                      color: AppColors.hunger,
                      onTap: () async {
                        final success = await ref.read(petProvider.notifier).feedPet();
                        if (success && mounted) {
                          setState(() => _animationState = PetState.eating);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🍙 Yummy! Neko enjoyed the food!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        } else if (mounted) {
                          final error = ref.read(petProvider).error;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error ?? 'Could not feed')),
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ActionButton(
                      icon: '🎮',
                      label: 'Play',
                      subtitle: 'Have fun',
                      color: AppColors.happiness,
                      onTap: () async {
                        final success = await ref.read(petProvider.notifier).playWithPet();
                        if (success && mounted) {
                          setState(() => _animationState = PetState.playing);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('🎮 Neko had fun playing!'),
                              backgroundColor: AppColors.success,
                            ),
                          );
                        } else if (mounted) {
                          final error = ref.read(petProvider).error;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error ?? 'Could not play')),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),

              // Message display
              if (petState.error != null || petState.message != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (petState.error != null ? AppColors.error : AppColors.success)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    petState.error ?? petState.message ?? '',
                    style: TextStyle(
                      color: petState.error != null ? AppColors.error : AppColors.success,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 36)),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
