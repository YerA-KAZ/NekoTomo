class Vocabulary {
  final int id;
  final String japanese;
  final String reading;
  final String meaningKk;
  final String meaningRu;
  final String level;
  final String category;
  final String? exampleSentence;

  Vocabulary({
    required this.id,
    required this.japanese,
    required this.reading,
    required this.meaningKk,
    required this.meaningRu,
    required this.level,
    required this.category,
    this.exampleSentence,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'],
      japanese: json['japanese'],
      reading: json['reading'],
      meaningKk: json['meaningKk'] ?? json['meaning_kk'] ?? '',
      meaningRu: json['meaningRu'] ?? json['meaning_ru'] ?? '',
      level: json['level'] ?? 'N5',
      category: json['category'] ?? '',
      exampleSentence: json['exampleSentence'] ?? json['example_sentence'],
    );
  }
}
