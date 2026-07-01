import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tutorial_video.dart';
import '../services/favorites_service.dart';
import '../theme/app_theme.dart';

class VideoCard extends StatelessWidget {
  final TutorialVideo video;
  final VoidCallback onTap;

  const VideoCard({super.key, required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: AppTheme.cardShadow,
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    video.thumbnailUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, e, _) => Container(
                      height: 180,
                      color: AppTheme.background,
                      child: const Icon(Icons.videocam_off,
                          size: 48, color: AppTheme.textSecondary),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(178),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${video.durationMinutes} min',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<FavoritesService>(
                    builder: (context, favs, _) {
                      final isFav = favs.isFavorite(video.id);
                      return GestureDetector(
                        onTap: () => favs.toggle(video.id),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(128),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isFav ? Icons.bookmark : Icons.bookmark_border,
                            color: isFav
                                ? AppTheme.accent
                                : Colors.white,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(128),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow,
                          color: Colors.white, size: 32),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.channelName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
