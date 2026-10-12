enum AppLanguage {
  kk('kk', 'Қазақша', '🇰🇿', 'Kazakh'),
  ru('ru', 'Русский', '🇷🇺', 'Russian'),
  en('en', 'English', '🇬🇧', 'English');

  final String code;
  final String label;
  final String flag;
  final String englishName;

  const AppLanguage(this.code, this.label, this.flag, this.englishName);

  static AppLanguage fromCode(String? code) {
    switch (code) {
      case 'kk':
        return AppLanguage.kk;
      case 'ru':
        return AppLanguage.ru;
      case 'en':
        return AppLanguage.en;
      default:
        return AppLanguage.kk; // Default to Kazakh as requested
    }
  }
}

class AppLocalizations {
  final AppLanguage language;

  const AppLocalizations(this.language);

  // Navigation
  String get navHome => switch (language) {
    AppLanguage.kk => 'Басты',
    AppLanguage.ru => 'Главная',
    AppLanguage.en => 'Home',
  };

  String get navLearn => switch (language) {
    AppLanguage.kk => 'Оқу',
    AppLanguage.ru => 'Уроки',
    AppLanguage.en => 'Learn',
  };

  String get navPet => switch (language) {
    AppLanguage.kk => 'Мысық',
    AppLanguage.ru => 'Питомец',
    AppLanguage.en => 'Pet',
  };

  String get navProfile => switch (language) {
    AppLanguage.kk => 'Профиль',
    AppLanguage.ru => 'Профиль',
    AppLanguage.en => 'Profile',
  };

  // Profile
  String get trainerTitle => switch (language) {
    AppLanguage.kk => '🎌 Жапон тілі N5 Жаттықтырушы',
    AppLanguage.ru => '🎌 Японский N5 Тренер',
    AppLanguage.en => '🎌 Japanese N5 Trainer',
  };

  String get petLoyalCompanion => switch (language) {
    AppLanguage.kk => 'Сенімді серік 🐾',
    AppLanguage.ru => 'Верный компаньон 🐾',
    AppLanguage.en => 'Bond: Loyal Companion 🐾',
  };

  String get adventureStatistics => switch (language) {
    AppLanguage.kk => 'Шытырман оқиға статистикасы',
    AppLanguage.ru => 'Статистика приключений',
    AppLanguage.en => 'Adventure Statistics',
  };

  String get wordsMastered => switch (language) {
    AppLanguage.kk => 'Меңгерілген сөздер',
    AppLanguage.ru => 'Изучено слов',
    AppLanguage.en => 'Words Mastered',
  };

  String get questsCompleted => switch (language) {
    AppLanguage.kk => 'Аяқталған тапсырмалар',
    AppLanguage.ru => 'Пройдено квестов',
    AppLanguage.en => 'Quests Completed',
  };

  String get totalXpEarned => switch (language) {
    AppLanguage.kk => 'Барлық жиналған XP',
    AppLanguage.ru => 'Всего опыта (XP)',
    AppLanguage.en => 'Total EXP Earned',
  };

  String get studyStreak => switch (language) {
    AppLanguage.kk => 'Оқу сериясы',
    AppLanguage.ru => 'Серия занятий',
    AppLanguage.en => 'Study Streak',
  };

  String get daysUnit => switch (language) {
    AppLanguage.kk => 'күн',
    AppLanguage.ru => 'дней',
    AppLanguage.en => 'Days',
  };

  String get achievementBadges => switch (language) {
    AppLanguage.kk => 'Жетістік белгілері',
    AppLanguage.ru => 'Значки достижений',
    AppLanguage.en => 'Achievement Badges',
  };

  String get badgeFirstStep => switch (language) {
    AppLanguage.kk => 'Алғашқы қадам',
    AppLanguage.ru => 'Первый шаг',
    AppLanguage.en => 'First Step',
  };

  String get badgeChef => switch (language) {
    AppLanguage.kk => 'Аспаз',
    AppLanguage.ru => 'Шеф',
    AppLanguage.en => 'Chef',
  };

  String get badgeBestPal => switch (language) {
    AppLanguage.kk => 'Үздік дос',
    AppLanguage.ru => 'Лучший друг',
    AppLanguage.en => 'Best Pal',
  };

  String get badgeMaster => switch (language) {
    AppLanguage.kk => 'Шебер',
    AppLanguage.ru => 'Мастер',
    AppLanguage.en => 'Master',
  };

