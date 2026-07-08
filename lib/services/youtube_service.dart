import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/tutorial_video.dart';
import '../data/mock_data.dart';

/// Access to YouTube tutorial videos.
///
/// The mock methods ([searchVideos], [getFavorites]) keep working offline with
/// the bundled data. [searchByQuery] performs a real YouTube Data API v3 search
/// used by the diagnostic result screen to suggest solution videos in the
/// language selected in the app.
///
/// To protect the daily quota (10,000 units/day; 100 units per search) results
/// are cached in two layers:
///   1. an in-memory cache for the current session, and
///   2. a persistent cache in SharedPreferences with a [_cacheTtl] expiry.
/// If the API later fails (no connection / quota), a still-cached result — even
/// if stale — is returned instead of an error.
///
/// The API key is injected at build/run time so it never lives in the repo:
///   flutter run --dart-define=YOUTUBE_API_KEY=YOUR_KEY
class YoutubeService {
  static const _baseUrl = 'https://www.googleapis.com/youtube/v3';
  static const _apiKey = String.fromEnvironment('YOUTUBE_API_KEY');

  // Identity sent so the API key can be locked to this app in Cloud Console
  // ("Application restrictions"). The Android cert SHA-1 (uppercase hex, no
  // colons) is injected per build because it differs debug vs. release:
  //   --dart-define=ANDROID_CERT_SHA1=AB12...CD
  static const _androidPackage = 'com.venturesflstudio.skillfix';
  static const _iosBundleId = 'com.venturesflstudio.skillfix';
  static const _androidCertSha1 = String.fromEnvironment('ANDROID_CERT_SHA1');

  static const _cacheTtl = Duration(days: 7);
  static const _cachePrefix = 'yt_search_';

  /// Session cache shared across service instances.
  static final Map<String, List<TutorialVideo>> _memoryCache = {};

  /// Whether a YouTube Data API key was provided at build time.
  bool get hasApiKey => _apiKey.isNotEmpty;

  Future<List<TutorialVideo>> searchVideos(String taskId) async {
    await Future.delayed(const Duration(milliseconds: 200)); // simulate latency
    return MockData.videosForTask(taskId);
  }

  Future<List<TutorialVideo>> getFavorites(List<String> ids) async {
    return MockData.videosForIds(ids);
  }

  /// Searches YouTube for solution videos matching [query], prioritising
  /// results in [languageCode] ('es' | 'en'). Serves cached results when
  /// available to save quota. Throws [YoutubeApiException] only when there is
  /// no cache to fall back on.
  Future<List<TutorialVideo>> searchByQuery(
    String query, {
    required String languageCode,
    String? regionCode,
    int maxResults = 6,
  }) async {
    final cacheKey = _cacheKey(query, languageCode);

    // 1) In-memory (session) cache — zero cost, instant.
    final inMemory = _memoryCache[cacheKey];
    if (inMemory != null) return inMemory;

    final prefs = await SharedPreferences.getInstance();

    // 2) Fresh persistent cache — avoids an API call across restarts.
    final fresh = _readCache(prefs, cacheKey, allowStale: false);
    if (fresh != null) {
      _memoryCache[cacheKey] = fresh;
      return fresh;
    }

    if (_apiKey.isEmpty) {
      throw const YoutubeApiException(YoutubeApiError.missingApiKey);
    }

    try {
      final videos =
          await _fetchFromApi(query, languageCode, regionCode, maxResults);
      _memoryCache[cacheKey] = videos;
      await _writeCache(prefs, cacheKey, videos);
      return videos;
    } on YoutubeApiException {
      // 3) On failure fall back to stale cache if we ever fetched this before.
      final stale = _readCache(prefs, cacheKey, allowStale: true);
      if (stale != null) {
        _memoryCache[cacheKey] = stale;
        return stale;
      }
      rethrow;
    }
  }

  Future<List<TutorialVideo>> _fetchFromApi(
    String query,
    String languageCode,
    String? regionCode,
    int maxResults,
  ) async {
    final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: {
      'part': 'snippet',
      'type': 'video',
      'q': query,
      'maxResults': '$maxResults',
      'relevanceLanguage': languageCode,
      'videoEmbeddable': 'true',
      'safeSearch': 'moderate',
      'regionCode': ?regionCode,
      'key': _apiKey,
    });

    final http.Response response;
    try {
      response = await http.get(uri, headers: _appRestrictionHeaders());
    } catch (_) {
      throw const YoutubeApiException(YoutubeApiError.network);
    }

    if (response.statusCode != 200) {
      // 403 typically means quota exceeded or the key/referrer is not allowed.
      throw YoutubeApiException(
        response.statusCode == 403
            ? YoutubeApiError.quotaOrKey
            : YoutubeApiError.request,
      );
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>? ?? const [];

    return items
        .map((raw) {
          final item = raw as Map<String, dynamic>;
          final videoId =
              (item['id'] as Map<String, dynamic>?)?['videoId'] as String?;
          if (videoId == null) return null;
          final snippet = item['snippet'] as Map<String, dynamic>? ?? const {};
          return TutorialVideo(
            id: videoId,
            youtubeId: videoId,
            title: _unescapeHtml(snippet['title'] as String? ?? ''),
            channelName:
                _unescapeHtml(snippet['channelTitle'] as String? ?? ''),
            taskId: 'diagnostic',
            tradeId: 'diagnostic',
            durationMinutes: 0, // the search endpoint does not return duration
          );
        })
        .whereType<TutorialVideo>()
        .toList();
  }

  /// Headers that let Google enforce "Application restrictions" on the key, so
  /// it only works from this app. iOS needs just the bundle id; Android needs
  /// the package plus the signing cert SHA-1. Empty on web/other platforms.
  Map<String, String> _appRestrictionHeaders() {
    if (kIsWeb) return const {};
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return {
          'X-Android-Package': _androidPackage,
          if (_androidCertSha1.isNotEmpty) 'X-Android-Cert': _androidCertSha1,
        };
      case TargetPlatform.iOS:
        return {'X-Ios-Bundle-Identifier': _iosBundleId};
      default:
        return const {};
    }
  }

  // --- Cache helpers ---

  String _cacheKey(String query, String lang) =>
      '$_cachePrefix${lang}_${query.trim().toLowerCase()}';

  List<TutorialVideo>? _readCache(
    SharedPreferences prefs,
    String key, {
    required bool allowStale,
  }) {
    final raw = prefs.getString(key);
    if (raw == null) return null;
    try {
      final map = json.decode(raw) as Map<String, dynamic>;
      final ts = map['ts'] as int? ?? 0;
      final age = DateTime.now().millisecondsSinceEpoch - ts;
      if (!allowStale && age > _cacheTtl.inMilliseconds) return null;
      return (map['videos'] as List<dynamic>)
          .map((e) => TutorialVideo.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeCache(
    SharedPreferences prefs,
    String key,
    List<TutorialVideo> videos,
  ) async {
    final payload = json.encode({
      'ts': DateTime.now().millisecondsSinceEpoch,
      'videos': videos.map((v) => v.toJson()).toList(),
    });
    await prefs.setString(key, payload);
  }

  /// YouTube snippets arrive HTML-encoded (e.g. `Fix &amp; repair`).
  static String _unescapeHtml(String input) {
    return input
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&#x27;', "'")
        .replaceAll('&#x2F;', '/')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>');
  }
}

enum YoutubeApiError { missingApiKey, quotaOrKey, network, request }

class YoutubeApiException implements Exception {
  final YoutubeApiError error;
  const YoutubeApiException(this.error);

  @override
  String toString() => 'YoutubeApiException(${error.name})';
}
