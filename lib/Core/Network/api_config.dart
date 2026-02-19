import 'package:looklabs/Core/Config/env_loader.dart';

/// API configuration - Base URL and environment settings
/// Set via --dart-define=BASE_URL=... (CI) or api.env (local)
class ApiConfig {
  ApiConfig._();

  /// Base URL for all API requests
  static String get baseUrl {
    const fromDefine = String.fromEnvironment('BASE_URL', defaultValue: '');
    if (fromDefine.isNotEmpty) return fromDefine;
    return env('BASE_URL') ?? '';
  }

  /// API timeout duration in seconds
  static const int connectTimeout = 30;

  /// Receive timeout in seconds
  static const int receiveTimeout = 30;

  /// Send timeout in seconds
  static const int sendTimeout = 30;

  /// Common headers applied to all requests
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get full URL from endpoint path
  static String getFullUrl(String endpoint) {
    final base = baseUrl.endsWith('/') ? baseUrl : baseUrl;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$base$path';
  }
}
