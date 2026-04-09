import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
import '../models/author_model.dart';
import '../repositories/author_repository.dart';

class AuthorsViewModel extends ChangeNotifier {
  final AuthorRepository _repo;

  AuthorsViewModel(this._repo);

  List<Author> _authors = [];
  bool _isLoading = false;
  String _error = '';

  List<Author> get authors => _authors;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadAuthors() async {
    _isLoading = true;
    notifyListeners();

    try {
      _authors = await _repo.getAuthors();
      _error = '';
    } catch (e) {
      _error = mapErrorToMessage(e, fallback: 'Failed to load authors');
    }

    _isLoading = false;
    notifyListeners();
  }
}