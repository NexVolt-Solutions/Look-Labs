import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Loads environment variables from api.env
/// Call before runApp() in main.dart
Future<void> loadEnv() async {
  await dotenv.load(fileName: 'api.env');
}

/// Access env vars - use after loadEnv() has been called
String env(String key) {
  final value = dotenv.env[key];
  if (value == null || value.isEmpty) {
    throw StateError('Missing required env: $key');
  }
  return value;
}
