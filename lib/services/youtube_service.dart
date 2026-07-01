import '../models/tutorial_video.dart';
import '../data/mock_data.dart';

// Stub ready for YouTube Data API v3 integration.
// Replace the mock methods with real API calls once an API key is available.
class YoutubeService {
  // Future integration point:
  // static const _baseUrl = 'https://www.googleapis.com/youtube/v3';
  // static const _apiKey = 'YOUR_API_KEY';

  Future<List<TutorialVideo>> searchVideos(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate latency
    return MockData.videosForTask(taskId);
  }

  Future<List<TutorialVideo>> getFavorites(List<String> ids) async {
    return MockData.videosForIds(ids);
  }
}
