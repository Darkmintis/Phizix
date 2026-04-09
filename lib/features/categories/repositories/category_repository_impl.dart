import 'package:phizix/core/api/article_api.dart';
import 'package:phizix/core/services/api_exception.dart';
import 'package:phizix/features/categories/models/category_model.dart';
import 'package:phizix/features/categories/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository{
  final ArticleApi api;

  CategoryRepositoryImpl(this.api);

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      return await api.getCategories();
    } catch (e) {
      throw ApiException(message: 'Failed to fetch categories: $e');
    }
  }
}