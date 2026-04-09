import 'package:flutter/material.dart';
import '../models/tag_model.dart';
import '../repositories/tag_repository.dart';

class TagViewModel extends ChangeNotifier {
  final TagRepository _repo;

  TagViewModel(this._repo);

  List<TagModel> _tags = [];
  bool _isLoading = false;
  String _error = '';

  List<TagModel> get tags => _tags;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> loadTags() async {
    _isLoading = true;
    notifyListeners();

    try {
      _tags = await _repo.getTags();
      _error = '';
    } catch (e) {
      _error = "Failed to load tags $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadAuthors() => loadTags();
}