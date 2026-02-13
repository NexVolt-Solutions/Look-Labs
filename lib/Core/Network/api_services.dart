import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'api_config.dart';

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

/// Common API service - use for all HTTP requests across the app
class ApiServices {
  ApiServices._();

  static final ApiServices _instance = ApiServices._();
  static ApiServices get instance => _instance;

  /// Optional: Set auth token to be included in all requests
  static String? _authToken;
  static void setAuthToken(String? token) => _authToken = token;
  static String? get authToken => _authToken;

  /// Optional: Custom headers merged with default headers
  static Map<String, String> _extraHeaders = {};
  static void setExtraHeaders(Map<String, String> headers) =>
      _extraHeaders = headers;
  static void addExtraHeader(String key, String value) =>
      _extraHeaders[key] = value;

  static Map<String, String> get _headers {
    final headers = Map<String, String>.from(ApiConfig.defaultHeaders);
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    headers.addAll(_extraHeaders);
    return headers;
  }

  static String _buildUrl(String endpoint, [Map<String, String>? queryParams]) {
    var url = ApiConfig.getFullUrl(endpoint);
    if (queryParams != null && queryParams.isNotEmpty) {
      final uri = Uri.parse(url).replace(queryParameters: queryParams);
      return uri.toString();
    }
    return url;
  }

  /// GET request
  static Future<ApiResponse> get(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final response = await http
          .get(
            Uri.parse(url),
            headers: headers ?? _headers,
          )
          .timeout(Duration(seconds: ApiConfig.receiveTimeout));
      return ApiResponse.fromHttpResponse(response);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        statusCode: 408,
        message: 'Request timeout',
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'No internet connection',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  /// POST request
  static Future<ApiResponse> post(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final response = await http
          .post(
            Uri.parse(url),
            headers: headers ?? _headers,
            body: body is Map || body is List
                ? jsonEncode(body)
                : body?.toString(),
          )
          .timeout(Duration(seconds: ApiConfig.sendTimeout));
      return ApiResponse.fromHttpResponse(response);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        statusCode: 408,
        message: 'Request timeout',
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'No internet connection',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  /// PUT request
  static Future<ApiResponse> put(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final response = await http
          .put(
            Uri.parse(url),
            headers: headers ?? _headers,
            body: body is Map || body is List
                ? jsonEncode(body)
                : body?.toString(),
          )
          .timeout(Duration(seconds: ApiConfig.sendTimeout));
      return ApiResponse.fromHttpResponse(response);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        statusCode: 408,
        message: 'Request timeout',
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'No internet connection',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  /// PATCH request
  static Future<ApiResponse> patch(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final response = await http
          .patch(
            Uri.parse(url),
            headers: headers ?? _headers,
            body: body is Map || body is List
                ? jsonEncode(body)
                : body?.toString(),
          )
          .timeout(Duration(seconds: ApiConfig.sendTimeout));
      return ApiResponse.fromHttpResponse(response);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        statusCode: 408,
        message: 'Request timeout',
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'No internet connection',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  /// DELETE request
  static Future<ApiResponse> delete(
    String endpoint, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final response = await http
          .delete(
            Uri.parse(url),
            headers: headers ?? _headers,
            body: body is Map || body is List
                ? jsonEncode(body)
                : body?.toString(),
          )
          .timeout(Duration(seconds: ApiConfig.receiveTimeout));
      return ApiResponse.fromHttpResponse(response);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        statusCode: 408,
        message: 'Request timeout',
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'No internet connection',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  /// Multipart POST - for file uploads (images, documents, etc.)
  static Future<ApiResponse> multipartPost(
    String endpoint, {
    required List<MultipartFileItem> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final request = http.MultipartRequest('POST', Uri.parse(url));

      request.headers.addAll(headers ?? _headers);
      request.headers.remove('Content-Type'); // Let multipart set it

      if (fields != null) {
        request.fields.addAll(fields);
      }

      for (final file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          file.fieldName,
          file.filePath,
          filename: file.fileName,
        ));
      }

      final streamedResponse = await request
          .send()
          .timeout(Duration(seconds: ApiConfig.sendTimeout * 2));

      final response = await http.Response.fromStream(streamedResponse);
      return ApiResponse.fromHttpResponse(response);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        statusCode: 408,
        message: 'Request timeout',
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'No internet connection',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }

  /// Multipart PUT - for file uploads with PUT method
  static Future<ApiResponse> multipartPut(
    String endpoint, {
    required List<MultipartFileItem> files,
    Map<String, String>? fields,
    Map<String, String>? headers,
    Map<String, String>? queryParams,
  }) async {
    try {
      final url = _buildUrl(endpoint, queryParams);
      final request = http.MultipartRequest('PUT', Uri.parse(url));

      request.headers.addAll(headers ?? _headers);
      request.headers.remove('Content-Type');

      if (fields != null) {
        request.fields.addAll(fields);
      }

      for (final file in files) {
        request.files.add(await http.MultipartFile.fromPath(
          file.fieldName,
          file.filePath,
          filename: file.fileName,
        ));
      }

      final streamedResponse = await request
          .send()
          .timeout(Duration(seconds: ApiConfig.sendTimeout * 2));

      final response = await http.Response.fromStream(streamedResponse);
      return ApiResponse.fromHttpResponse(response);
    } on TimeoutException {
      return ApiResponse(
        success: false,
        statusCode: 408,
        message: 'Request timeout',
      );
    } on SocketException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'No internet connection',
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: e.toString(),
      );
    }
  }
}

/// Helper for multipart file uploads
class MultipartFileItem {
  final String fieldName;
  final String filePath;
  final String? fileName;

  MultipartFileItem({
    required this.fieldName,
    required this.filePath,
    this.fileName,
  });
}
