const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding NekoTomo database...');

  // ─── Vocabulary ────────────────────────────────────────
  const vocabularyData = [
    // Greetings (1-6)
    { japanese: 'こんにちは', reading: 'konnichiwa', meaningKk: 'Сәлем', meaningRu: 'Здравствуйте', category: 'Greetings', exampleSentence: 'こんにちは、元気ですか？' },
    { japanese: 'おはよう', reading: 'ohayou', meaningKk: 'Қайырлы таң', meaningRu: 'Доброе утро', category: 'Greetings', exampleSentence: 'おはよう、今日もいい天気ですね。' },
    { japanese: 'こんばんは', reading: 'konbanwa', meaningKk: 'Қайырлы кеш', meaningRu: 'Добрый вечер', category: 'Greetings', exampleSentence: 'こんばんは、お元気ですか？' },
    { japanese: 'さようなら', reading: 'sayounara', meaningKk: 'Қош бол', meaningRu: 'До свидания', category: 'Greetings', exampleSentence: 'さようなら、また明日。' },
    { japanese: 'ありがとう', reading: 'arigatou', meaningKk: 'Рахмет', meaningRu: 'Спасибо', category: 'Greetings', exampleSentence: 'ありがとう、とても嬉しいです。' },
    { japanese: 'すみません', reading: 'sumimasen', meaningKk: 'Кешіріңіз', meaningRu: 'Извините', category: 'Greetings', exampleSentence: 'すみません、駅はどこですか？' },

    // Food (7-14)
    { japanese: 'りんご', reading: 'ringo', meaningKk: 'Алма', meaningRu: 'Яблоко', category: 'Food', exampleSentence: 'りんごを食べます。' },
    { japanese: 'みず', reading: 'mizu', meaningKk: 'Су', meaningRu: 'Вода', category: 'Food', exampleSentence: 'みずを飲みます。' },
    { japanese: 'ごはん', reading: 'gohan', meaningKk: 'Тамақ / Күріш', meaningRu: 'Еда / Рис', category: 'Food', exampleSentence: 'ごはんを食べましょう。' },
    { japanese: 'パン', reading: 'pan', meaningKk: 'Нан', meaningRu: 'Хлеб', category: 'Food', exampleSentence: 'パンを買います。' },
    { japanese: 'さかな', reading: 'sakana', meaningKk: 'Балық', meaningRu: 'Рыба', category: 'Food', exampleSentence: 'さかなが好きです。' },
    { japanese: 'にく', reading: 'niku', meaningKk: 'Ет', meaningRu: 'Мясо', category: 'Food', exampleSentence: 'にくを食べます。' },
    { japanese: 'おちゃ', reading: 'ocha', meaningKk: 'Шай', meaningRu: 'Чай', category: 'Food', exampleSentence: 'おちゃを飲みませんか？' },
    { japanese: 'たまご', reading: 'tamago', meaningKk: 'Жұмыртқа', meaningRu: 'Яйцо', category: 'Food', exampleSentence: 'たまごを二つください。' },

    // Animals (15-20)
    { japanese: 'ねこ', reading: 'neko', meaningKk: 'Мысық', meaningRu: 'Кошка', category: 'Animals', exampleSentence: 'ねこがかわいいです。' },
    { japanese: 'いぬ', reading: 'inu', meaningKk: 'Ит', meaningRu: 'Собака', category: 'Animals', exampleSentence: 'いぬが走ります。' },
    { japanese: 'とり', reading: 'tori', meaningKk: 'Құс', meaningRu: 'Птица', category: 'Animals', exampleSentence: 'とりが飛びます。' },
    { japanese: 'さかな', reading: 'sakana', meaningKk: 'Балық', meaningRu: 'Рыба', category: 'Animals', exampleSentence: 'さかなが泳ぎます。' },
    { japanese: 'うま', reading: 'uma', meaningKk: 'Жылқы', meaningRu: 'Лошадь', category: 'Animals', exampleSentence: 'うまに乗ります。' },
    { japanese: 'うさぎ', reading: 'usagi', meaningKk: 'Қоян', meaningRu: 'Кролик', category: 'Animals', exampleSentence: 'うさぎはかわいいです。' },

    // Numbers (21-26)
    { japanese: 'いち', reading: 'ichi', meaningKk: 'Бір', meaningRu: 'Один', category: 'Numbers', exampleSentence: 'いちばん好きです。' },
    { japanese: 'に', reading: 'ni', meaningKk: 'Екі', meaningRu: 'Два', category: 'Numbers', exampleSentence: 'りんごを二つください。' },
    { japanese: 'さん', reading: 'san', meaningKk: 'Үш', meaningRu: 'Три', category: 'Numbers', exampleSentence: '三人の友達がいます。' },
    { japanese: 'よん', reading: 'yon', meaningKk: 'Төрт', meaningRu: 'Четыре', category: 'Numbers', exampleSentence: '四つのりんごがあります。' },
    { japanese: 'ご', reading: 'go', meaningKk: 'Бес', meaningRu: 'Пять', category: 'Numbers', exampleSentence: '五時に会いましょう。' },
    { japanese: 'じゅう', reading: 'juu', meaningKk: 'Он', meaningRu: 'Десять', category: 'Numbers', exampleSentence: '十個あります。' },

    // Colors (27-32)
    { japanese: 'あか', reading: 'aka', meaningKk: 'Қызыл', meaningRu: 'Красный', category: 'Colors', exampleSentence: 'あかいりんごです。' },
    { japanese: 'あお', reading: 'ao', meaningKk: 'Көк', meaningRu: 'Синий', category: 'Colors', exampleSentence: 'あおい空です。' },
    { japanese: 'しろ', reading: 'shiro', meaningKk: 'Ақ', meaningRu: 'Белый', category: 'Colors', exampleSentence: 'しろいねこです。' },
    { japanese: 'くろ', reading: 'kuro', meaningKk: 'Қара', meaningRu: 'Чёрный', category: 'Colors', exampleSentence: 'くろいいぬです。' },
    { japanese: 'きいろ', reading: 'kiiro', meaningKk: 'Сары', meaningRu: 'Жёлтый', category: 'Colors', exampleSentence: 'きいろい花です。' },
    { japanese: 'みどり', reading: 'midori', meaningKk: 'Жасыл', meaningRu: 'Зелёный', category: 'Colors', exampleSentence: 'みどりの木です。' },
  ];

  const createdVocab = [];
  for (const vocab of vocabularyData) {
    const v = await prisma.vocabulary.create({ data: vocab });
    createdVocab.push(v);
  }
  console.log(`  ✅ Created ${createdVocab.length} vocabulary words`);

  // ─── Lessons ───────────────────────────────────────────
  const lessonsData = [
    {
      title: 'Greetings',
      description: 'Learn basic Japanese greetings and polite expressions',
      category: 'Greetings',
      orderIndex: 1,
    },
    {
      title: 'Food',
      description: 'Learn food-related vocabulary for daily life',
      category: 'Food',
      orderIndex: 2,
    },
    {
      title: 'Animals',
      description: 'Learn names of common animals in Japanese',
      category: 'Animals',
      orderIndex: 3,
    },
    {
      title: 'Numbers',
      description: 'Learn basic numbers in Japanese',
      category: 'Numbers',
      orderIndex: 4,
    },
    {
      title: 'Colors',
      description: 'Learn color words in Japanese',
      category: 'Colors',
      orderIndex: 5,
    },
  ];

  const createdLessons = [];
  for (const lesson of lessonsData) {
    const l = await prisma.lesson.create({ data: lesson });
    createdLessons.push(l);
  }
  console.log(`  ✅ Created ${createdLessons.length} lessons`);

  // ─── Link Vocabulary to Lessons ────────────────────────
  const categoryToLesson = {};
  for (const lesson of createdLessons) {
    categoryToLesson[lesson.category] = lesson.id;
  }

  for (let i = 0; i < createdVocab.length; i++) {
    const vocab = createdVocab[i];
    const lessonId = categoryToLesson[vocab.category];
    if (lessonId) {
      await prisma.lessonVocabulary.create({
        data: {
          lessonId,
          vocabularyId: vocab.id,
          orderIndex: i,
        },
      });
    }
  }
  console.log('  ✅ Linked vocabulary to lessons');

  // ─── Exercises ─────────────────────────────────────────
  // Generate exercises for each lesson
  for (const lesson of createdLessons) {
    const vocabForLesson = createdVocab.filter(v => v.category === lesson.category);
    const exercises = [];

    for (let i = 0; i < vocabForLesson.length; i++) {
      const word = vocabForLesson[i];
      
      // Get 3 random wrong answers from other words
      const otherWords = createdVocab.filter(v => v.id !== word.id);
      const shuffled = otherWords.sort(() => Math.random() - 0.5);
      const wrongAnswers = shuffled.slice(0, 3);

      // Exercise 1: Multiple Choice (Japanese → Kazakh)
      const mcOptions = [
        word.meaningKk,
        ...wrongAnswers.map(w => w.meaningKk)
      ].sort(() => Math.random() - 0.5);

      exercises.push({
        lessonId: lesson.id,
        type: 'multiple_choice',
        question: {
          text: `「${word.japanese}」 дегеніміз не?`,
          japanese: word.japanese,
          reading: word.reading,
        },
        options: mcOptions,
        correctAnswer: word.meaningKk,
        xpReward: 10,
        coinReward: 5,
      });

      // Exercise 2: Translation (show meaning, choose Japanese)
      if (i < vocabForLesson.length - 1) {
        const wrongJp = shuffled.slice(0, 3);
        const jpOptions = [
          word.japanese,
          ...wrongJp.map(w => w.japanese)
        ].sort(() => Math.random() - 0.5);

        exercises.push({
          lessonId: lesson.id,
          type: 'translation',
          question: {
            text: `"${word.meaningKk}" сөзінің жапонша аудармасын таңдаңыз`,
            meaning: word.meaningKk,
            meaningRu: word.meaningRu,
          },
          options: jpOptions,
          correctAnswer: word.japanese,
          xpReward: 10,
          coinReward: 5,
        });
      }
    }

    for (const exercise of exercises) {
      await prisma.exercise.create({ data: exercise });
    }
    console.log(`  ✅ Created ${exercises.length} exercises for "${lesson.title}"`);
  }

  console.log('\n🐱 Seeding complete! NekoTomo database is ready.');
}

main()
  .catch((e) => {
    console.error('❌ Seeding error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
