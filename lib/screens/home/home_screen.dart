import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/constants/api_constants.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/models/user.dart';
import 'package:nekotomo_app/providers/auth_provider.dart';
import 'package:nekotomo_app/providers/language_provider.dart';
import 'package:nekotomo_app/providers/pet_provider.dart';
import 'package:nekotomo_app/screens/home/main_shell.dart';
import 'package:nekotomo_app/widgets/game/game_action_button.dart';
import 'package:nekotomo_app/widgets/game/game_hud.dart';
import 'package:nekotomo_app/widgets/game/pet_display.dart';
import 'package:nekotomo_app/widgets/game/pet_status_bar.dart';
import 'package:nekotomo_app/widgets/game/room_background.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  PetState _activeState = PetState.idle;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(petProvider.notifier).loadPet();
    });
  }

  void _triggerFeed() async {
    final loc = ref.read(localizationsProvider);
    final success = await ref.read(petProvider.notifier).feedPet();
    if (mounted) {
      if (success) {
        setState(() => _activeState = PetState.eating);
        _showGameReward(
          icon: '🍙',
          title: loc.feedSuccessTitle,
          subtitle: loc.feedSuccessSubtitle,
          color: AppColors.primary,
        );
      } else {
        final error = ref.read(petProvider).error ?? loc.feedFullError;
        _showToast(error, AppColors.error);
      }
    }
  }

  void _triggerPlay() async {
    final loc = ref.read(localizationsProvider);
    final success = await ref.read(petProvider.notifier).playWithPet();
    if (mounted) {
      if (success) {
        setState(() => _activeState = PetState.playing);
        _showGameReward(
          icon: '🎮',
          title: loc.playSuccessTitle,
          subtitle: loc.playSuccessSubtitle,
          color: AppColors.sakura,
        );
      } else {
        final error = ref.read(petProvider).error ?? loc.playTiredError;
        _showToast(error, AppColors.error);
      }
    }
  }

  void _showGameReward({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: 8,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.96),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: color, width: 2),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(icon, style: const TextStyle(fontSize: 22)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showToast(String message, Color color) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 90),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final petState = ref.watch(petProvider);
    final loc = ref.watch(localizationsProvider);
    final pet = petState.pet;
    final username = authState.user?.username ?? 'Trainer';

    // Synchronize external state with local animation state when idle
    final currentPetState = _activeState != PetState.idle
        ? _activeState
        : (pet?.currentState ?? PetState.idle);

    final hunger = pet?.hunger ?? 80;
    final happiness = pet?.happiness ?? 80;

    return Scaffold(
      body: RoomBackground(
        imagePath: RoomAssets.home,
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Top Game HUD
                        GameHUD(
                          pet: pet,
                          username: username,
                          streakDays: 3,
                          onProfileTap: () {
                            ref.read(selectedTabProvider.notifier).state = 3;
                          },
                        ),

                        // Compact Floating Status Pills (Hunger & Happiness)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              PetStatusBar(
                                label: loc.hunger,
                                icon: '🍙',
                                value: hunger,
                                primaryColor: AppColors.primary,
                                secondaryColor: AppColors.secondary,
                                isCompact: true,
                              ),
                              const SizedBox(width: 12),
                              PetStatusBar(
                                label: loc.happiness,
                                icon: '🌸',
                                value: happiness,
                                primaryColor: AppColors.sakura,
                                secondaryColor: const Color(0xFFFFD1DC),
                                isCompact: true,
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Center Pet Character in the Living Room
                        Center(
                          child: PetDisplay(
                            petState: currentPetState,
                            size: constraints.maxHeight > 680 ? 250 : 210,
                            showShadow: true,
                            showSpeechBubble: true,
                            onTap: () {
                              setState(() => _activeState = PetState.excited);
                              Future.delayed(const Duration(seconds: 2), () {
                                if (mounted) {
                                  setState(() => _activeState = PetState.idle);
                                }
                              });
                            },
                          ),
                        ),

                        const Spacer(),

                        // Main Game Actions (FEED & PLAY)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              // FEED Button
                              Expanded(
                                child: GameActionButton(
                                  label: loc.feedAction,
                                  subtitle: 'ごはん 🍙',
                                  iconEmoji: '🍱',
                                  primaryColor: AppColors.primary,
                                  shadowColor: AppColors.primaryDark,
                                  isLoading: petState.isLoading && _activeState == PetState.eating,
                                  onTap: () {
                                    // Quick feed or go to kitchen
                                    _triggerFeed();
                                  },
                                ),
                              ),
                              const SizedBox(width: 14),

                              // PLAY Button
                              Expanded(
                                child: GameActionButton(
                                  label: loc.playAction,
                                  subtitle: 'あそぶ 🎮',
                                  iconEmoji: '🧶',
                                  primaryColor: AppColors.sakura,
                                  shadowColor: const Color(0xFFD4789C),
                                  isLoading: petState.isLoading && _activeState == PetState.playing,
                                  onTap: () {
                                    // Quick play or go to game room
                                    _triggerPlay();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Secondary Action: Learn Japanese N5 Pill
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {
                              ref.read(selectedTabProvider.notifier).state = 1;
                            },
                            child: Container(
                              height: 52,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.94),
                                borderRadius: BorderRadius.circular(22),
                                border: Border.all(color: AppColors.matcha, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.matcha.withValues(alpha: 0.25),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('📖', style: TextStyle(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  Text(
                                    loc.questBannerTitle,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 0.6,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.matcha),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Spacing to keep content comfortably above bottom navigation bar
                        const SizedBox(height: 95),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
