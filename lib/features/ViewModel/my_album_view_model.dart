import 'package:flutter/material.dart';
import 'package:looklabs/Core/Network/api_error_handler.dart';
import 'package:looklabs/Core/Network/models/album_image.dart';
import 'package:looklabs/Repository/image_upload_repository.dart';

class MyAlbumViewModel extends ChangeNotifier {
  List<AlbumImage> _images = [];
  bool _loading = false;
  String? _error;

  List<AlbumImage> get images => _images;
  bool get loading => _loading;
  String? get error => _error;

  /// Load album images from GET images/album.
  /// Optional filters: [domain], [view], [status] (pending|processed|failed).
  Future<void> loadAlbumImages({
    String? domain,
    String? view,
    String? status,
  }) async {
    if (_loading) return;
    _loading = true;
    _error = null;
    notifyListeners();

    final response = await ImageUploadRepository.instance.getAlbumImages(
      domain: domain,
      view: view,
      status: status,
    );

    _loading = false;
    if (response.success && response.data is List) {
      _images = (response.data as List).cast<AlbumImage>();
      _error = null;
    } else {
      _images = [];
      _error = response.userMessageOrFallback('Could not load album');
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
