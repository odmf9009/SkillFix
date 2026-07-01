import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../models/trade.dart';
import '../models/task.dart';
import '../models/tutorial_video.dart';
import '../theme/app_theme.dart';
import '../widgets/video_card.dart';
import 'video_player_screen.dart';

class VideoListScreen extends StatelessWidget {
  final Trade trade;
  final Task task;

  const VideoListScreen({
    super.key,
    required this.trade,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final List<TutorialVideo> videos = MockData.videosForTask(task.id);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: trade.color,
        title: Text(task.name),
        leading: const BackButton(color: Colors.white),
      ),
      body: videos.isEmpty
          ? const Center(
              child: Text(
                'No videos yet for this task.',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.only(top: 12, bottom: 24),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return VideoCard(
                  video: video,
                  onTap: () {
                    debugPrint('Opening video: ${video.title} - ${video.youtubeId}');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VideoPlayerScreen(
                          video: video,
                          tradeColor: trade.color,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
