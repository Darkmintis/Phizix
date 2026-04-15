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

  FilteredArticlesViewModel(this._repository, this.filterType, this.slug);

  ViewState _state = ViewState.idle;
  List<Article> _articles = [];
  String _errorMessage = '';
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  ViewState get state => _state;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadArticles() async {
    _state = ViewState.loading;
    _currentPage = 0;
    _hasMore = true;
    _isLoadingMore = false;
    notifyListeners();

    try {
      final response = switch (filterType) {
        FilterType.category =>
          await _repository.getArticlesByCategoryWithPagination(slug, page: 1),
        FilterType.tag => await _repository.getArticlesByTagWithPagination(
          slug,
          page: 1,
        ),
      };

      _articles = response.articles;
      _currentPage = response.currentPage;
      _hasMore = _currentPage < response.totalPages;
      _errorMessage = '';
      _state = ViewState.success;
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = mapErrorToMessage(e, fallback: 'Failed to load articles');
    }

    notifyListeners();
  }

  Future<void> loadMoreArticles() async {
    if (_state != ViewState.success || !_hasMore || _isLoadingMore) {
      return;
    }

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;

      final response = switch (filterType) {
        FilterType.category =>
          await _repository.getArticlesByCategoryWithPagination(
            slug,
            page: nextPage,
          ),
        FilterType.tag => await _repository.getArticlesByTagWithPagination(
          slug,
          page: nextPage,
        ),
      };

      _articles = [..._articles, ...response.articles];
      _currentPage = response.currentPage;
      _hasMore = _currentPage < response.totalPages;
      _errorMessage = '';
    } catch (e) {
      _errorMessage = mapErrorToMessage(
        e,
        fallback: 'Failed to load more articles',
      );
    }

    _isLoadingMore = false;
    notifyListeners();
  }
}
