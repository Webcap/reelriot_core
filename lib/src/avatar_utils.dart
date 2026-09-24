import 'dart:convert';
import 'package:http/http.dart' as http;

/// Centralized avatar metadata model across the Reelriot ecosystem.
class AvatarItem {
  final int id;
  final String url;
  final String filename;
  final bool isDefault;

  const AvatarItem({
    required this.id,
    required this.url,
    required this.filename,
    required this.isDefault,
  });

  factory AvatarItem.fromJson(Map<String, dynamic> json) {
    return AvatarItem(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      url: json['url']?.toString() ?? '',
      filename: json['filename']?.toString() ?? '',
      isDefault: json['is_default'] == true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'url': url,
    'filename': filename,
    'is_default': isDefault,
  };
}

/// Centralized avatar resolution and discovery utility.
/// Provides a single source of truth for avatar asset URLs across Web, TV, and Mobile.
class AvatarUtils {
  /// Base URL for canonical hosted profile avatar assets.
  static const String baseUrl = 'https://reelriot.app/assets/images/profiles';

  /// Canonical default avatar placeholder asset URL.
  static const String defaultAvatarUrl = 'https://reelriot.app/assets/images/profiles/0.png';

  /// Resolves an avatar ID, path, or URL to a standardized, fully qualified CDN URL.
  static String getAvatarUrl(dynamic avatar) {
    if (avatar == null) {
      return defaultAvatarUrl;
    }

    final avatarStr = avatar.toString().trim();
    if (avatarStr.isEmpty) {
      return defaultAvatarUrl;
    }

    // Direct HTTP/HTTPS URLs (e.g. Google auth or custom avatars)
    if (avatarStr.startsWith('http://') || avatarStr.startsWith('https://')) {
      return avatarStr;
    }

    // Extract filename if a path was passed
    final cleanName = avatarStr.contains('/') ? avatarStr.split('/').last : avatarStr;
    final hasExtension = cleanName.contains('.');
    final fileName = hasExtension ? cleanName : '$cleanName.png';

    return '$baseUrl/$fileName';
  }

  /// Fetches the live avatar catalog from caffeine-api.
  /// Falls back to standard 0-49 roster if offline or unreachable.
  static Future<List<AvatarItem>> fetchAvatars({
    String apiBaseUrl = 'https://caffeine.synqholdings.com',
    http.Client? client,
  }) async {
    final httpClient = client ?? http.Client();
    try {
      final cleanBase = apiBaseUrl.replaceAll(RegExp(r'/+$'), '');
      final uri = Uri.parse('$cleanBase/v1/avatars');
      final response = await httpClient.get(uri).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic> && data['avatars'] is List) {
          final list = data['avatars'] as List;
          return list.map((item) => AvatarItem.fromJson(item as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {
      // Fallback below
    } finally {
      if (client == null) {
        httpClient.close();
      }
    }

    // Offline fallback: generate default 0-49 roster
    return List.generate(
      50,
      (i) => AvatarItem(
        id: i,
        url: '$baseUrl/$i.png',
        filename: '$i.png',
        isDefault: i == 0,
      ),
    );
  }
}
