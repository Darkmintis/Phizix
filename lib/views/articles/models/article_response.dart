import 'article_model.dart';

class ArticleResponse {
  final List<Article> results;
  final Map<String, dynamic> pagination;

  ArticleResponse({
    required this.results,
    required this.pagination,
  });

  factory ArticleResponse.fromJson(Map<String, dynamic> json) {
    return ArticleResponse(
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => Article.fromJson(e as Map<String, dynamic>))
          .toList(),

      pagination: json['pagination'] as Map<String, dynamic>? ?? {},
    );
  }
}