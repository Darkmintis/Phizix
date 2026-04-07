import '../models/article_model.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles({int page});

  Future<Map<String, dynamic>> getArticlesWithPagination({int page});
}