import '../models/author_model.dart';

abstract class AuthorRepository {
  Future<List<Author>> getAuthors();
}