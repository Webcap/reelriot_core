/// Subtitle from caffeine-api stream response.
class SubtitleLink {
  final String? file;
  final String? label;
  final String? kind;
  final bool? isDefault;

  SubtitleLink({
    this.file,
    this.label,
    this.kind,
    this.isDefault,
  });

  factory SubtitleLink.fromJson(Map<String, dynamic> json) {
    return SubtitleLink(
      file: json['file'] as String?,
      label: json['label'] as String?,
      kind: json['kind'] as String?,
      isDefault: json['default'] as bool?,
    );
  }
}

/// Stream link from caffeine-api provider response (FlixQuest-style).
class ProviderStreamLink {
  final String server;
  final String url;
  final bool isM3U8;
  final String quality;
  final Map<String, String>? headers;
  final List<SubtitleLink> subtitles;

  ProviderStreamLink({
    required this.server,
    required this.url,
    required this.isM3U8,
    required this.quality,
    this.headers,
    List<SubtitleLink>? subtitles,
  }) : subtitles = subtitles ?? [];

  factory ProviderStreamLink.fromJson(Map<String, dynamic> json) {
    final subs = json['subtitles'];
    return ProviderStreamLink(
      server: json['server'] as String? ?? '',
      url: json['url'] as String? ?? '',
      isM3U8: json['isM3U8'] as bool? ?? false,
      quality: json['quality'] as String? ?? 'unknown',
      headers: json['headers'] != null 
          ? Map<String, String>.from(json['headers'] as Map) 
          : null,
      subtitles: subs is List
          ? (subs)
              .map((e) => SubtitleLink.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : null,
    );
  }
}

/// Full provider stream response (stream-movie / stream-tv).
class ProviderStreamResponse {
  final bool success;
  final String? provider;
  final String? error;
  final List<ProviderStreamLink>? links;

  ProviderStreamResponse({
    required this.success,
    this.provider,
    this.error,
    this.links,
  });

  factory ProviderStreamResponse.fromJson(Map<String, dynamic> json) {
    final linksRaw = json['links'];
    return ProviderStreamResponse(
      success: json['success'] as bool? ?? false,
      provider: json['provider'] as String?,
      error: json['error'] as String?,
      links: linksRaw is List
          ? (linksRaw)
              .map((e) => ProviderStreamLink.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : null,
    );
  }
}
