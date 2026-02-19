import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:looklabs/Core/Network/api_config.dart';
import 'package:looklabs/Core/Network/api_response.dart';

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

  /// True if host is localhost or private IP (dev only). For these we allow relaxed SSL.
  static bool _isDevHost(String host) {
    if (host.isEmpty) return false;
    if (host == 'localhost' || host == '127.0.0.1') return true;
    final parts = host.split('.');
    if (parts.length == 4) {
      final a = int.tryParse(parts[0]) ?? -1;
      final b = int.tryParse(parts[1]) ?? -1;
      final c = int.tryParse(parts[2]) ?? -1;
      final d = int.tryParse(parts[3]) ?? -1;
      if (a >= 0 && a <= 255 && b >= 0 && b <= 255 && c >= 0 && c <= 255 && d >= 0 && d <= 255) {
        if (a == 10) return true;
        if (a == 172 && b >= 16 && b <= 31) return true;
        if (a == 192 && b == 168) return true;
      }
    }
    return false;
  }

  static http.Client? _httpClient;
  /// Reuse a single client. For dev hosts (localhost/private IP) use relaxed SSL to avoid hostname mismatch.
  static http.Client get _client {
    if (_httpClient != null) return _httpClient!;
    try {
      final uri = Uri.parse(ApiConfig.baseUrl);
      if (uri.host.isNotEmpty && _isDevHost(uri.host)) {
        final io = HttpClient();
        io.badCertificateCallback = (_, __, ___) => true;
        _httpClient = IOClient(io);
      } else {
        _httpClient = http.Client();
      }
    } catch (_) {
      _httpClient = http.Client();
    }
    return _httpClient!;
  }

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
      final response = await _client
          .get(Uri.parse(url), headers: headers ?? _headers)
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
    } on HandshakeException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'SSL error: hostname does not match server certificate. Set BASE_URL in api.env to the exact URL whose certificate matches (e.g. https://api.yourdomain.com/v1). For local dev use https://localhost or https://YOUR_IP.',
      );
    } catch (e) {
      return ApiResponse(success: false, statusCode: 0, message: e.toString());
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
      final response = await _client
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
    } on HandshakeException {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'SSL error: hostname does not match server certificate. Set BASE_URL in api.env to the exact URL whose certificate matches (e.g. https://api.yourdomain.com/v1). For local dev use https://localhost or https://YOUR_IP.',
      );
    } catch (e) {
      return ApiResponse(success: false, statusCode: 0, message: e.toString());
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
      final response = await _client
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
      return ApiResponse(success: false, statusCode: 0, message: e.toString());
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
      final response = await _client
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
      return ApiResponse(success: false, statusCode: 0, message: e.toString());
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
      final response = await _client
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
      return ApiResponse(success: false, statusCode: 0, message: e.toString());
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
        request.files.add(
          await http.MultipartFile.fromPath(
            file.fieldName,
            file.filePath,
            filename: file.fileName,
          ),
        );
      }

      final streamedResponse = await _client.send(request).timeout(
        Duration(seconds: ApiConfig.sendTimeout * 2),
      );

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
      return ApiResponse(success: false, statusCode: 0, message: e.toString());
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
        request.files.add(
          await http.MultipartFile.fromPath(
            file.fieldName,
            file.filePath,
            filename: file.fileName,
          ),
        );
      }

      final streamedResponse = await _client.send(request).timeout(
        Duration(seconds: ApiConfig.sendTimeout * 2),
      );

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
      return ApiResponse(success: false, statusCode: 0, message: e.toString());
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
