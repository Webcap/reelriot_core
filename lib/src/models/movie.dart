import 'credits.dart';

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
  final num? popularity;
  final bool isSponsored;

  MovieListItem({
    required this.id,
    this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.mediaType,
    this.releaseDate,
    this.popularity,
    this.isSponsored = false,
  });

  factory MovieListItem.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] ?? json['tmdb_id'] ?? json['tmdbId'];
    final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0;
    return MovieListItem(
      id: id,
      title: (json['title'] ?? json['name']) as String?,
      posterPath: (json['poster_path'] ?? json['posterPath']) as String?,
      backdropPath: (json['backdrop_path'] ?? json['backdropPath']) as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] ?? json['voteAverage']) as num?,
      mediaType: (json['media_type'] ?? json['mediaType']) as String?,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      popularity: json['popularity'] as num?,
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
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
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
  final num? popularity;
  final int? runtime;
  final List<Map<String, dynamic>>? genres;
  final Map<String, dynamic>? belongsToCollection;
  final CreditsResponse? credits;
  final MovieListResponse? recommendations;
  final String? tagline;
  final List<Map<String, dynamic>>? productionCompanies;
  final String? status;
  final String? homepage;

  MovieDetail({
    required this.id,
    this.title,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.mediaType,
    this.releaseDate,
    this.popularity,
    this.runtime,
    this.genres,
    this.belongsToCollection,
    this.credits,
    this.recommendations,
    this.tagline,
    this.productionCompanies,
    this.status,
    this.homepage,
  });

  factory MovieDetail.fromJson(Map<String, dynamic> json) {
    final g = json['genres'];
    return MovieDetail(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: json['vote_average'] as num?,
      mediaType: json['media_type'] as String?,
      releaseDate: json['release_date'] as String?,
      popularity: json['popularity'] as num?,
      runtime: (json['runtime'] as num?)?.toInt(),
      genres: g is List
          ? (g).map((e) => Map<String, dynamic>.from(e as Map)).toList()
          : null,
      belongsToCollection: json['belongs_to_collection'] != null
          ? Map<String, dynamic>.from(json['belongs_to_collection'] as Map)
          : null,
      credits: json['credits'] != null
          ? CreditsResponse.fromJson(Map<String, dynamic>.from(json['credits'] as Map))
          : null,
      recommendations: json['recommendations'] != null
          ? MovieListResponse.fromJson(Map<String, dynamic>.from(json['recommendations'] as Map))
          : null,
      tagline: json['tagline'] as String?,
      productionCompanies: json['production_companies'] is List
          ? (json['production_companies'] as List).map((e) => Map<String, dynamic>.from(e as Map)).toList()
          : null,
      status: json['status'] as String?,
      homepage: json['homepage'] as String?,
    );
  }
}

/// Collection of movies (e.g. Avengers Collection).
class MovieCollection {
  final int id;
  final String? name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<MovieListItem> parts;

  MovieCollection({
    required this.id,
    this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.parts,
  });

  factory MovieCollection.fromJson(Map<String, dynamic> json) {
    final p = json['parts'];
    return MovieCollection(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      parts: p is List
          ? (p)
              .map((e) => MovieListItem.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }
}
