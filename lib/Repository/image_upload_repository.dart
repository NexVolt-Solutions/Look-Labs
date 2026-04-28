import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/album_image.dart';
import 'package:looklabs/Core/Network/models/simple_image_upload.dart';

class ImageUploadRepository {
  ImageUploadRepository._();

  static final ImageUploadRepository _instance = ImageUploadRepository._();
  static ImageUploadRepository get instance => _instance;

  static String _mimeTypeFromPath(String path) {
    final ext = path.toLowerCase().split('.').lastOrNull ?? '';
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return 'image/jpeg';
    }
  }

  static Future<String> _mimeTypeFromFile(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.openRead(0, 16).fold<List<int>>(
        <int>[],
        (acc, chunk) => acc..addAll(chunk),
      );
      if (bytes.length >= 3 &&
          bytes[0] == 0xFF &&
          bytes[1] == 0xD8 &&
          bytes[2] == 0xFF) {
        return 'image/jpeg';
      }
      if (bytes.length >= 8 &&
          bytes[0] == 0x89 &&
          bytes[1] == 0x50 &&
          bytes[2] == 0x4E &&
          bytes[3] == 0x47 &&
          bytes[4] == 0x0D &&
          bytes[5] == 0x0A &&
          bytes[6] == 0x1A &&
          bytes[7] == 0x0A) {
        return 'image/png';
      }
      if (bytes.length >= 12 &&
          bytes[0] == 0x52 &&
          bytes[1] == 0x49 &&
          bytes[2] == 0x46 &&
          bytes[3] == 0x46 &&
          bytes[8] == 0x57 &&
          bytes[9] == 0x45 &&
          bytes[10] == 0x42 &&
          bytes[11] == 0x50) {
        return 'image/webp';
      }
    } catch (_) {}
    return _mimeTypeFromPath(filePath);
  }

  /// Upload a single image file via POST images/upload/simple.
  /// [filePath] – path to the image file on disk.
  /// Returns [SimpleImageUpload] on success, or null with error message.
  Future<ApiResponse> uploadSimpleImage(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'File not found',
      );
    }

    final contentType = await _mimeTypeFromFile(filePath);

    final response = await ApiServices.multipartPost(
      ApiEndpoints.imagesUploadSimple,
      files: [
        MultipartFileItem(
          fieldName: 'file',
          filePath: filePath,
          fileName: filePath.split(Platform.pathSeparator).last,
          contentType: contentType,
        ),
      ],
    );

    if (kDebugMode) {
      debugPrint(
        '[ImageUpload] statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    if (!response.success) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message:
            response.message ??
            (response.statusCode == 401
                ? 'Not authenticated'
                : 'Could not upload image'),
      );
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message: 'Invalid response format',
      );
    }

    final upload = SimpleImageUpload.fromJson(data);
    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: upload,
      message: response.message,
    );
  }

  /// POST images/upload – domain image for AI analysis (skincare, haircare, etc.).
  /// Query requires [domain] + [view] (front|back|right|left), [imageType] default `uploaded`.
  Future<ApiResponse> uploadDomainImage(
    String filePath, {
    required String domain,
    required String view,
    String imageType = 'uploaded',
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return ApiResponse(
        success: false,
        statusCode: 0,
        message: 'File not found',
      );
    }

    final contentType = await _mimeTypeFromFile(filePath);
    final queryParams = <String, String>{
      'domain': domain.trim().toLowerCase(),
      'view': view.trim().toLowerCase(),
      'image_type': imageType,
    };

    final response = await ApiServices.multipartPost(
      ApiEndpoints.imagesUpload,
      files: [
        MultipartFileItem(
          fieldName: 'file',
          filePath: filePath,
          fileName: filePath.split(Platform.pathSeparator).last,
          contentType: contentType,
        ),
      ],
      queryParams: queryParams,
    );

    if (kDebugMode) {
      debugPrint(
        '[ImageUpload] domain=$domain view=$view statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    if (!response.success) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message:
            response.message ??
            (response.statusCode == 401
                ? 'Not authenticated'
                : 'Could not upload image'),
      );
    }

    final data = response.data;
    if (data is! Map<String, dynamic>) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message: 'Invalid response format',
      );
    }

    final upload = SimpleImageUpload.fromJson(data);
    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: upload,
      message: response.message,
    );
  }

    Future<ApiResponse> getAlbumImages({
    String? domain,
    String? view,
    String? status,
  }) async {
    final queryParams = <String, String>{};
    if (domain != null && domain.isNotEmpty) queryParams['domain'] = domain;
    if (view != null && view.isNotEmpty) queryParams['view'] = view;
    if (status != null && status.isNotEmpty) queryParams['status'] = status;

    final response = await ApiServices.get(
      ApiEndpoints.imagesAlbum,
      queryParams: queryParams.isEmpty ? null : queryParams,
    );

    if (kDebugMode) {
      debugPrint(
        '[ImageUpload] getAlbum statusCode=${response.statusCode}, success=${response.success}',
      );
    }

    if (!response.success) {
      return ApiResponse(
        success: false,
        statusCode: response.statusCode,
        data: null,
        message:
            response.message ??
            (response.statusCode == 401
                ? 'Not authenticated'
                : 'Could not load album'),
      );
    }

    final data = response.data;
    if (data is! List) {
      return ApiResponse(
        success: true,
        statusCode: response.statusCode,
        data: const <AlbumImage>[],
        message: response.message,
      );
    }

    final list = List.from(data);
    final images = list
        .map(
          (e) => e is Map
              ? AlbumImage.fromJson(Map<String, dynamic>.from(e))
              : null,
        )
        .whereType<AlbumImage>()
        .toList();

    return ApiResponse(
      success: true,
      statusCode: response.statusCode,
      data: images,
      message: response.message,
    );
  }
}
