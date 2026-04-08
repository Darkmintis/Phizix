import 'package:phizix/core/api/article_api.dart';
import 'package:phizix/features/tags/models/tag_model.dart';
import 'package:phizix/features/tags/repositories/tag_repository.dart';

class TagRepositoryImpl implements TagRepository{
  final ArticleApi api;

  TagRepositoryImpl(this.api);

  @override
  Future<List<TagModel>> getTags() {
    try{
      return api.getTags();
    } catch (e){
      throw 'Error $e';
    }
  }
}