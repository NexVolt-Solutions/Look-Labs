/// Response from POST images/upload/simple (requires auth).
/// API returns: { id, user_id, url, mime_type, file_size, image_type, uploaded_at, updated_at }.
class SimpleImageUpload {
  final int id;
  final int? userId;
  final String url;
  final String? mimeType;
  final int? fileSize;
  final String? imageType;
  final String? uploadedAt;
  final String? updatedAt;

  const SimpleImageUpload({
    required this.id,
    this.userId,
    required this.url,
    this.mimeType,
    this.fileSize,
    this.imageType,
    this.uploadedAt,
    this.updatedAt,
  });

  factory SimpleImageUpload.fromJson(Map<String, dynamic> json) {
    return SimpleImageUpload(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int
          ? json['user_id'] as int
          : int.tryParse(json['user_id']?.toString() ?? ''),
      url: json['url']?.toString() ?? '',
      mimeType: json['mime_type']?.toString(),
      fileSize: json['file_size'] is int
          ? json['file_size'] as int
          : int.tryParse(json['file_size']?.toString() ?? ''),
      imageType: json['image_type']?.toString(),
      uploadedAt: json['uploaded_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }
}
