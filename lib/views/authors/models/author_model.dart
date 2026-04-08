class Author {
  final String name;
  final String slug;
  final String description;
  final String image;
  final int articleCount;

  Author({
    required this.name,
    required this.slug,
    required this.description,
    required this.image,
    required this.articleCount,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      articleCount: json['articleCount'] ?? 0,
    );
  }
}