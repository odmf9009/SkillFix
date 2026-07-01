import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tutorial_video.dart';
import '../theme/app_theme.dart';

class VideoPlayerScreen extends StatefulWidget {
  final TutorialVideo video;
  final Color tradeColor;

  const VideoPlayerScreen({
    super.key,
    required this.video,
    required this.tradeColor,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: false,
        mute: false,
      ),
    );
    
    _controller.loadVideoById(videoId: widget.video.youtubeId);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  Future<void> _handlePlay() async {
    debugPrint('Play pressed: ${widget.video.youtubeId}');
    try {
      final state = await _controller.playerState;
      if (state != PlayerState.playing && state != PlayerState.buffering) {
        debugPrint('State was $state, re-loading video');
        await _controller.loadVideoById(videoId: widget.video.youtubeId);
      } else {
        await _controller.playVideo();
      }
    } catch (e) {
      debugPrint('Error playing video: $e');
    }
  }

  Future<void> _openInYouTube() async {
    final url = Uri.parse('https://www.youtube.com/watch?v=${widget.video.youtubeId}');
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch YouTube: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open YouTube App')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerControllerProvider(
      controller: _controller,
      child: Scaffold(
        backgroundColor: AppTheme.background,
        appBar: AppBar(
          backgroundColor: widget.tradeColor,
          leading: const BackButton(color: Colors.white),
          title: Text(
            widget.video.title,
            style: const TextStyle(fontSize: 16),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: YoutubePlayer(
                controller: _controller,
              ),
            ),
            YoutubeValueBuilder(
              builder: (context, value) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  color: Colors.black12,
                  child: Text(
                    'Player State: ${value.playerState.name}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.video.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _handlePlay,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('REPRODUCIR VIDEO'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _openInYouTube,
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Ver en App de YouTube'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          foregroundColor: widget.tradeColor,
                          side: BorderSide(color: widget.tradeColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // --- NUEVA SECCIÓN: Tools Needed ---
                    const Text(
                      'Tools Needed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: AppTheme.cardShadow,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: widget.video.requiredTools.isEmpty
                          ? const Text(
                              'No tools listed yet.',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                          : Column(
                              children: widget.video.requiredTools.map((tool) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.build_circle_outlined,
                                        size: 20,
                                        color: widget.tradeColor,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          tool,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            color: AppTheme.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
