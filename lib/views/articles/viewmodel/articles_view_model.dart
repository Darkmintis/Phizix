import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phizix/core/services/api_exception.dart';
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
      
      if (e is DioException && e.error is ApiException){
        _errorMessage = (e.error as ApiException).message;
      } else {
        _errorMessage = "Something went wrong";
      }
    }
      notifyListeners();
    }

  Future<void> refreshArticles() => loadArticles();
  
  Future<void> retry() => loadArticles();
}