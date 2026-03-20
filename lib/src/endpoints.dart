/// URL builders for TMDB and caffeine-api. Pass base URLs and API key from app env.
class Endpoints {
  static String _b(String baseUrl) =>
      baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  /// TMDB base is https://api.themoviedb.org/3
  /// [tmdbApiKey] from env / config.
  static String discoverMoviesUrl(
      String tmdbBaseUrl, String tmdbApiKey, int page, String language, {int? withProviders}) {
    String url = '$tmdbBaseUrl/discover/movie?api_key=$tmdbApiKey'
        '&language=$language&sort_by=popularity.desc&include_video=false&page=$page';
    if (withProviders != null) {
      url += '&with_watch_providers=$withProviders&watch_region=US';
    }
    return url;
  }

  static String popularMoviesUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/movie/popular?api_key=$tmdbApiKey&language=$language';
  }

  static String trendingMoviesUrl(String tmdbBaseUrl, String tmdbApiKey,
      bool includeAdult, String language) {
    return '$tmdbBaseUrl/trending/movie/week?api_key=$tmdbApiKey'
        '&include_adult=$includeAdult&language=$language';
  }

  static String topRatedMoviesUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/movie/top_rated?api_key=$tmdbApiKey'
        '&region=US&language=$language';
  }

  static String nowPlayingMoviesUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/movie/now_playing?api_key=$tmdbApiKey&language=$language';
  }

  static String upcomingMoviesUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/movie/upcoming?api_key=$tmdbApiKey&language=$language';
  }

  static String movieDetailsUrl(
      String tmdbBaseUrl, String tmdbApiKey, int movieId, String language) {
    return '$tmdbBaseUrl/movie/$movieId?api_key=$tmdbApiKey&language=$language';
  }

  static String movieGenresUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/genre/movie/list?api_key=$tmdbApiKey&language=$language';
  }

  static String moviesForGenreUrl(String tmdbBaseUrl, String tmdbApiKey,
      int genreId, int page, String language) {
    return '$tmdbBaseUrl/discover/movie?api_key=$tmdbApiKey'
        '&sort_by=popularity.desc&include_video=false&page=$page'
        '&with_genres=$genreId&language=$language';
  }

  static String movieSearchUrl(String tmdbBaseUrl, String tmdbApiKey,
      String query, bool includeAdult, String language) {
    final q = Uri.encodeComponent(query);
    return '$tmdbBaseUrl/search/movie?query=$q&include_adult=$includeAdult'
        '&language=$language&api_key=$tmdbApiKey';
  }

  static String similarMoviesUrl(String tmdbBaseUrl, String tmdbApiKey,
      int movieId, int page, String language) {
    return '$tmdbBaseUrl/movie/$movieId/similar?api_key=$tmdbApiKey'
        '&language=$language&page=$page';
  }

  static String movieRecommendationsUrl(String tmdbBaseUrl, String tmdbApiKey,
      int movieId, int page, String language) {
    return '$tmdbBaseUrl/movie/$movieId/recommendations?api_key=$tmdbApiKey'
        '&language=$language&page=$page';
  }

  static String movieCreditsUrl(
      String tmdbBaseUrl, String tmdbApiKey, int movieId, String language) {
    return '$tmdbBaseUrl/movie/$movieId/credits?api_key=$tmdbApiKey&language=$language';
  }

  // --- TV ---
  static String discoverTvUrl(
      String tmdbBaseUrl, String tmdbApiKey, int page, String language, {int? withProviders}) {
    String url = '$tmdbBaseUrl/discover/tv?api_key=$tmdbApiKey'
        '&language=$language&sort_by=popularity.desc&page=$page';
    if (withProviders != null) {
      url += '&with_watch_providers=$withProviders&watch_region=US';
    }
    return url;
  }

  static String popularTvUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/tv/popular?api_key=$tmdbApiKey&language=$language';
  }

  static String trendingTvUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/trending/tv/week?api_key=$tmdbApiKey&language=$language';
  }

  static String topRatedTvUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/tv/top_rated?api_key=$tmdbApiKey&language=$language';
  }

  static String airingTodayTvUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/tv/airing_today?api_key=$tmdbApiKey&language=$language';
  }

  static String onTheAirTvUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/tv/on_the_air?api_key=$tmdbApiKey&language=$language';
  }

  static String tvDetailsUrl(
      String tmdbBaseUrl, String tmdbApiKey, int tvId, String language) {
    return '$tmdbBaseUrl/tv/$tvId?api_key=$tmdbApiKey&language=$language';
  }

  static String tvGenresUrl(
      String tmdbBaseUrl, String tmdbApiKey, String language) {
    return '$tmdbBaseUrl/genre/tv/list?api_key=$tmdbApiKey&language=$language';
  }

  static String tvShowsForGenreUrl(String tmdbBaseUrl, String tmdbApiKey,
      int genreId, int page, String language) {
    return '$tmdbBaseUrl/discover/tv?api_key=$tmdbApiKey'
        '&language=$language&sort_by=popularity.desc&page=$page'
        '&with_genres=$genreId';
  }

  static String tvSeasonDetailUrl(String tmdbBaseUrl, String tmdbApiKey,
      int tvId, int seasonNumber, String language) {
    return '$tmdbBaseUrl/tv/$tvId/season/$seasonNumber?api_key=$tmdbApiKey'
        '&language=$language';
  }

  static String tvSearchUrl(String tmdbBaseUrl, String tmdbApiKey,
      String query, bool includeAdult, String language) {
    final q = Uri.encodeComponent(query);
    return '$tmdbBaseUrl/search/tv?query=$q&include_adult=$includeAdult'
        '&language=$language&api_key=$tmdbApiKey';
  }

  static String similarTvUrl(String tmdbBaseUrl, String tmdbApiKey, int tvId,
      int page, String language) {
    return '$tmdbBaseUrl/tv/$tvId/similar?api_key=$tmdbApiKey'
        '&language=$language&page=$page';
  }

  static String tvRecommendationsUrl(String tmdbBaseUrl, String tmdbApiKey, int tvId,
      int page, String language) {
    return '$tmdbBaseUrl/tv/$tvId/recommendations?api_key=$tmdbApiKey'
        '&language=$language&page=$page';
  }

  static String tvCreditsUrl(
      String tmdbBaseUrl, String tmdbApiKey, int tvId, String language) {
    return '$tmdbBaseUrl/tv/$tvId/credits?api_key=$tmdbApiKey&language=$language';
  }

  // --- Person ---
  static String personDetailsUrl(
      String tmdbBaseUrl, String tmdbApiKey, int personId, String language) {
    return '$tmdbBaseUrl/person/$personId?api_key=$tmdbApiKey&language=$language';
  }

  static String personCombinedCreditsUrl(
      String tmdbBaseUrl, String tmdbApiKey, int personId, String language) {
    return '$tmdbBaseUrl/person/$personId/combined_credits?api_key=$tmdbApiKey&language=$language';
  }

  // --- Caffeine API (streaming) ---
  /// Config endpoint.
  static String configUrl(String caffeineApiUrl) {
    return '${_b(caffeineApiUrl)}config';
  }

  /// Stream movie. Providers: vixsrc, vidsrc, vidzee.
  static String streamMovieUrl(
      String caffeineApiUrl, String provider, String tmdbId) {
    final base = _b(caffeineApiUrl);
    return '$base$provider/stream-movie?tmdbId=$tmdbId';
  }

  /// Stream TV episode.
  static String streamTvUrl(String caffeineApiUrl, String provider,
      String tmdbId, int season, int episode) {
    final base = _b(caffeineApiUrl);
    return '$base$provider/stream-tv?tmdbId=$tmdbId&season=$season&episode=$episode';
  }

  /// List providers (optional).
  static String providersUrl(String caffeineApiUrl) {
    return '${_b(caffeineApiUrl)}providers';
  }
}
