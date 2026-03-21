import 'dart:convert';

import 'package:http/http.dart' as http;

import 'endpoints.dart';

/// Fetches app config from caffeine-api GET /config.
/// Returns raw map; app can read caffeine_api_url, tmdb_proxy, etc.
Future<Map<String, dynamic>> fetchConfig(String caffeineApiUrl) async {
  final url = Uri.parse(Endpoints.configUrl(caffeineApiUrl));
  final response = await http.get(url).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Config fetch timeout'),
      );
  if (response.statusCode != 200) {
    throw Exception('Config fetch failed: ${response.statusCode}');
  }
  final data = jsonDecode(response.body);
  if (data is! Map<String, dynamic>) {
    return {};
  }
  return data;
}

/// Typed config values relevant for TV app (and main app).
class CaffeineApiConfig {
  final String caffeineApiUrl;
  final String? consumetUrl;
  final String? tmdbProxy;
  final String? latestVersion;
  final bool? forcedUpdate;
  final String? tvLatestVersion;
  final bool? tvForcedUpdate;
  final String? tvUpdateDownloadUrl;
  final String? tvUpdateChangelog;
 
  CaffeineApiConfig({
    required this.caffeineApiUrl,
    this.consumetUrl,
    this.tmdbProxy,
    this.latestVersion,
    this.forcedUpdate,
    this.tvLatestVersion,
    this.tvForcedUpdate,
    this.tvUpdateDownloadUrl,
    this.tvUpdateChangelog,
  });

  /// Build from raw config map (e.g. from fetchConfig).
  factory CaffeineApiConfig.fromMap(Map<String, dynamic> map) {
    String url = (map['caffeine_api_url'] ?? map['flix_api_url'] ?? '')
        .toString()
        .trim();
    if (url.isNotEmpty && !url.endsWith('/')) url = '$url/';
    return CaffeineApiConfig(
      caffeineApiUrl: url,
      consumetUrl: _str(map['consumet_url']),
      tmdbProxy: _str(map['tmdb_proxy']),
      latestVersion: _str(map['latest_version']),
      forcedUpdate: map['forced_update'] == true ||
          map['forced_update'].toString().toLowerCase() == 'true',
      tvLatestVersion: _str(map['tv_latest_version']),
      tvForcedUpdate: map['tv_forced_update'] == true ||
          map['tv_forced_update'].toString().toLowerCase() == 'true',
      tvUpdateDownloadUrl: _str(map['tv_update_download_url']),
      tvUpdateChangelog: _str(map['tv_update_changelog']),
    );
  }

  static String? _str(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }
}
