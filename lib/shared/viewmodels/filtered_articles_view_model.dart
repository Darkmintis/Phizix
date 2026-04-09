import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
import 'package:phizix/features/articles/models/article_model.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';

enum FilterType { category, tag }

enum FilteredArticlesState { idle, loading, success, error }

class FilteredArticlesViewModel extends ChangeNotifier {
  final ArticleRepository _repository;
  final FilterType filterType;
  final String slug;

  FilteredArticlesViewModel(
    this._repository,
    this.filterType,
    this.slug,
  );

  FilteredArticlesState _state = FilteredArticlesState.idle;
  List<Article> _articles = [];
  String _errorMessage = '';

  FilteredArticlesState get state => _state;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;

  Future<void> loadArticles() async {
    _state = FilteredArticlesState.loading;
    notifyListeners();

    try {
      _articles = switch (filterType) {
        FilterType.category =>
          await _repository.getArticlesByCategory(slug, page: 1),
        FilterType.tag => await _repository.getArticlesByTag(slug, page: 1),
      };

      _errorMessage = '';
      _state = FilteredArticlesState.success;
    } catch (e) {
      _state = FilteredArticlesState.error;
      _errorMessage = mapErrorToMessage(
        e,
        fallback: 'Failed to load articles',
      );
    }

    notifyListeners();
  }
}
