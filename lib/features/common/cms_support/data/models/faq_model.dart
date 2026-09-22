class FaqItemModel {
  final String id;
  final String question;
  final String answer;
  final String category;
  final String audience;
  final String audienceLabel;
  final int sortOrder;
  final bool isActive;

  const FaqItemModel({
    required this.id,
    required this.question,
    required this.answer,
    this.category = '',
    this.audience = 'all',
    this.audienceLabel = '',
    this.sortOrder = 0,
    this.isActive = true,
  });

  factory FaqItemModel.fromJson(Map<String, dynamic> json) {
    return FaqItemModel(
      id: (json['id'] as String?) ?? '',
      question: (json['question'] as String?) ?? '',
      answer: (json['answer'] as String?) ?? '',
      category: (json['category'] as String?) ?? '',
      audience: (json['audience'] as String?) ?? 'all',
      audienceLabel: (json['audience_label'] as String?) ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: (json['is_active'] as bool?) ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'audience': audience,
      'audience_label': audienceLabel,
      'sort_order': sortOrder,
      'is_active': isActive,
    };
  }
}

class FaqListResponseModel {
  final bool success;
  final int count;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final String? next;
  final String? previous;
  final List<FaqItemModel> items;

  const FaqListResponseModel({
    this.success = true,
    this.count = 0,
    this.totalPages = 1,
    this.currentPage = 1,
    this.pageSize = 20,
    this.next,
    this.previous,
    required this.items,
  });

  factory FaqListResponseModel.fromJson(Map<String, dynamic> json) {
    final list = (json['data'] as List<dynamic>?) ??
        (json['results'] as List<dynamic>?) ??
        [];

    final items = list
        .whereType<Map<String, dynamic>>()
        .map(FaqItemModel.fromJson)
        .toList();

    return FaqListResponseModel(
      success: (json['success'] as bool?) ?? true,
      count: (json['count'] as num?)?.toInt() ?? items.length,
      totalPages: (json['total_pages'] as num?)?.toInt() ?? 1,
      currentPage: (json['current_page'] as num?)?.toInt() ?? 1,
      pageSize: (json['page_size'] as num?)?.toInt() ?? (items.isEmpty ? 20 : items.length),
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      items: items,
    );
  }
}
