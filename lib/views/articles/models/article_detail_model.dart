import 'tag_model.dart';
import 'author_model.dart';
import 'category_model.dart';


class ArticleDetailModel {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String featureImage;
  final DateTime publishedAt;

  final List<Tag> tags;
  final List<Category> categories;
  final List<Author> authors;

  ArticleDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.featureImage,
    required this.publishedAt,
    required this.tags,
    required this.categories,
    required this.authors,
  });

  factory ArticleDetailModel.fromJson(Map<String, dynamic> json) {
    return ArticleDetailModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      excerpt: json['excerpt'] ?? '',
      featureImage: json['featureImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? DateTime.now().toString()),

      tags: (json['tags'] as List? ?? [])
          .map((e) => Tag.fromJson(e))
          .toList(),

      categories: (json['categories'] as List? ?? [])
          .map((e) => Category.fromJson(e))
          .toList(),

      authors: (json['authors'] as List? ?? [])
          .map((e) => Author.fromJson(e))
          .toList(),
    );
  }
}