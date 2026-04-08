import 'package:phizix/features/tags/models/tag_model.dart';

abstract class TagRepository {
  Future<List<TagModel>> getTags();
}