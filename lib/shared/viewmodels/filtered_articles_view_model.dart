import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
import 'package:phizix/features/articles/models/article_model.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';
import '../../core/enums/view_state.dart';

enum FilterType { category, tag }

class FilteredArticlesViewModel extends ChangeNotifier {
  final ArticleRepository _repository;
  final FilterType filterType;
  final String slug;

  FilteredArticlesViewModel(
    this._repository,
    this.filterType,
    this.slug,
  );

  ViewState _state = ViewState.idle;
  List<Article> _articles = [];
  String _errorMessage = '';

  ViewState get state => _state;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;

  Future<void> loadArticles() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _articles = switch (filterType) {
        FilterType.category =>
          await _repository.getArticlesByCategory(slug, page: 1),
        FilterType.tag => await _repository.getArticlesByTag(slug, page: 1),
      };

      _errorMessage = '';
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = mapErrorToMessage(
        e,
        fallback: 'Failed to load articles',
      );
    }

    notifyListeners();
  }
}