  // Language Settings in Profile
  String get languageSettingsTitle => switch (language) {
    AppLanguage.kk => 'Қолданба тілі',
    AppLanguage.ru => 'Язык приложения',
    AppLanguage.en => 'App Language',
  };

  String get languageSettingsSubtitle => switch (language) {
    AppLanguage.kk => 'Қазақ, орыс немесе ағылшын тілін таңдаңыз',
    AppLanguage.ru => 'Выберите казахский, русский или английский',
    AppLanguage.en => 'Choose Kazakh, Russian, or English',
  };

  String get selectLanguage => switch (language) {
    AppLanguage.kk => 'Тілді таңдаңыз',
    AppLanguage.ru => 'Выбор языка',
    AppLanguage.en => 'Select Language',
  };

  String languageChangedNotice(String name) => switch (language) {
    AppLanguage.kk => 'Тіл өзгертілді: $name 🇰🇿',
    AppLanguage.ru => 'Язык изменен: $name',
    AppLanguage.en => 'Language changed: $name',
  };

  String get logout => switch (language) {
    AppLanguage.kk => 'ШЫҒУ',
    AppLanguage.ru => 'ВЫЙТИ',
    AppLanguage.en => 'LOGOUT',
  };

  // Home Screen & HUD
  String get levelLabel => switch (language) {
    AppLanguage.kk => 'Деңгей',
    AppLanguage.ru => 'Ур.',
    AppLanguage.en => 'Lv.',
  };

  String get feedAction => switch (language) {
    AppLanguage.kk => 'Тамақ беру',
    AppLanguage.ru => 'Покормить',
    AppLanguage.en => 'Feed Neko',
  };

  String get playAction => switch (language) {
    AppLanguage.kk => 'Ойнау',
    AppLanguage.ru => 'Поиграть',
    AppLanguage.en => 'Play with Neko',
  };

  String get actionFeedCat => switch (language) {
    AppLanguage.kk => 'Мысыққа тамақ беру',
    AppLanguage.ru => 'Покормить питомца',
    AppLanguage.en => 'Feed Your Pet',
  };

  String get actionPlayCat => switch (language) {
    AppLanguage.kk => 'Мысықпен ойнау',
    AppLanguage.ru => 'Поиграть с питомцем',
    AppLanguage.en => 'Play With Your Pet',
  };

  String get feedSuccessTitle => switch (language) {
    AppLanguage.kk => 'Дәмді ас! Өте керемет! 🍙',
    AppLanguage.ru => 'Вкуснотища! Ням-ням! 🍙',
    AppLanguage.en => 'Oishii! Yummy Meal! 🍙',
  };

  String get feedSuccessSubtitle => switch (language) {
    AppLanguage.kk => '+20 Аштық • Риза мырлау',
    AppLanguage.ru => '+20 Сытость • Довольное мурчание',
    AppLanguage.en => '+20 Hunger • Happy Purrs',
  };

  String get feedFullError => switch (language) {
    AppLanguage.kk => 'Мысық қазір тоқ!',
    AppLanguage.ru => 'Котик уже сыт!',
    AppLanguage.en => 'Neko is already full!',
  };

  String get playSuccessTitle => switch (language) {
    AppLanguage.kk => 'Көңілді ойын! 🎮',
    AppLanguage.ru => 'Веселая игра! 🎮',
    AppLanguage.en => 'Tanoshii! So Much Fun! 🎮',
  };

  String get playSuccessSubtitle => switch (language) {
    AppLanguage.kk => '+25 Қуаныш • +10 XP',
    AppLanguage.ru => '+25 Счастье • +10 XP',
    AppLanguage.en => '+25 Happiness • +10 XP',
  };

  String get playTiredError => switch (language) {
    AppLanguage.kk => 'Мысық қазір шаршап тұр!',
    AppLanguage.ru => 'Котик сейчас устал!',
    AppLanguage.en => 'Neko is tired right now!',
  };

  // Pet Screen
  String get hunger => switch (language) {
    AppLanguage.kk => 'Тоқтық',
    AppLanguage.ru => 'Сытость',
    AppLanguage.en => 'Hunger',
  };

  String get happiness => switch (language) {
    AppLanguage.kk => 'Қуаныш',
    AppLanguage.ru => 'Счастье',
    AppLanguage.en => 'Happiness',
  };

  String get energy => switch (language) {
    AppLanguage.kk => 'Энергия',
    AppLanguage.ru => 'Энергия',
    AppLanguage.en => 'Energy',
  };

  String get modeFeed => switch (language) {
    AppLanguage.kk => 'Тамақтандыру',
    AppLanguage.ru => 'Кормление',
    AppLanguage.en => 'Feed Mode',
  };

