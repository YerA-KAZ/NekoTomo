import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/theme/app_theme.dart';
import 'package:nekotomo_app/providers/language_provider.dart';
import 'package:nekotomo_app/screens/splash/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: NekoTomoApp(),
    ),
  );
}

class NekoTomoApp extends ConsumerWidget {
  const NekoTomoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);

    return MaterialApp(
      title: 'NekoTomo',
      debugShowCheckedModeBanner: false,
      locale: Locale(language.code),
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
