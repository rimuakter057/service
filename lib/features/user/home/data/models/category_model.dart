import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.description,
    super.icon,
    super.banner,
    super.color,
    super.isActive,
    super.isFeatured,
    super.sortOrder,
    super.serviceCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      description: json['description'] as String? ?? '',
      icon: json['icon'] as String?,
      banner: json['banner'] as String?,
      color: json['color'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      isFeatured: json['is_featured'] as bool? ?? false,
      sortOrder: json['sort_order'] as int? ?? 0,
      serviceCount: json['service_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'icon': icon,
      'banner': banner,
      'color': color,
      'is_active': isActive,
      'is_featured': isFeatured,
      'sort_order': sortOrder,
      'service_count': serviceCount,
    };
  }
}
