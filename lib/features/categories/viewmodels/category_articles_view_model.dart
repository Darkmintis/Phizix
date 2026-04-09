import 'package:flutter/material.dart';
import 'package:phizix/features/articles/models/article_model.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';

enum CategoryArticlesState { idle, loading, success, error }

class CategoryArticlesViewModel extends ChangeNotifier {
  final ArticleRepository _repository;
  final String categorySlug;

  CategoryArticlesViewModel(this._repository, this.categorySlug);

  CategoryArticlesState _state = CategoryArticlesState.idle;
  List<Article> _articles = [];
  String _errorMessage = '';

  CategoryArticlesState get state => _state;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;

  Future<void> loadArticles() async {
    _state = CategoryArticlesState.loading;
    notifyListeners();

    try {
      _articles = await _repository.getArticlesByCategory(categorySlug, page: 1);
      _state = CategoryArticlesState.success;
      _errorMessage = '';
    } catch (e) {
      _state = CategoryArticlesState.error;
      _errorMessage = 'Failed to load category articles';
    }

    notifyListeners();
  }
}
