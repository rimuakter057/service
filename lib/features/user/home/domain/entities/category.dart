class Category {
  final String id;
  final String name;
  final String slug;
  final String description;
  final String? icon;
  final String? banner;
  final String color;
  final bool isActive;
  final bool isFeatured;
  final int sortOrder;
  final int serviceCount;

  const Category({
    required this.id,
    required this.name,
    required this.slug,
    this.description = '',
    this.icon,
    this.banner,
    this.color = '',
    this.isActive = true,
    this.isFeatured = false,
    this.sortOrder = 0,
    this.serviceCount = 0,
  });
}
