class TutorialVideo {
  final String id;
  final String youtubeId;
  final String title;
  final String channelName;
  final String taskId;
  final String tradeId;
  final int durationMinutes;
  final List<String> requiredTools;

  const TutorialVideo({
    required this.id,
    required this.youtubeId,
    required this.title,
    required this.channelName,
    required this.taskId,
    required this.tradeId,
    required this.durationMinutes,
    this.requiredTools = const [],
  });

  String get thumbnailUrl =>
      'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
}
