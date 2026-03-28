import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FeatureFlagManager {
  static final FeatureFlagManager _instance = FeatureFlagManager._internal();
  factory FeatureFlagManager() => _instance;
  static FeatureFlagManager get instance => _instance;
  FeatureFlagManager._internal();

  Map<String, dynamic> _flags = {};
  String? _anonymousId;
  String? _userId;
  late String _platform;
  late String _environment;
  late String _apiUrl;

  bool _initialized = false;

  /// Initializes the Feature Flag system.
  /// [apiUrl] is the base URL of the caffeine-api.
  /// [environment] is the current build environment ('dev', 'staging', 'prod').
  /// [platform] is the current device platform (e.g. 'ios', 'android', 'tv', 'web').
  /// [userId] is the optional logged-in user identifier.
  Future<void> initialize({
    required String apiUrl,
    required String environment,
    required String platform,
    String? userId,
  }) async {
    _apiUrl = apiUrl;
    _environment = environment;
    _platform = platform;
    _userId = userId;

    if (!_apiUrl.endsWith('/')) {
      _apiUrl = '$_apiUrl/';
    }
    if (_apiUrl.endsWith('/')) {
      // Remove trailing slash to prevent double slashes in fetchFlags
      _apiUrl = _apiUrl.substring(0, _apiUrl.length - 1);
    }

    // 2. Handle Anonymous ID
    final prefs = await SharedPreferences.getInstance();
    _anonymousId = prefs.getString('caffeine_anonymous_id');
    if (_anonymousId == null) {
      _anonymousId = const Uuid().v4();
      await prefs.setString('caffeine_anonymous_id', _anonymousId!);
    }

    // 3. Initial Fetch
    await fetchFlags();
    _initialized = true;
  }

  /// Fetches the latest flags from the API.
  Future<void> fetchFlags() async {
    try {
      final uri = Uri.parse('$_apiUrl/v1/feature-flags').replace(queryParameters: {
        'platform': _platform,
        'env': _environment,
        if (_userId != null) 'userId': _userId,
        if (_anonymousId != null) 'anonymousId': _anonymousId,
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        _flags = jsonDecode(response.body);
      }
    } catch (e) {
      print('FeatureFlagManager: Failed to fetch flags: $e');
    }
  }

  /// Returns true if the flag is enabled.
  bool isEnabled(String key, {bool defaultValue = false}) {
    final value = _flags[key];
    if (value is bool) return value;
    if (value == null) return defaultValue;
    return false;
  }

  /// Returns the value of a multivariate flag.
  T? getValue<T>(String key, {T? defaultValue}) {
    return (_flags[key] as T?) ?? defaultValue;
  }

  bool get isInitialized => _initialized;
  String get environment => _environment;
}
