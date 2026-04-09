import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
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

  Future<void> loadCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _repo.getCategories();
      _error = '';
    } catch (e) {
      _error = mapErrorToMessage(e, fallback: 'Failed to load categories');
    }

    _isLoading = false;
    notifyListeners();
  }
}