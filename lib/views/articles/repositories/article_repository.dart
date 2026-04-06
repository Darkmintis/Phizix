import '../../../core/api/article_api.dart';
import '../models/article_model.dart';

class ArticleRepository {
  final ArticleApi _api;

  ArticleRepository(this._api);

  Future<List<Article>> getArticles({int page = 1}) async {
      final response = await _api.getArticles(page);
      return response.results;
      }

  Future<Map<String, dynamic>> getArticlesWithPagination({int page = 1}) async{
      final response = await _api.getArticles(page);

   return {
  'articles': response.results,
  'currentPage': response.pagination['page'] ?? 1,
  'totalPages': response.pagination['page'] ?? 1,
  'totalItems': response.pagination['count'] ?? 0,
   };
}
}