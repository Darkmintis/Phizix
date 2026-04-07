import 'package:flutter/material.dart';
import '../models/article_detail_model.dart';
import '../repositories/article_repository.dart';

enum DetailState { idle, loading, success, error }

class ArticleDetailViewModel extends ChangeNotifier {
  final ArticleRepository repository;

  ArticleDetailViewModel(this.repository);

  DetailState _state = DetailState.idle;
  ArticleDetailModel? _article;
  String _error = '';

  DetailState get state => _state;
  ArticleDetailModel? get article => _article;
  String get error => _error;

  Future<void> loadArticle(String slug) async {
    _state = DetailState.loading;
    notifyListeners();

    try {
      _article = await repository.getArticleBySlug(slug);
      _state = DetailState.success;
    } catch (e) {
      _state = DetailState.error;
      _error = _mapError(e);
    }

    notifyListeners();
  }

  String _mapError(Object e) {
    if (e is Exception) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    return 'Something went wrong';
  }
}