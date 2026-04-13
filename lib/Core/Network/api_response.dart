import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void _debugLogApiResponse({
  required String url,
  required int statusCode,
  required String body,
}) {
  const chunkSize = 900;
  final prefix = '[API]   url:$url statusCode=$statusCode';
  if (body.isEmpty) {
    debugPrint('$prefix body=<empty>');
    return;
  }
  if (body.length <= chunkSize) {
    debugPrint('$prefix body=$body');
    return;
  }
  final chunks = (body.length / chunkSize).ceil();
  debugPrint('$prefix body_bytes=${body.length} body_chunks=$chunks');
  for (var i = 0, n = 1; i < body.length; i += chunkSize, n++) {
    final end = i + chunkSize > body.length ? body.length : i + chunkSize;
    debugPrint('[API]   body_chunk $n/$chunks: ${body.substring(i, end)}');
  }
}

/// Custom API response wrapper
class ApiResponse {
  final bool success;
  final int statusCode;
  final dynamic data;
  final String? message;

  /// From `Retry-After` header when present (seconds); mainly for 429 handling.
  final int? retryAfterSeconds;

  ApiResponse({
    required this.success,
    required this.statusCode,
    this.data,
    this.message,
    this.retryAfterSeconds,
  });

  factory ApiResponse.fromHttpResponse(http.Response response) {
    if (kDebugMode) {
      _debugLogApiResponse(
        url: '${response.request?.url}',
        statusCode: response.statusCode,
        body: response.body,
      );
    }
    final isSuccess = response.statusCode >= 200 && response.statusCode < 300;
    dynamic decoded;
    try {
      decoded = response.body.isEmpty ? null : jsonDecode(response.body);
    } catch (_) {
      decoded = response.body;
    }
    String? message = decoded is Map
        ? (decoded['detail'] ?? decoded['message'])?.toString()
        : null;
    int? retryAfterSeconds;
    final retryRaw = response.headers['retry-after']?.trim();
    if (retryRaw != null && retryRaw.isNotEmpty) {
      retryAfterSeconds = int.tryParse(retryRaw);
    }

    if (message == null || message.isEmpty) {
      switch (response.statusCode) {
        case 400:
          message = 'Invalid request. Please check your input.';
          break;
        case 401:
          message = 'Please sign in again.';
          break;
        case 403:
          message = 'You don\'t have permission to do this.';
          break;
        case 404:
          message = 'The requested item was not found.';
          break;
        case 408:
          message = 'Request timed out. Please try again.';
          break;
        case 422:
          message = 'Invalid data. Please check and try again.';
          break;
        case 429:
          message = 'Too many requests. Please try again later.';
          break;
        case 502:
          message = 'Server temporarily unavailable. Please try again.';
          break;
        case 503:
          message = 'Service temporarily unavailable. Please try again.';
          break;
        case 504:
          message = 'Request timed out. Please try again.';
          break;
        default:
          if (response.statusCode >= 500) {
            message = 'Something went wrong on our side. Please try again.';
          }
      }
    }
    return ApiResponse(
      success: isSuccess,
      statusCode: response.statusCode,
      data: decoded,
      message: message,
      retryAfterSeconds: retryAfterSeconds,
    );
  }
}
