import 'package:flutter_test/flutter_test.dart';
import 'package:nekotomo_app/core/localization/app_localizations.dart';

void main() {
  group('AppLocalizations Tests', () {
    test('Kazakh localization has correct strings', () {
      const loc = AppLocalizations(AppLanguage.kk);

      expect(loc.navHome, 'Басты');
      expect(loc.navLearn, 'Оқу');
      expect(loc.navPet, 'Мысық');
      expect(loc.navProfile, 'Профиль');
      expect(loc.languageSettingsTitle, 'Қолданба тілі');
      expect(loc.languageSettingsSubtitle, 'Қазақ, орыс немесе ағылшын тілін таңдаңыз');
      expect(loc.trainerTitle, '🎌 Жапон тілі N5 Жаттықтырушы');
      expect(loc.hunger, 'Тоқтық');
      expect(loc.happiness, 'Қуаныш');
      expect(loc.foodName('onigiri'), 'Онигири');
      expect(loc.toyName('yarn ball'), 'Шумақ жіп');
      expect(loc.categoryName('Greetings'), 'Сәлемдесу');
      expect(loc.categoryName('Food'), 'Тағам');
    });

    test('Russian localization has correct strings', () {
      const loc = AppLocalizations(AppLanguage.ru);

      expect(loc.navHome, 'Главная');
      expect(loc.navLearn, 'Уроки');
      expect(loc.languageSettingsTitle, 'Язык приложения');
      expect(loc.trainerTitle, '🎌 Японский N5 Тренер');
      expect(loc.categoryName('Greetings'), 'Приветствия');
    });

    test('English localization has correct strings', () {
      const loc = AppLocalizations(AppLanguage.en);

      expect(loc.navHome, 'Home');
      expect(loc.navLearn, 'Learn');
      expect(loc.languageSettingsTitle, 'App Language');
      expect(loc.trainerTitle, '🎌 Japanese N5 Trainer');
      expect(loc.categoryName('Greetings'), 'Greetings');
    });

    test('AppLanguage enum fromCode returns correct language', () {
      expect(AppLanguage.fromCode('kk'), AppLanguage.kk);
      expect(AppLanguage.fromCode('ru'), AppLanguage.ru);
      expect(AppLanguage.fromCode('en'), AppLanguage.en);
      expect(AppLanguage.fromCode('unknown'), AppLanguage.kk);
    });
  });
}
