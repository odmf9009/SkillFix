enum Season { spring, summer, fall, winter }

class SeasonalTask {
  final String id;
  final String titleEs;
  final String titleEn;
  final String categoryEs;
  final String categoryEn;
  final bool isHighPriority;

  const SeasonalTask({
    required this.id,
    required this.titleEs,
    required this.titleEn,
    required this.categoryEs,
    required this.categoryEn,
    this.isHighPriority = false,
  });
}
