import 'package:flutter/services.dart';

/// Loads environment variables from api.env via the asset bundle.
/// Works in debug and release on device/simulator (no file system access needed).
/// Fallback: use --dart-define=BASE_URL=... if api.env is missing.
Future<void> loadEnv() async {
  try {
    final String content = await rootBundle.loadString('api.env');
    _parseAndStore(content);
  } catch (_) {
    // api.env missing from assets; use --dart-define=BASE_URL=... when building
  }
}

final Map<String, String> _envMap = {};

void _parseAndStore(String content) {
  for (final line in content.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final idx = trimmed.indexOf('=');
    if (idx > 0) {
      final key = trimmed.substring(0, idx).trim();
      String value = trimmed.substring(idx + 1).trim();
      if (value.startsWith('"') && value.endsWith('"')) {
        value = value.substring(1, value.length - 1);
      } else if (value.startsWith("'") && value.endsWith("'")) {
        value = value.substring(1, value.length - 1);
      }
      _envMap[key] = value;
    }
  }
}

/// Access env vars - use after loadEnv() has been called.
/// Returns null if key is missing (use --dart-define=BASE_URL=... as fallback).
String? env(String key) {
  final value = _envMap[key];
  if (value == null || value.isEmpty) return null;
  return value;
}
