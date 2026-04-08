import 'package:phizix/features/categories/models/category_model.dart';

abstract class CategoryRepository {
   Future<List<CategoryModel>> getCategories();
}