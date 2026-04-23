import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FeatureFlagResult {
  final dynamic value;
  final String? variant;
  final int bucket;
  final bool isEnabled;
  final String reason;

  FeatureFlagResult({
    required this.value,
    this.variant,
    required this.bucket,
    required this.isEnabled,
    required this.reason,
  });

  factory FeatureFlagResult.fromJson(Map<String, dynamic> json) {
    return FeatureFlagResult(
      value: json['value'],
      variant: json['variant'],
      bucket: json['bucket'] ?? -1,
      isEnabled: json['is_enabled'] ?? false,
      reason: json['reason'] ?? 'unknown',
    );
  }
}

class FeatureFlagManager {
  static final FeatureFlagManager _instance = FeatureFlagManager._internal();
  factory FeatureFlagManager() => _instance;
  static FeatureFlagManager get instance => _instance;
  FeatureFlagManager._internal();

  Map<String, dynamic> _flags = {};
  final Set<String> _trackedFlags = {};
  String? _anonymousId;
  String? _userId;
  late String _platform;
  late String _environment;
  late String _apiUrl;
  String? _apiKey;

  void Function(String key, FeatureFlagResult result)? onExposure;

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
    String? apiKey,
    void Function(String key, FeatureFlagResult result)? onExposure,
  }) async {
    _apiUrl = apiUrl;
    _environment = environment;
    _platform = platform;
    _userId = userId;
    _apiKey = apiKey;
    this.onExposure = onExposure;

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
        'detailed': 'true',
        if (_userId != null) 'userId': _userId,
        if (_anonymousId != null) 'anonymousId': _anonymousId,
      });

      final headers = <String, String>{};
      if (_apiKey != null && _apiKey!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $_apiKey';
      }

      final response = await http.get(uri, headers: headers).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        _flags = jsonDecode(response.body);
      }
    } catch (e) {
      print('FeatureFlagManager: Failed to fetch flags: $e');
    }
  }

  /// Returns true if the flag is enabled.
  bool isEnabled(String key, {bool defaultValue = false}) {
    final result = getDetail(key);
    if (result == null) return defaultValue;
    
    final value = result.value;
    if (value is bool) return value;
    return false;
  }

  /// Returns the value of a multivariate flag.
  T? getValue<T>(String key, {T? defaultValue}) {
    final result = getDetail(key);
    if (result == null) return defaultValue;
    return (result.value as T?) ?? defaultValue;
  }

  /// Returns the detailed evaluation result of a flag.
  FeatureFlagResult? getDetail(String key) {
    final raw = _flags[key];
    if (raw == null) return null;

    final result = FeatureFlagResult.fromJson(raw is Map<String, dynamic> ? raw : {'value': raw});

    // Track exposure if not already tracked
    if (!_trackedFlags.contains(key)) {
      onExposure?.call(key, result);
      _trackedFlags.add(key);
    }

    return result;
  }

  bool get isInitialized => _initialized;
  String get environment => _environment;
}

