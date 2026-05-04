class PersonDetail {
  final int id;
  final String name;
  final String? biography;
  final String? birthday;
  final String? placeOfBirth;
  final String? profilePath;
  final String? knownForDepartment;

  PersonDetail({
    required this.id,
    required this.name,
    this.biography,
    this.birthday,
    this.placeOfBirth,
    this.profilePath,
    this.knownForDepartment,
  });

  factory PersonDetail.fromJson(Map<String, dynamic> json) {
    return PersonDetail(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String,
      biography: json['biography'] as String?,
      birthday: json['birthday'] as String?,
      placeOfBirth: json['place_of_birth'] as String?,
      profilePath: json['profile_path'] as String?,
      knownForDepartment: json['known_for_department'] as String?,
    );
  }
}

class CombinedCreditItem {
  final int id;
  final String? title;
  final String? name; // For TV shows
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final String? mediaType;
  final String? character;
  final String? releaseDate;
  final String? firstAirDate;

  CombinedCreditItem({
    required this.id,
    this.title,
    this.name,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.mediaType,
    this.character,
    this.releaseDate,
    this.firstAirDate,
  });

  factory CombinedCreditItem.fromJson(Map<String, dynamic> json) {
    return CombinedCreditItem(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String?,
      name: json['name'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      mediaType: json['media_type'] as String?,
      character: json['character'] as String?,
      releaseDate: json['release_date'] as String?,
      firstAirDate: json['first_air_date'] as String?,
    );
  }
}

class CombinedCreditsResponse {
  final int id;
  final List<CombinedCreditItem> cast;

  CombinedCreditsResponse({
    required this.id,
    required this.cast,
  });

  factory CombinedCreditsResponse.fromJson(Map<String, dynamic> json) {
    final castRaw = json['cast'];
    return CombinedCreditsResponse(
      id: (json['id'] as num?)?.toInt() ?? 0,
      cast: castRaw is List
          ? castRaw
              .map((e) => CombinedCreditItem.fromJson(Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }
}
