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
  Future<Map<String, dynamic>> getArticlesWithPagination({int page = 1}) async {
  final response = await _api.getArticles(page);

  return{
    'articles' : response.results,
    'currentPage': response.pagination['page'] ?? 1,
    'totalPages': response.pagination['total_pages'] ?? 1,
    'totalItems': response.pagination['count'] ?? 0,
  };
}
}