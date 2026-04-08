import 'package:phizix/views/tags/models/tag_model.dart';

abstract class TagRepository {
  Future<List<TagModel>> getTags();
}