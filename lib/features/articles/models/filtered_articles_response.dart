import 'article_response.dart';

class FilteredArticlesResponse {
  final ArticleResponse articles;

  FilteredArticlesResponse({required this.articles});

  factory FilteredArticlesResponse.fromJson(Map<String, dynamic> json) {
    final articlesJson =
        json['articles'] as Map<String, dynamic>? ??
        <String, dynamic>{
          'results': <dynamic>[],
          'pagination': <String, dynamic>{},
        };

    return FilteredArticlesResponse(
      articles: ArticleResponse.fromJson(articlesJson),
    );
  }
}
