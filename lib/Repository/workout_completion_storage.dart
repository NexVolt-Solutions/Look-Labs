import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists completed exercise indices per date and domain (`workout`, `height`, …).
class WorkoutCompletionStorage {
  WorkoutCompletionStorage._();

  static final WorkoutCompletionStorage _instance = WorkoutCompletionStorage._();
  static WorkoutCompletionStorage get instance => _instance;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static String _slug(String domain) {
    final s = domain.toLowerCase().trim().replaceAll(RegExp(r'[^a-z0-9_]'), '_');
    return s.isEmpty ? 'workout' : s;
  }

  static String _keyForDate(DateTime date, String domain) {
    final y = date.year;
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${_slug(domain)}_completed_$y-$m-$d';
  }

  /// Load completed exercise indices for [date] and [domain].
  static Future<Set<int>> loadCompletedForDate(
    DateTime date, [
    String domain = 'workout',
  ]) async {
    try {
      final key = _keyForDate(date, domain);
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

  /// Save completed exercise indices for [date] and [domain].
  static Future<void> saveCompletedForDate(
    DateTime date,
    Set<int> indices, [
    String domain = 'workout',
  ]) async {
    try {
      final key = _keyForDate(date, domain);
      final list = indices.toList()..sort();
      await _storage.write(key: key, value: jsonEncode(list));
    } catch (_) {}
  }

  static Future<Set<int>> loadCompletedForToday([String domain = 'workout']) =>
      loadCompletedForDate(DateTime.now(), domain);

  static Future<void> saveCompletedForToday(
    Set<int> indices, [
    String domain = 'workout',
  ]) =>
      saveCompletedForDate(DateTime.now(), indices, domain);
}
