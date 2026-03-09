import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:looklabs/Core/Network/api_endpoints.dart';
import 'package:looklabs/Core/Network/api_response.dart';
import 'package:looklabs/Core/Network/api_services.dart';
import 'package:looklabs/Core/Network/models/album_image.dart';
import 'package:looklabs/Core/Network/models/simple_image_upload.dart';

/// Repository for image uploads.
/// POST images/upload/simple – simple image upload (profile, onboarding, progress photos).
/// Requires Bearer token.
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

    final contentType = _mimeTypeFromPath(filePath);

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

  /// GET images/album – fetch user's album images.
  /// Optional [domain], [view], [status] (pending|processed|failed).
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
