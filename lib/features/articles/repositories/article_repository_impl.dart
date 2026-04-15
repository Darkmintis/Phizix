import 'package:phizix/features/articles/models/article_detail_model.dart';
import 'package:phizix/features/articles/models/article_pagination.dart';
import '../../../core/api/article_api.dart';
import '../models/article_model.dart';
import 'article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleApi _api;

  ArticleRepositoryImpl(this._api);

  @override
  Future<List<Article>> getArticles({int page = 1}) async {
    final response = await _api.getArticles(page);
    return response.results;
  }

  @override
  Future<ArticlePagination> getArticlesWithPagination({int page = 1}) async {
    final response = await _api.getArticles(page);
    return _mapPaginationResponse(response.results, response.pagination);
  }

  @override
  Future<List<Article>> getArticlesByCategory(
    String categorySlug, {
    int page = 1,
  }) async {
    final response = await _api.getCategoryBySlug(categorySlug, page);
    return response.articles.results;
  }

  @override
  Future<ArticlePagination> getArticlesByCategoryWithPagination(
    String categorySlug, {
    int page = 1,
  }) async {
    final response = await _api.getCategoryBySlug(categorySlug, page);
    return _mapPaginationResponse(
      response.articles.results,
      response.articles.pagination,
    );
  }

  @override
  Future<List<Article>> getArticlesByTag(String tagSlug, {int page = 1}) async {
    final response = await _api.getTagBySlug(tagSlug, page);
    return response.articles.results;
  }

  @override
  Future<ArticlePagination> getArticlesByTagWithPagination(
    String tagSlug, {
    int page = 1,
  }) async {
    final response = await _api.getTagBySlug(tagSlug, page);
    return _mapPaginationResponse(
      response.articles.results,
      response.articles.pagination,
    );
  }

  ArticlePagination _mapPaginationResponse(
    List<Article> articles,
    Map<String, dynamic> pagination,
  ) {
    final page = pagination['page'] ?? 1;
    final size = pagination['size'] ?? 20;
    final count = pagination['count'] ?? 0;
    final totalPages =
        pagination['total_pages'] ??
        pagination['pages'] ??
        (size > 0 ? ((count + size - 1) ~/ size) : 1);

    return ArticlePagination(
      articles: articles,
      currentPage: page,
      totalPages: totalPages,
      totalItems: count,
    );
  }

  @override
  Future<ArticleDetailModel> getArticleBySlug(String slug) async {
    final response = await _api.getArticleBySlug(slug);
    return response;
  }
}
