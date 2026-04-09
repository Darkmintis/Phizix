import 'package:flutter/material.dart';
import 'package:phizix/core/services/error_message_mapper.dart';
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
      _error = mapErrorToMessage(e, fallback: 'Failed to load tags');
    }

    _isLoading = false;
    notifyListeners();
  }
}