  String get modePlay => switch (language) {
    AppLanguage.kk => 'Ойнау',
    AppLanguage.ru => 'Игры',
    AppLanguage.en => 'Play Mode',
  };

  String foodName(String raw) => switch (raw.toLowerCase()) {
    'onigiri' => switch (language) {
      AppLanguage.kk => 'Онигири',
      AppLanguage.ru => 'Онигири',
      AppLanguage.en => 'Onigiri',
    },
    'tuna bowl' => switch (language) {
      AppLanguage.kk => 'Тунец тостағаны',
      AppLanguage.ru => 'Миска с тунцом',
      AppLanguage.en => 'Tuna Bowl',
    },
    'milk' => switch (language) {
      AppLanguage.kk => 'Сүт',
      AppLanguage.ru => 'Молоко',
      AppLanguage.en => 'Milk',
    },
    'treats' => switch (language) {
      AppLanguage.kk => 'Тәттілер',
      AppLanguage.ru => 'Вкусняшки',
      AppLanguage.en => 'Treats',
    },
    _ => raw,
  };

  String toyName(String raw) => switch (raw.toLowerCase()) {
    'yarn ball' => switch (language) {
      AppLanguage.kk => 'Шумақ жіп',
      AppLanguage.ru => 'Клубок пряжи',
      AppLanguage.en => 'Yarn Ball',
    },
    'toy mouse' => switch (language) {
      AppLanguage.kk => 'Ойыншық тышқан',
      AppLanguage.ru => 'Игрушечная мышка',
      AppLanguage.en => 'Toy Mouse',
    },
    'bell wand' => switch (language) {
      AppLanguage.kk => 'Қоңыраулы таяқша',
      AppLanguage.ru => 'Колокольчик',
      AppLanguage.en => 'Bell Wand',
    },
    'laser pen' => switch (language) {
      AppLanguage.kk => 'Лазер көрсеткіш',
      AppLanguage.ru => 'Лазерная указка',
      AppLanguage.en => 'Laser Pen',
    },
    _ => raw,
  };

  String feedPetTitle(String food) => switch (language) {
    AppLanguage.kk => '$food берілді!',
    AppLanguage.ru => '$food скормлено!',
    AppLanguage.en => '$food Fed!',
  };

  String feedPetSubtitle(String gain) => switch (language) {
    AppLanguage.kk => '$gain Тоқтық • Мысық өте риза!',
    AppLanguage.ru => '$gain Сытость • Котик доволен!',
    AppLanguage.en => '$gain Hunger • Neko is delighted!',
  };

  String playPetTitle(String toy) => switch (language) {
    AppLanguage.kk => '$toy құралымен ойнады!',
    AppLanguage.ru => 'Поиграли с $toy!',
    AppLanguage.en => 'Played with $toy!',
  };

  String playPetSubtitle(String gain) => switch (language) {
    AppLanguage.kk => '$gain Қуаныш • +10 XP жиналды!',
    AppLanguage.ru => '$gain Радость • +10 XP получено!',
    AppLanguage.en => '$gain Joy • +10 XP gained!',
  };

  // Learn Screen
  String get questBannerTitle => switch (language) {
    AppLanguage.kk => 'ЖАПОН ТІЛІ N5 ТАПСЫРМАСЫ ⛩️',
    AppLanguage.ru => 'ЯПОНСКИЙ N5 КВЕСТ ⛩️',
    AppLanguage.en => 'JAPANESE N5 QUEST ⛩️',
  };

  String get questBannerSubtitle => switch (language) {
    AppLanguage.kk => 'Мысықты өсіру үшін сөздерді үйреніңіз!',
    AppLanguage.ru => 'Учите слова, чтобы прокачивать котика!',
    AppLanguage.en => 'Master vocabulary to level up your Neko!',
  };

  String questDoneCount(int done, int total) => switch (language) {
    AppLanguage.kk => '$done / $total Аяқталды',
    AppLanguage.ru => '$done / $total Пройдено',
    AppLanguage.en => '$done / $total Done',
  };

