class Task {
  final String id;
  final String nameEs;
  final String nameEn;
  final String tradeId;
  final String descriptionEs;
  final String descriptionEn;

  const Task({
    required this.id,
    required this.nameEs,
    required this.nameEn,
    required this.tradeId,
    required this.descriptionEs,
    required this.descriptionEn,
  });

  String getName(String lang) => lang == 'en' ? nameEn : nameEs;
  String getDescription(String lang) => lang == 'en' ? descriptionEn : descriptionEs;

  // Compatibility getters (defaults to Spanish)
  String get name => nameEs;
  String get description => descriptionEs;
}
