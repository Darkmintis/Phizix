import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
import '../repositories/article_repository.dart';
import '../models/article_model.dart';

enum ViewState { idle, loading, success, error }

class ArticlesViewModel extends ChangeNotifier {
  final ArticleRepository _repository;
  
  ViewState _state = ViewState.idle;
  List<Article> _articles = [];
  String _errorMessage = '';

  ArticlesViewModel(this._repository);

  // Getters
  ViewState get state => _state;
  List<Article> get articles => _articles;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == ViewState.loading;

  Future<void> loadArticles() async {
    _state = ViewState.loading;
    notifyListeners();
    
    try {
      _articles = await _repository.getArticles(page: 1);
      _state = ViewState.success;
      _errorMessage = '';
    } catch (e) {
      _state = ViewState.error;
      _errorMessage = mapErrorToMessage(e);
    }

    notifyListeners();
  }

  Future<void> refreshArticles() => loadArticles();
  
  Future<void> retry() => loadArticles();
}