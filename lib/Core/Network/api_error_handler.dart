import 'package:flutter/material.dart';

import 'package:looklabs/Core/Network/api_response.dart';

/// Central API error handling for the app.
/// Use [userMessage] for display text and [showSnackBar] for consistent UI.
class ApiErrorHandler {
  ApiErrorHandler._();

  /// Default fallback when no message can be determined.
  static const String defaultFallback = 'Something went wrong. Please try again.';

  /// Returns a user-friendly message for an [ApiResponse].
  /// Uses [response.message] if set, else maps [response.statusCode], else [fallback].
  static String userMessage(ApiResponse response, {String? fallback}) {
    final msg = response.message?.trim();
    if (msg != null && msg.isNotEmpty) return msg;

    switch (response.statusCode) {
      case 0:
        return _messageForStatusCode0(response.message);
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Please sign in again.';
      case 403:
        return 'You don\'t have permission to do this.';
      case 404:
        return 'The requested item was not found.';
      case 408:
        return 'Request timed out. Please try again.';
      case 422:
        return 'Invalid data. Please check and try again.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 502:
        return 'Server temporarily unavailable. Please try again.';
      case 503:
        return 'Service temporarily unavailable. Please try again.';
      case 504:
        return 'Request timed out. Please try again.';
      default:
        if (response.statusCode >= 500) {
          return 'Something went wrong on our side. Please try again.';
        }
        return fallback ?? defaultFallback;
    }
  }

  static String _messageForStatusCode0(String? existing) {
    if (existing != null && existing.isNotEmpty) {
      if (existing.contains('SocketException') || existing.contains('network')) {
        return 'No internet connection. Please check your network.';
      }
      if (existing.contains('SSL') || existing.contains('certificate')) {
        return existing.length > 120 ? 'Connection security error. Please try again.' : existing;
      }
      if (existing.length > 100) return 'Connection error. Please try again.';
      return existing;
    }
    return 'No internet connection. Please check your network.';
  }

  /// True if the error is likely due to network (no connection, timeout, DNS).
  static bool isNetworkError(ApiResponse response) {
    return response.statusCode == 0 || response.statusCode == 408;
  }

  /// True if the user should re-authenticate (401, 403).
  static bool isAuthError(ApiResponse response) {
    return response.statusCode == 401 || response.statusCode == 403;
  }

  /// True if the server returned 5xx.
  static bool isServerError(ApiResponse response) {
    return response.statusCode >= 500;
  }

  /// True if retrying the request might help (timeout, 502, 503, 504, network).
  static bool isRetryable(ApiResponse response) {
    return response.statusCode == 0 ||
        response.statusCode == 408 ||
        response.statusCode == 502 ||
        response.statusCode == 503 ||
        response.statusCode == 504;
  }

  /// Shows a SnackBar with the API error message. Safe to call when [response] is null (uses [fallback]).
  static void showSnackBar(
    BuildContext context, {
    ApiResponse? response,
    String? fallback,
  }) {
    if (!context.mounted) return;
    final message = response != null
        ? userMessage(response, fallback: fallback)
        : (fallback ?? defaultFallback);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

/// Extension so you can use [ApiResponse.userMessage] and [ApiResponse.userMessageOrFallback].
extension ApiResponseErrorExtension on ApiResponse {
  /// User-friendly message for this response; uses [fallback] when nothing else is available.
  String userMessageOrFallback([String? fallback]) =>
      ApiErrorHandler.userMessage(this, fallback: fallback);

  /// Whether this response indicates success (2xx).
  bool get isSuccess => success;
}
