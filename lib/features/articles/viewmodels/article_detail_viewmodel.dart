import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
import '../models/article_detail_model.dart';
import '../repositories/article_repository.dart';
import '../../../core/enums/view_state.dart';

class ArticleDetailViewModel extends ChangeNotifier {
  final ArticleRepository repository;

  ArticleDetailViewModel(this.repository);

  ViewState _state = ViewState.idle;
  ArticleDetailModel? _article;
  String _error = '';

  ViewState get state => _state;
  ArticleDetailModel? get article => _article;
  String get error => _error;

  Future<void> loadArticle(String slug) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _article = await repository.getArticleBySlug(slug);
      _state = ViewState.success;
      _error = '';
    } catch (e) {
      _state = ViewState.error;
      _error = mapErrorToMessage(e);
    }

    notifyListeners();
  }
}