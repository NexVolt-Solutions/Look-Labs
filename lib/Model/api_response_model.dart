/// Generic API response wrapper for list/paginated endpoints
class ApiListResponseModel<T> {
  final List<T> data;
  final int? total;
  final int? page;
  final int? limit;
  final bool? hasMore;

  ApiListResponseModel({
    required this.data,
    this.total,
    this.page,
    this.limit,
    this.hasMore,
  });

  factory ApiListResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    final list = json['data'] ?? json['items'] ?? json['results'] ?? [];
    return ApiListResponseModel(
      data: (list as List)
          .map((e) => fromJsonT(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int? ?? json['totalCount'] as int?,
      page: json['page'] as int? ?? json['currentPage'] as int?,
      limit: json['limit'] as int? ?? json['pageSize'] as int?,
      hasMore: json['hasMore'] as bool? ?? json['has_more'] as bool?,
    );
  }

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) {
    return {
      'data': data.map((e) => toJsonT(e)).toList(),
      if (total != null) 'total': total,
      if (page != null) 'page': page,
      if (limit != null) 'limit': limit,
      if (hasMore != null) 'hasMore': hasMore,
    };
  }
}
