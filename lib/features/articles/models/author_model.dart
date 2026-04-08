class Author {
  final String name;
  final String slug;
  final String image;

  Author({
    required this.name,
    required this.slug,
    required this.image,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
    );
  }
}