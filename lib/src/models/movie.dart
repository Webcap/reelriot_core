/// Minimal movie list item from TMDB (discover, popular, etc.).
class MovieListItem {
  final int id;
  final String? title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final num? voteAverage;
  final String? mediaType;
  final String? releaseDate;

  MovieListItem({
    required this.id,
    this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.mediaType,
    this.releaseDate,
  });

  factory MovieListItem.fromJson(Map<String, dynamic> json) {
    return MovieListItem(
      id: json['id'] as int,
      title: json['title'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: json['vote_average'] as num?,
      mediaType: json['media_type'] as String?,
      releaseDate: json['release_date'] as String?,
    );
  }
}

/// TMDB paginated movie list response.
class MovieListResponse {
  final int page;
  final int totalPages;
  final List<MovieListItem> results;

  MovieListResponse({
    required this.page,
    required this.totalPages,
    required this.results,
  });

  factory MovieListResponse.fromJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'];
    return MovieListResponse(
      page: json['page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      results: resultsRaw is List
          ? (resultsRaw)
              .map((e) => MovieListItem.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }
}

/// Movie detail from TMDB (single movie).
class MovieDetail {
  final int id;
  final String? title;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final num? voteAverage;
  final String? mediaType;
  final String? releaseDate;
  final int? runtime;
  final List<Map<String, dynamic>>? genres;

  MovieDetail({
    required this.id,
    this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.mediaType,
    this.releaseDate,
    this.runtime,
    this.genres,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    final g = json['genres'];
    return MovieDetail(
      id: json['id'] as int,
      title: json['title'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: json['vote_average'] as num?,
      mediaType: json['media_type'] as String?,
      releaseDate: json['release_date'] as String?,
      runtime: json['runtime'] as int?,
      genres: g is List
          ? (g).map((e) => Map<String, dynamic>.from(e as Map)).toList()
          : null,
    );
  }
}
