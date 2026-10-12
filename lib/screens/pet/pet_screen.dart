import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/constants/api_constants.dart';
import 'package:nekotomo_app/core/constants/app_colors.dart';
import 'package:nekotomo_app/models/user.dart';
import 'package:nekotomo_app/providers/language_provider.dart';
import 'package:nekotomo_app/providers/pet_provider.dart';
import 'package:nekotomo_app/screens/home/main_shell.dart';
import 'package:nekotomo_app/widgets/game/game_action_button.dart';
import 'package:nekotomo_app/widgets/game/pet_display.dart';
import 'package:nekotomo_app/widgets/game/pet_status_bar.dart';
import 'package:nekotomo_app/widgets/game/room_background.dart';

class PetScreen extends ConsumerStatefulWidget {
  const PetScreen({super.key});

  @override
  ConsumerState<PetScreen> createState() => _PetScreenState();
}

class _PetScreenState extends ConsumerState<PetScreen> {
  PetState _transientState = PetState.idle;
  int _selectedFoodIndex = 0;
  int _selectedToyIndex = 0;

  final List<Map<String, dynamic>> _foodOptions = [
    {'name': 'Onigiri', 'jp': 'おにぎり', 'emoji': '🍙', 'gain': '+20'},
    {'name': 'Tuna Bowl', 'jp': 'まぐろ', 'emoji': '🐟', 'gain': '+35'},
    {'name': 'Milk', 'jp': 'ミルク', 'emoji': '🥛', 'gain': '+15'},
    {'name': 'Treats', 'jp': 'おやつ', 'emoji': '🍡', 'gain': '+25'},
  ];

