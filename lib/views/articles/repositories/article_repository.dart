// lib/core/repositories/article_repository.dart
import '../../../core/services/api_service.dart';
import '../models/article_model.dart';
import '../../../core/constants/api_constants.dart';

class ArticleRepository {
  final ApiService _apiService;

  ArticleRepository(this._apiService);

  Future<List<Article>> getArticles({int page = 1}) async {
    try {
      final response = await _apiService.get(
        ApiConstants.articleEndpoint,
        queryParams: {'page': page},
      );
      
      if (response is Map<String, dynamic> && response.containsKey('results')) {
        final List<dynamic> results = response['results'];
        return results.map((json) => Article.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  Future<Map<String, dynamic>> getArticlesWithPagination({int page = 1}) async{
    try {
      final response = await _apiService.get(
        ApiConstants.articleEndpoint,
        queryParams: {'page': page},
      );

      if (response is Map<String, dynamic>){
        final List<Article> articles = (response['results'] as List)
        .map((json) => Article.fromJson(json))
        .toList();
        final pagination = response['pagination'] as Map<String, dynamic>;

        return{
          'articles': articles,
          'currentPage': pagination['page'],
          'totalPages': pagination['page'],
          'totalItems': pagination['count'],
        };
      }
      return {'articles': <Article>[], 'currentPage': 1, 'totalPages': 1, 'totalItems': 0};
    } catch (e){
      throw Exception('Failed to fetch articles: $e');
    }
  }

  Future<Article> getArticleBySlug(String slug) async{
    try{
      final response = await _apiService.get('/article/$slug');
      return Article.fromJson(response);
    } catch (e){
      throw Exception('Failed to fetch article: $e');
    }
  }
}