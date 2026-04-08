import 'author_repository.dart';
import '../../../core/api/article_api.dart';
import '../models/author_model.dart';

class AuthorRepositoryImpl implements AuthorRepository {
  final ArticleApi api;

  AuthorRepositoryImpl(this.api);

  @override
  Future<List<Author>> getAuthors() {
    try {
      return api.getAuthors();
  }catch (e){
    throw 'Error $e ';
  }
}
}