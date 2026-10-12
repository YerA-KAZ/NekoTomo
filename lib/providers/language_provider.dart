import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nekotomo_app/core/localization/app_localizations.dart';
import 'package:nekotomo_app/services/storage_service.dart';

class LanguageNotifier extends StateNotifier<AppLanguage> {
  final StorageService _storage = StorageService();

  LanguageNotifier() : super(AppLanguage.kk) {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final savedCode = await _storage.getLanguage();
    if (savedCode != null) {
      state = AppLanguage.fromCode(savedCode);
    } else {
      // Default to Kazakh as requested by user
      state = AppLanguage.kk;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    await _storage.saveLanguage(language.code);
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>((ref) {
  return LanguageNotifier();
});

final localizationsProvider = Provider<AppLocalizations>((ref) {
  final language = ref.watch(languageProvider);
  return AppLocalizations(language);
});
