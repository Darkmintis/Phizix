class Category {
  final String name;
  final String slug;

  Category({
    required this.name,
    required this.slug,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }
}