import 'package:phizix/features/articles/models/article_detail_model.dart';
import 'package:phizix/features/articles/models/article_pagination.dart';
import '../../../core/api/article_api.dart';
import '../models/article_model.dart';
import 'article_repository.dart';

class ArticleRepositoryImpl implements ArticleRepository{
  final ArticleApi _api;

  ArticleRepositoryImpl(this._api);

  @override
  Future<List<Article>> getArticles({int page = 1}) async{
    final response = await _api.getArticles(page);
    return response.results;
  }

  @override
  Future<ArticlePagination> getArticlesWithPagination({int page = 1}) async {
  final response = await _api.getArticles(page);

  return ArticlePagination(
    articles : response.results,
    currentPage: response.pagination['page'] ?? 1,
    totalPages: response.pagination['total_pages'] ?? 1,
    totalItems: response.pagination['count'] ?? 0,
  );
  }

  @override  
  Future<ArticleDetailModel> getArticleBySlug(String slug) async{
    final response = await _api.getArticleBySlug(slug);    
    return response;
  }


}