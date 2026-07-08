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

  Map<String, dynamic> toJson() => {
        'id': id,
        'youtubeId': youtubeId,
        'title': title,
        'channelName': channelName,
        'taskId': taskId,
        'tradeId': tradeId,
        'durationMinutes': durationMinutes,
        'requiredTools': requiredTools,
      };

  factory TutorialVideo.fromJson(Map<String, dynamic> json) => TutorialVideo(
        id: json['id'] as String,
        youtubeId: json['youtubeId'] as String,
        title: json['title'] as String,
        channelName: json['channelName'] as String,
        taskId: json['taskId'] as String? ?? '',
        tradeId: json['tradeId'] as String? ?? '',
        durationMinutes: json['durationMinutes'] as int? ?? 0,
        requiredTools:
            (json['requiredTools'] as List<dynamic>?)?.cast<String>() ??
                const [],
      );
}