  final List<Map<String, dynamic>> _toyOptions = [
    {'name': 'Yarn Ball', 'jp': 'けいと', 'emoji': '🧶', 'gain': '+20'},
    {'name': 'Toy Mouse', 'jp': 'ねずみ', 'emoji': '🐭', 'gain': '+30'},
    {'name': 'Bell Wand', 'jp': 'すず', 'emoji': '🔔', 'gain': '+15'},
    {'name': 'Laser Pen', 'jp': 'ひかり', 'emoji': '✨', 'gain': '+35'},
  ];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(petProvider.notifier).loadPet();
    });
  }

  void _onFeed() async {
    final loc = ref.read(localizationsProvider);
    final food = _foodOptions[_selectedFoodIndex];
    final localizedName = loc.foodName(food['name'] as String);
    setState(() => _transientState = PetState.eating);

    final success = await ref.read(petProvider.notifier).feedPet();
    if (mounted) {
      if (success) {
        _showSuccessBanner(
          icon: food['emoji'] as String,
          title: loc.feedPetTitle(localizedName),
          subtitle: loc.feedPetSubtitle(food['gain'] as String),
          color: AppColors.primary,
        );
      } else {
        setState(() => _transientState = PetState.idle);
        final error = ref.read(petProvider).error ?? loc.feedFullError;
        _showToast(error, AppColors.error);
      }
    }
  }

  void _onPlay() async {
    final loc = ref.read(localizationsProvider);
    final toy = _toyOptions[_selectedToyIndex];
    final localizedName = loc.toyName(toy['name'] as String);
    setState(() => _transientState = PetState.playing);

    final success = await ref.read(petProvider.notifier).playWithPet();
    if (mounted) {
      if (success) {
        _showSuccessBanner(
          icon: toy['emoji'] as String,
          title: loc.playPetTitle(localizedName),
          subtitle: loc.playPetSubtitle(toy['gain'] as String),
          color: AppColors.sakura,
        );
      } else {
        setState(() => _transientState = PetState.idle);
        final error = ref.read(petProvider).error ?? loc.playTiredError;
        _showToast(error, AppColors.error);
      }
    }
  }

  void _showSuccessBanner({
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
    final petState = ref.watch(petProvider);
    final loc = ref.watch(localizationsProvider);
    final pet = petState.pet;
    final sceneMode = ref.watch(petSceneModeProvider);
    final isFeedMode = sceneMode == PetSceneMode.feed;

    // Room photo based on scene
    final roomImage = isFeedMode ? RoomAssets.kitchen : RoomAssets.gameRoom;

    // Current pet state
    PetState displayState = _transientState != PetState.idle
        ? _transientState
        : (isFeedMode && (pet?.hunger ?? 80) < 50
            ? PetState.hungry
            : (pet?.currentState ?? PetState.idle));

    return Scaffold(
      body: RoomBackground(
        imagePath: roomImage,
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
                        const SizedBox(height: 8),

                        // Scene Mode Switcher (Kitchen / Game Room)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.92),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.shadow.withValues(alpha: 0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // FEED (Kitchen) Tab
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ref.read(petSceneModeProvider.notifier).state = PetSceneMode.feed;
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isFeedMode ? AppColors.primary : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: isFeedMode
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.primary.withValues(alpha: 0.3),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('🍙', style: TextStyle(fontSize: 16)),
                                          const SizedBox(width: 6),
                                          Text(
                                            loc.modeFeed,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: isFeedMode ? Colors.white : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                // PLAY (Game Room) Tab
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      ref.read(petSceneModeProvider.notifier).state = PetSceneMode.play;
                                    },
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 200),
                                      padding: const EdgeInsets.symmetric(vertical: 10),
                                      decoration: BoxDecoration(
                                        color: !isFeedMode ? AppColors.sakura : Colors.transparent,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: !isFeedMode
                                            ? [
                                                BoxShadow(
                                                  color: AppColors.sakura.withValues(alpha: 0.3),
                                                  blurRadius: 6,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ]
                                            : null,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Text('🎮', style: TextStyle(fontSize: 16)),
                                          const SizedBox(width: 6),
                                          Text(
                                            loc.modePlay,
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                              color: !isFeedMode ? Colors.white : AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Scene Objective Title Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.90),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isFeedMode ? AppColors.primaryLight : AppColors.sakura,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadow.withValues(alpha: 0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isFeedMode ? '🍙 ${loc.actionFeedCat.toUpperCase()}' : '🎮 ${loc.actionPlayCat.toUpperCase()}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.8,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Center Pet Character in the Room
                        Center(
                          child: PetDisplay(
                            petState: displayState,
                            size: constraints.maxHeight > 680 ? 250 : 210,
                            showShadow: true,
                            showSpeechBubble: true,
                            speechBubbleText: isFeedMode
                                ? (_transientState == PetState.eating ? 'Mogumogu... Oishii! 🍱' : 'Feed me something tasty! 🍙')
                                : (_transientState == PetState.playing ? 'Waku-waku! So much fun! ⭐' : 'Let\'s play together! 🎮'),
                          ),
                        ),

                        const Spacer(),

                        // Interactive Selection Tray (Food or Toys)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Status Bar for Active Stat
                              isFeedMode
                                  ? PetStatusBar(
                                      label: loc.hunger,
                                      icon: '🍙',
                                      value: pet?.hunger ?? 80,
                                      primaryColor: AppColors.primary,
                                      secondaryColor: AppColors.secondary,
                                    )
                                  : PetStatusBar(
                                      label: loc.happiness,
                                      icon: '🌸',
                                      value: pet?.happiness ?? 80,
                                      primaryColor: AppColors.sakura,
                                      secondaryColor: const Color(0xFFFFD1DC),
                                    ),

                              const SizedBox(height: 12),

                              // Carousel / Items Tray
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(22),
                                  border: Border.all(color: Colors.white, width: 2),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadow.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: List.generate(4, (index) {
                                    final item = isFeedMode ? _foodOptions[index] : _toyOptions[index];
                                    final isSelected = isFeedMode
                                        ? _selectedFoodIndex == index
                                        : _selectedToyIndex == index;
                                    final accentColor = isFeedMode ? AppColors.primary : AppColors.sakura;
                                    final itemName = isFeedMode
                                        ? loc.foodName(item['name'] as String)
                                        : loc.toyName(item['name'] as String);

                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isFeedMode) {
                                            _selectedFoodIndex = index;
                                          } else {
                                            _selectedToyIndex = index;
                                          }
                                        });
                                      },
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? accentColor.withValues(alpha: 0.15)
                                              : Colors.transparent,
                                          borderRadius: BorderRadius.circular(16),
                                          border: Border.all(
                                            color: isSelected ? accentColor : Colors.transparent,
                                            width: 2,
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(item['emoji'] as String, style: const TextStyle(fontSize: 28)),
                                            const SizedBox(height: 4),
                                            Text(
                                              itemName,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 11,
                                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                                color: isSelected ? accentColor : AppColors.textPrimary,
                                              ),
                                            ),
                                            Text(
                                              item['gain'] as String,
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: accentColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Big Main Action Button
                              isFeedMode
                                  ? GameActionButton(
                                      label: '${loc.feedAction.toUpperCase()}: ${loc.foodName(_foodOptions[_selectedFoodIndex]['name'] as String).toUpperCase()}',
                                      subtitle: 'ごはんを あげる 🍙',
                                      iconEmoji: _foodOptions[_selectedFoodIndex]['emoji'] as String,
                                      primaryColor: AppColors.primary,
                                      shadowColor: AppColors.primaryDark,
                                      isLoading: petState.isLoading && _transientState == PetState.eating,
                                      onTap: _onFeed,
                                    )
                                  : GameActionButton(
                                      label: '${loc.playAction.toUpperCase()}: ${loc.toyName(_toyOptions[_selectedToyIndex]['name'] as String).toUpperCase()}',
                                      subtitle: 'いっしょに あそぶ 🎮',
                                      iconEmoji: _toyOptions[_selectedToyIndex]['emoji'] as String,
                                      primaryColor: AppColors.sakura,
                                      shadowColor: const Color(0xFFD4789C),
                                      isLoading: petState.isLoading && _transientState == PetState.playing,
                                      onTap: _onPlay,
                                    ),
                            ],
                          ),
                        ),

                        // Keep above floating dock
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
