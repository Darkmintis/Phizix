import 'package:phizix/features/articles/models/article_detail_model.dart';
import '../models/article_model.dart';
import '../models/article_pagination.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles({int page});

  Future<ArticlePagination> getArticlesWithPagination({int page});

  Future<List<Article>> getArticlesByCategory(String categorySlug, {int page});

  Future<ArticlePagination> getArticlesByCategoryWithPagination(
    String categorySlug, {
    int page,
  });

  Future<List<Article>> getArticlesByTag(String tagSlug, {int page});

  Future<ArticlePagination> getArticlesByTagWithPagination(
    String tagSlug, {
    int page,
  });

  Future<ArticleDetailModel> getArticleBySlug(String slug);
}
