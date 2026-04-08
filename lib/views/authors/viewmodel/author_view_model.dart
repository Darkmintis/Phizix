import 'package:flutter/material.dart';
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
      _error = "Failed to load authors $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}