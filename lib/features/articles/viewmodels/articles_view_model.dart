import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
import '../repositories/article_repository.dart';
import '../models/article_model.dart';
import '../../../core/enums/view_state.dart';

class ArticlesViewModel extends ChangeNotifier {
  final ArticleRepository _repository;

  ViewState _state = ViewState.idle;
  List<Article> _articles = [];
  String _errorMessage = '';
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  ArticlesViewModel(this._repository);

  // Getters
  ViewState get state => _state;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadArticles() async {
    _state = ViewState.loading;
    _currentPage = 0;
    _hasMore = true;
    _isLoadingMore = false;
    notifyListeners();

    try {
      final response = await _repository.getArticlesWithPagination(page: 1);
      _articles = response.articles;
      _currentPage = response.currentPage;
      _hasMore = _currentPage < response.totalPages;
      _state = ViewState.success;
      _errorMessage = '';
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = mapErrorToMessage(e);
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
      final response = await _repository.getArticlesWithPagination(
        page: nextPage,
      );

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

  Future<void> refreshArticles() => loadArticles();

  Future<void> retry() => loadArticles();
}
