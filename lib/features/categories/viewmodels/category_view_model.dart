import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../repositories/category_repository.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryRepository _repo;

  CategoryViewModel(this._repo);

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String _error = '';

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadAuthors() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _repo.getCategories();
      _error = '';
    } catch (e) {
      _error = "Failed to load categories $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}