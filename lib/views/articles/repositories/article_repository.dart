import '../models/article_model.dart';
import '../models/article_pagination.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles({int page});

  Future<ArticlePagination> getArticlesWithPagination({int page});
}