import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/screens/home/home_screen.dart';
import 'package:nekotomo_app/screens/learn/learn_screen.dart';
import 'package:nekotomo_app/screens/pet/pet_screen.dart';
import 'package:nekotomo_app/screens/profile/profile_screen.dart';
import 'package:nekotomo_app/widgets/game/game_bottom_navigation.dart';

enum PetSceneMode { feed, play }

final selectedTabProvider = StateProvider<int>((ref) => 0);
final petSceneModeProvider = StateProvider<PetSceneMode>((ref) => PetSceneMode.feed);

/// Main shell with floating kawaii game navigation dock
class MainShell extends ConsumerWidget {
  const MainShell({super.key});

  static const _screens = [
    HomeScreen(),
    LearnScreen(),
    PetScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedTabProvider);

    return Scaffold(
      extendBody: true, // Allows full screen backgrounds to reach bottom behind dock
      body: IndexedStack(
        index: selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: GameBottomNavigation(
        currentIndex: selectedIndex,
        onTabSelected: (index) {
          ref.read(selectedTabProvider.notifier).state = index;
        },
      ),
    );
  }
}
