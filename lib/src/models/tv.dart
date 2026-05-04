import 'credits.dart';

/// Minimal TV show list item from TMDB.
class TvListItem {
  final int id;
  final String? name;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final num? voteAverage;
  final String? firstAirDate;
  final num? popularity;

  TvListItem({
    required this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.firstAirDate,
    this.popularity,
  });

  factory TvListItem.fromJson(Map<String, dynamic> json) {
    return TvListItem(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: json['vote_average'] as num?,
      firstAirDate: json['first_air_date'] as String?,
      popularity: json['popularity'] as num?,
    );
  }
}

/// TMDB paginated TV list response.
class TvListResponse {
  final int page;
  final int totalPages;
  final List<TvListItem> results;

  TvListResponse({
    required this.page,
    required this.totalPages,
    required this.results,
  });

  factory TvListResponse.fromJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'];
    return TvListResponse(
      page: (json['page'] as num?)?.toInt() ?? 1,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      results: resultsRaw is List
          ? (resultsRaw)
              .map((e) => TvListItem.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }
}

/// TV show detail from TMDB (includes number_of_seasons, etc.).
class TvShowDetail {
  final int id;
  final String? name;
  final String? posterPath;
  final String? backdropPath;
  final String? overview;
  final num? voteAverage;
  final String? firstAirDate;
  final num? popularity;
  final int? numberOfSeasons;
  final List<Map<String, dynamic>>? genres;
  final List<TvSeason>? seasons;
  final CreditsResponse? credits;
  final TvListResponse? recommendations;
  final String? tagline;
  final String? status;
  final String? type;

  TvShowDetail({
    required this.id,
    this.name,
    this.posterPath,
    this.backdropPath,
    this.overview,
    this.voteAverage,
    this.firstAirDate,
    this.popularity,
    this.numberOfSeasons,
    this.genres,
    this.seasons,
    this.credits,
    this.recommendations,
    this.tagline,
    this.status,
    this.type,
  });

  factory TvShowDetail.fromJson(Map<String, dynamic> json) {
    final g = json['genres'];
    return TvShowDetail(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      overview: json['overview'] as String?,
      voteAverage: json['vote_average'] as num?,
      firstAirDate: json['first_air_date'] as String?,
      popularity: json['popularity'] as num?,
      numberOfSeasons: (json['number_of_seasons'] as num?)?.toInt(),
      genres: g is List
          ? (g).map((e) => Map<String, dynamic>.from(e as Map)).toList()
          : null,
      seasons: json['seasons'] is List
          ? (json['seasons'] as List).map((e) => TvSeason.fromJson(Map<String, dynamic>.from(e as Map))).toList()
          : null,
      credits: json['credits'] != null
          ? CreditsResponse.fromJson(Map<String, dynamic>.from(json['credits'] as Map))
          : null,
      recommendations: json['recommendations'] != null
          ? TvListResponse.fromJson(Map<String, dynamic>.from(json['recommendations'] as Map))
          : null,
      tagline: json['tagline'] as String?,
      status: json['status'] as String?,
      type: json['type'] as String?,
    );
  }
}

/// Season info from TMDB (season list on show) or season detail.
class TvSeason {
  final int seasonNumber;
  final String? name;
  final int? episodeCount;
  final String? posterPath;
  final String? overview;

  TvSeason({
    required this.seasonNumber,
    this.name,
    this.episodeCount,
    this.posterPath,
    this.overview,
  });

  factory TvSeason.fromJson(Map<String, dynamic> json) {
    return TvSeason(
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      episodeCount: (json['episode_count'] as num?)?.toInt(),
      posterPath: json['poster_path'] as String?,
      overview: json['overview'] as String?,
    );
  }
}

/// Episode item from TMDB season detail.
class TvEpisode {
  final int id;
  final int episodeNumber;
  final int seasonNumber;
  final String? name;
  final String? overview;
  final String? stillPath;
  final String? airDate;
  final num? voteAverage;

  TvEpisode({
    required this.id,
    required this.episodeNumber,
    required this.seasonNumber,
    this.name,
    this.overview,
    this.stillPath,
    this.airDate,
    this.voteAverage,
  });

  factory TvEpisode.fromJson(Map<String, dynamic> json) {
    return TvEpisode(
      id: json['id'] as int? ?? 0,
      episodeNumber: json['episode_number'] as int? ?? 0,
      seasonNumber: json['season_number'] as int? ?? 0,
      name: json['name'] as String?,
      overview: json['overview'] as String?,
      stillPath: json['still_path'] as String?,
      airDate: json['air_date'] as String?,
      voteAverage: json['vote_average'] as num?,
    );
  }
}

/// Season detail response from TMDB (list of episodes).
class TvSeasonDetailResponse {
  final int id;
  final List<TvEpisode> episodes;

  TvSeasonDetailResponse({
    required this.id,
    required this.episodes,
  });

  factory TvSeasonDetailResponse.fromJson(Map<String, dynamic> json) {
    final episodesRaw = json['episodes'];
    return TvSeasonDetailResponse(
      id: json['id'] as int? ?? 0,
      episodes: episodesRaw is List
          ? (episodesRaw)
              .map((e) => TvEpisode.fromJson(
                  Map<String, dynamic>.from(e as Map)))
              .toList()
          : [],
    );
  }
}
