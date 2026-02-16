class UploadResponseModel {
  final String? url;
  final String? fileUrl;
  final String? id;
  final String? filename;
  final int? size;

  UploadResponseModel({
    this.url,
    this.fileUrl,
    this.id,
    this.filename,
    this.size,
  });

  String? get fileUrlOrUrl => fileUrl ?? url;

  factory UploadResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadResponseModel(
      url: json['url'] as String?,
      fileUrl: json['fileUrl'] as String? ?? json['file_url'] as String?,
      id: json['id'] as String? ?? json['_id'] as String?,
      filename: json['filename'] as String? ?? json['name'] as String?,
      size: json['size'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (url != null) 'url': url,
      if (fileUrl != null) 'fileUrl': fileUrl,
      if (id != null) 'id': id,
      if (filename != null) 'filename': filename,
      if (size != null) 'size': size,
    };
  }
}
