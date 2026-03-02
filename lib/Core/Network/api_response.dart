import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Custom API response wrapper
class ApiResponse {
  final bool success;
  final int statusCode;
  final dynamic data;
  final String? message;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.message,
  });

  factory ApiResponse.fromHttpResponse(http.Response response) {
    if (kDebugMode) {
      final body = response.body;
      final truncated = body.length > 2000 ? '${body.substring(0, 2000)}...[${body.length} chars]' : body;
      debugPrint('[API] statusCode=${response.statusCode} body=$truncated');
    }
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    dynamic decoded;
    try {
      decoded = response.body.isEmpty ? null : jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }
    return ApiResponse(
      success: isSuccess,
      statusCode: response.statusCode,
      data: decoded,
      message: decoded is Map ? decoded['message']?.toString() : null,
    );
  }
}
