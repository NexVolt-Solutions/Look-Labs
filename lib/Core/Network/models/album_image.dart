class AlbumImage {
  static bool isTerminalProcessedStatus(String? status) {
    final s = (status ?? '').toLowerCase();
    return s == 'processed' ||
        s == 'completed' ||
        s == 'complete' ||
        s == 'done';
  }

  /// Image analysis not finished yet (API may use `processing` immediately after upload).
  static bool isAnalysisPipelineStatus(String? status) {
    final s = (status ?? '').toLowerCase();
    return s == 'pending' ||
        s == 'processing' ||
        s == 'in_progress' ||
        s == 'queued';
  }

  static bool isFailureStatus(String? status) {
    final s = (status ?? '').toLowerCase();
    return s == 'failed' || s == 'error';
  }

  /// True when any [standardSlotViewKeys] view’s newest row is in [isAnalysisPipelineStatus].
  static bool anyStandardSlotInAnalysisPipeline(List<AlbumImage> images) {
    for (final v in standardSlotViewKeys) {
      final latest = pickNewestByIdForView(images, v);
      if (latest != null && isAnalysisPipelineStatus(latest.status)) {
        return true;
      }
    }
    return false;
  }

  static List<AlbumImage> _imagesForView(
    List<AlbumImage> images,
    String viewKey,
  ) {
    final lower = viewKey.toLowerCase();
    return images.where((e) => (e.view ?? '').toLowerCase() == lower).toList();
  }

  /// Newest row for this view by id (matches API “current upload” ordering).
  static AlbumImage? pickNewestByIdForView(
    List<AlbumImage> images,
    String viewKey,
  ) {
    final matches = _imagesForView(images, viewKey);
    if (matches.isEmpty) return null;
    matches.sort((a, b) => b.id.compareTo(a.id));
    return matches.first;
  }

  /// Newest terminal-processed row for this view (stable preview while a newer row is processing).
  static AlbumImage? pickNewestProcessedForView(
    List<AlbumImage> images,
    String viewKey,
  ) {
    final processed = _imagesForView(
      images,
      viewKey,
    ).where((e) => isTerminalProcessedStatus(e.status)).toList();
    if (processed.isEmpty) return null;
    processed.sort((a, b) => b.id.compareTo(a.id));
    return processed.first;
  }

  /// Standard capture slots (front / back / right / left) used by scan + album UIs.
  static const List<String> standardSlotViewKeys = [
    'front',
    'back',
    'right',
    'left',
  ];

  /// True when each [standardSlotViewKeys] view has a display row with a non-empty [url].
  static bool hasAllSlotImages(List<AlbumImage> images) {
    for (final v in standardSlotViewKeys) {
      final img = pickDisplayImageForView(images, v);
      if (img == null || img.url.trim().isEmpty) return false;
    }
    return true;
  }

  /// Prefer the latest upload when it is already processed; otherwise fall back to the last good processed image.
  static AlbumImage? pickDisplayImageForView(
    List<AlbumImage> images,
    String viewKey,
  ) {
    final latest = pickNewestByIdForView(images, viewKey);
    if (latest == null) return null;
    if (isTerminalProcessedStatus(latest.status)) return latest;
    return pickNewestProcessedForView(images, viewKey) ?? latest;
  }

  final int id;
  final int? userId;
  final String? filePath;
  final String? s3Key;
  final String url;
  final String? mimeType;
  final int? fileSize;
  final String? imageType;
  final String? status;
  final String? domain;
  final String? view;

  final dynamic analysisResult;
  final String? errorMessage;
  final String? uploadedAt;
  final String? processedAt;
  final String? updatedAt;

  const AlbumImage({
    required this.id,
    this.userId,
    this.filePath,
    this.s3Key,
    required this.url,
    this.mimeType,
    this.fileSize,
    this.imageType,
    this.status,
    this.domain,
    this.view,
    this.analysisResult,
    this.errorMessage,
    this.uploadedAt,
    this.processedAt,
    this.updatedAt,
  });

  factory AlbumImage.fromJson(Map<String, dynamic> json) {
    return AlbumImage(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? ''),
      filePath: json['file_path']?.toString(),
      s3Key: json['s3_key']?.toString(),
      url: json['url']?.toString() ?? '',
      mimeType: json['mime_type']?.toString(),
      fileSize: json['file_size'] is int
          ? json['file_size'] as int
          : int.tryParse(json['file_size']?.toString() ?? ''),
      imageType: json['image_type']?.toString(),
      status: json['status']?.toString(),
      domain: json['domain']?.toString(),
      view: json['view']?.toString(),
      analysisResult: json['analysis_result'],
      errorMessage: json['error_message']?.toString(),
      uploadedAt: json['uploaded_at']?.toString(),
      processedAt: json['processed_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
