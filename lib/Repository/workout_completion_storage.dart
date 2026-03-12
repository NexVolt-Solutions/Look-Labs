import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const _kPrefix = 'workout_completed_';

/// Persists completed exercise indices per date. No API required.
class WorkoutCompletionStorage {
  WorkoutCompletionStorage._();

  static final WorkoutCompletionStorage _instance = WorkoutCompletionStorage._();
  static WorkoutCompletionStorage get instance => _instance;

  static const FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static String _keyForDate(DateTime date) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$_kPrefix$y-$m-$d';
  }

  /// Load completed exercise indices for a date.
  static Future<Set<int>> loadCompletedForDate(DateTime date) async {
    try {
      final key = _keyForDate(date);
      final jsonStr = await _storage.read(key: key);
      if (jsonStr == null || jsonStr.isEmpty) return {};
      final decoded = jsonDecode(jsonStr);
      if (decoded is List) {
        return decoded
            .map((e) => e is int ? e : int.tryParse(e?.toString() ?? ''))
            .whereType<int>()
            .where((i) => i >= 0)
            .toSet();
      }
      return {};
    } catch (_) {
      return {};
    }
  }

  /// Save completed exercise indices for a date.
  static Future<void> saveCompletedForDate(DateTime date, Set<int> indices) async {
    try {
      final key = _keyForDate(date);
      final list = indices.toList()..sort();
      await _storage.write(key: key, value: jsonEncode(list));
    } catch (_) {}
  }

  /// Load for today (convenience).
  static Future<Set<int>> loadCompletedForToday() =>
      loadCompletedForDate(DateTime.now());

  /// Save for today (convenience).
  static Future<void> saveCompletedForToday(Set<int> indices) =>
      saveCompletedForDate(DateTime.now(), indices);
}
