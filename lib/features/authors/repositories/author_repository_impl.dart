import 'author_repository.dart';
import '../../../core/api/article_api.dart';
import '../../../core/services/api_exception.dart';
import '../models/author_model.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final ArticleApi api;

  AuthorRepositoryImpl(this.api);

  @override
  Future<List<Author>> getAuthors() async {
    try {
      return await api.getAuthors();
    } catch (e) {
      throw ApiException(message: 'Failed to fetch authors: $e');
    }
  }
}