  String categoryName(String category) => switch (category.toLowerCase()) {
    'greetings' => switch (language) {
      AppLanguage.kk => 'Сәлемдесу',
      AppLanguage.ru => 'Приветствия',
      AppLanguage.en => 'Greetings',
    },
    'food' => switch (language) {
      AppLanguage.kk => 'Тағам',
      AppLanguage.ru => 'Еда',
      AppLanguage.en => 'Food',
    },
    'animals' => switch (language) {
      AppLanguage.kk => 'Жануарлар',
      AppLanguage.ru => 'Животные',
      AppLanguage.en => 'Animals',
    },
    'numbers' => switch (language) {
      AppLanguage.kk => 'Сандар',
      AppLanguage.ru => 'Числа',
      AppLanguage.en => 'Numbers',
    },
    'colors' => switch (language) {
      AppLanguage.kk => 'Түстер',
      AppLanguage.ru => 'Цвета',
      AppLanguage.en => 'Colors',
    },
    'family' => switch (language) {
      AppLanguage.kk => 'Отбасы',
      AppLanguage.ru => 'Семья',
      AppLanguage.en => 'Family',
    },
    'daily life' => switch (language) {
      AppLanguage.kk => 'Күнделікті өмір',
      AppLanguage.ru => 'Повседневная жизнь',
      AppLanguage.en => 'Daily Life',
    },
    _ => category,
  };

  String questCardInfo(int words, int exercises) => switch (language) {
    AppLanguage.kk => '$words сөз • $exercises тапсырма',
    AppLanguage.ru => '$words слов • $exercises упражнений',
    AppLanguage.en => '$words words • $exercises exercises',
  };

  // Lesson Detail Screen
  String get newWord => switch (language) {
    AppLanguage.kk => 'Жаңа сөз',
    AppLanguage.ru => 'Новое слово',
    AppLanguage.en => 'New Word',
  };

  String get next => switch (language) {
    AppLanguage.kk => 'Келесі',
    AppLanguage.ru => 'Далее',
    AppLanguage.en => 'Next',
  };

  String get check => switch (language) {
    AppLanguage.kk => 'Тексеру',
    AppLanguage.ru => 'Проверить',
    AppLanguage.en => 'Check',
  };

  String exerciseProgress(int current, int total) => switch (language) {
    AppLanguage.kk => 'Тапсырма $current / $total',
    AppLanguage.ru => 'Упражнение $current / $total',
    AppLanguage.en => 'Exercise $current / $total',
  };

  String get correctExerciseFeedback => switch (language) {
    AppLanguage.kk => 'Дұрыс! Жарайсың! +10 XP ⭐',
    AppLanguage.ru => 'Правильно! Молодец! +10 XP ⭐',
    AppLanguage.en => 'Correct! Great job! +10 XP ⭐',
  };

  String get wrongExerciseFeedback => switch (language) {
    AppLanguage.kk => 'Қате жауап, қайталап көріңіз',
    AppLanguage.ru => 'Неправильный ответ, попробуйте еще раз',
    AppLanguage.en => 'Wrong answer, try again',
  };

  String get lessonCompletedTitle => switch (language) {
    AppLanguage.kk => 'Сабақ аяқталды! 🎊',
    AppLanguage.ru => 'Урок завершен! 🎊',
    AppLanguage.en => 'Lesson Complete! 🎊',
  };

  String get scoreLabel => switch (language) {
    AppLanguage.kk => 'Нәтиже',
    AppLanguage.ru => 'Результат',
    AppLanguage.en => 'Score',
  };

  String get xpEarnedLabel => switch (language) {
    AppLanguage.kk => 'Жиналған XP',
    AppLanguage.ru => 'Получено XP',
    AppLanguage.en => 'XP Earned',
  };

  String get coinsLabel => switch (language) {
    AppLanguage.kk => 'Тиындар',
    AppLanguage.ru => 'Монеты',
    AppLanguage.en => 'Coins',
  };

  String get foodRewardLabel => switch (language) {
    AppLanguage.kk => 'Тағам сыйлығы',
    AppLanguage.ru => 'Награда едой',
    AppLanguage.en => 'Food',
  };

  String levelUpNotice(int level) => switch (language) {
    AppLanguage.kk => 'ДЕҢГЕЙ КӨТЕРІЛДІ! $level Деңгей ✨',
    AppLanguage.ru => 'НОВЫЙ УРОВЕНЬ! Уровень $level ✨',
    AppLanguage.en => 'LEVEL UP! Level $level ✨',
  };

  String get nekoHappyMessage => switch (language) {
    AppLanguage.kk => '🐱 Мысық өте риза!',
    AppLanguage.ru => '🐱 Котик очень счастлив!',
    AppLanguage.en => '🐱 Neko is happy!',
  };

  String get continueButton => switch (language) {
    AppLanguage.kk => 'Жалғастыру',
    AppLanguage.ru => 'Продолжить',
    AppLanguage.en => 'Continue',
  };
}
