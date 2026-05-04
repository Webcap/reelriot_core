class CastMember {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  final int order;

  CastMember({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
    required this.order,
  });

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      character: json['character'] as String?,
      profilePath: json['profile_path'] as String?,
      order: json['order'] as int? ?? 0,
    );
  }
}

class CreditsResponse {
  final int id;
  final List<CastMember> cast;

  CreditsResponse({
    required this.id,
    required this.cast,
  });

  factory CreditsResponse.fromJson(Map<String, dynamic> json) {
    final castRaw = json['cast'];
    return CreditsResponse(
      id: json['id'] as int? ?? 0,
      cast: castRaw is List
          ? castRaw
              .map((e) => CastMember.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }
}
