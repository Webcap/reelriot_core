import 'dart:convert';

import 'package:http/http.dart' as http;

import 'endpoints.dart';

Future<Map<String, dynamic>> fetchConfig(
  String caffeineApiUrl, {
  String? apiKey,
  String platform = 'tv',
  String environment = 'prod',
}) async {
  final baseUrl = caffeineApiUrl.endsWith('/') ? caffeineApiUrl : '$caffeineApiUrl/';
  final url = Uri.parse('${baseUrl}v1/feature-flags?platform=$platform&env=$environment');
  final headers = <String, String>{};
  if (apiKey != null && apiKey.isNotEmpty) {
    headers['Authorization'] = 'Bearer $apiKey';
  }

  final response = await http.get(url, headers: headers).timeout(
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

/// Fetches structured update info from /v1/updates.
Future<AppUpdateInfo?> fetchUpdateInfo({
  required String caffeineApiUrl,
  required String platform,
  String environment = 'prod',
  String buildChannel = 'stable',
  String? betaKey,
  String? clientVersion,
  String? userId,
  String? anonymousId,
  String? apiKey,
}) async {
  try {
    final url = Uri.parse(
      Endpoints.updatesUrl(
        caffeineApiUrl,
        platform,
        environment: environment,
        buildChannel: buildChannel,
        betaKey: betaKey,
        clientVersion: clientVersion,
        userId: userId,
        anonymousId: anonymousId,
      ),
    );

    final headers = <String, String>{};
    if (apiKey != null && apiKey.isNotEmpty) {
      // Use only Authorization: Bearer — x-api-key is redundant and exposes the key twice.
      headers['Authorization'] = 'Bearer $apiKey';
    }
    if (clientVersion != null && clientVersion.isNotEmpty) {
      headers['x-app-version'] = clientVersion;
    }

    final response =
        await http.get(url, headers: headers).timeout(const Duration(seconds: 5));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return AppUpdateInfo.fromMap(data);
    }
  } catch (e) {
    // Silently fail or log, as updates shouldn't block the app usually
  }
  return null;
}

/// Records client update telemetry event to /v1/updates/telemetry.
Future<bool> sendUpdateTelemetry({
  required String caffeineApiUrl,
  required String platform,
  required String clientVersion,
  required String eventType, // 'version_check', 'forced_prompt_shown', 'update_download_clicked'
  String environment = 'production',
  String? deviceId,
  bool isForcedPrompt = false,
  String? apiKey,
}) async {
  try {
    final url = Uri.parse(Endpoints.updateTelemetryUrl(caffeineApiUrl));
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (apiKey != null && apiKey.isNotEmpty) {
      // Use only Authorization: Bearer — x-api-key is redundant.
      headers['Authorization'] = 'Bearer $apiKey';
    }

    final body = jsonEncode({
      'platform': platform,
      'environment': environment,
      'client_version': clientVersion,
      'device_id': deviceId,
      'event_type': eventType,
      'is_forced_prompt': isForcedPrompt,
    });

    final response = await http
        .post(url, headers: headers, body: body)
        .timeout(const Duration(seconds: 5));

    return response.statusCode == 200;
  } catch (_) {
    return false;
  }
}

/// Typed config values relevant for TV app (and main app).
class CaffeineApiConfig {
  final String caffeineApiUrl;
  final String? consumetUrl;
  final String? tmdbProxy;

  /// @Deprecated Use the structured /v1/updates endpoint instead.
  /// These fields are retained for backward compatibility but are no longer
  /// read by the TV app or populated by the API config endpoint.
  @Deprecated('Use structured /v1/updates endpoint via UpdateService.checkForUpdate()')
  final String? latestVersion;
  @Deprecated('Use structured /v1/updates endpoint via UpdateService.checkForUpdate()')
  final bool? forcedUpdate;
  @Deprecated('Use structured /v1/updates endpoint via UpdateService.checkForUpdate()')
  final String? tvLatestVersion;
  @Deprecated('Use structured /v1/updates endpoint via UpdateService.checkForUpdate()')
  final bool? tvForcedUpdate;
  @Deprecated('Use structured /v1/updates endpoint via UpdateService.checkForUpdate()')
  final String? tvUpdateDownloadUrl;
  @Deprecated('Use structured /v1/updates endpoint via UpdateService.checkForUpdate()')
  final String? tvUpdateChangelog;
 
  CaffeineApiConfig({
    required this.caffeineApiUrl,
    this.consumetUrl,
    this.tmdbProxy,
    // ignore: deprecated_member_use_from_same_package
    this.latestVersion,
    // ignore: deprecated_member_use_from_same_package
    this.forcedUpdate,
    // ignore: deprecated_member_use_from_same_package
    this.tvLatestVersion,
    // ignore: deprecated_member_use_from_same_package
    this.tvForcedUpdate,
    // ignore: deprecated_member_use_from_same_package
    this.tvUpdateDownloadUrl,
    // ignore: deprecated_member_use_from_same_package
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

/// Structured update information model.
class AppUpdateInfo {
  final String platform;
  final String environment;
  final String latestVersion;
  final bool isForced;
  final String? downloadUrl;
  final String? storeUrl;
  final String? changelog;
  final String buildChannel;
  final String? releaseTag;
  final String? buildNotes;

  AppUpdateInfo({
    required this.platform,
    required this.environment,
    required this.latestVersion,
    required this.isForced,
    this.downloadUrl,
    this.storeUrl,
    this.changelog,
    this.buildChannel = 'stable',
    this.releaseTag,
    this.buildNotes,
  });

  factory AppUpdateInfo.fromMap(Map<String, dynamic> map) {
    // Support both explicit update_available flag (rollout exclusion responses)
    // and presence of latest_version (standard update response).
    final updateAvailable = map['update_available'];
    if (updateAvailable == false) {
      // Rollout exclusion or explicit no-update signal — return a null sentinel.
      // Callers should treat a null return from fetchUpdateInfo as no update.
      return AppUpdateInfo(
        platform: map['platform']?.toString() ?? '',
        environment: map['environment']?.toString() ?? '',
        latestVersion: '',
        isForced: false,
        buildChannel: map['build_channel']?.toString() ?? 'stable',
      );
    }

    // Phase 2.5: Fall back to download_urls.universal if download_url is absent.
    final rawDownloadUrl = map['download_url']?.toString();
    final downloadUrlsMap = map['download_urls'] as Map?;
    String? fallbackUrl;
    if (downloadUrlsMap != null && downloadUrlsMap.isNotEmpty) {
      fallbackUrl = downloadUrlsMap['universal']?.toString() ??
          downloadUrlsMap.values.first.toString();
    }
    final resolvedDownloadUrl = rawDownloadUrl?.isNotEmpty == true
        ? rawDownloadUrl
        : fallbackUrl;

    return AppUpdateInfo(
      platform: map['platform']?.toString() ?? '',
      environment: map['environment']?.toString() ?? '',
      latestVersion: map['latest_version']?.toString() ?? '',
      isForced: map['is_forced'] == true,
      downloadUrl: resolvedDownloadUrl,
      storeUrl: map['store_url']?.toString(),
      changelog: map['changelog']?.toString(),
      buildChannel: map['build_channel']?.toString() ?? 'stable',
      releaseTag: map['release_tag']?.toString(),
      buildNotes: map['build_notes']?.toString(),
    );
  }
}
