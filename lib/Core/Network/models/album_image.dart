/// Album image item from GET images/album.
/// API returns array of: { id, user_id, file_path, s3_key, url, mime_type, file_size, image_type, status, domain, view, analysis_result, error_message, uploaded_at, processed_at, updated_at }.
class AlbumImage {
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
  final String? analysisResult;
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
      analysisResult: json['analysis_result']?.toString(),
      errorMessage: json['error_message']?.toString(),
      uploadedAt: json['uploaded_at']?.toString(),
      processedAt: json['processed_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
