import 'package:dio/dio.dart';
import 'package:phizix/features/articles/models/article_detail_model.dart';
import 'package:phizix/features/categories/models/category_model.dart';
import 'package:phizix/features/tags/models/tag_model.dart';
import '../../features/authors/models/author_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/articles/models/article_response.dart';

part 'article_api.g.dart';

@RestApi()
abstract class ArticleApi {
  factory ArticleApi(Dio dio, {String baseUrl}) = _ArticleApi;

  @GET('/article')
  Future<ArticleResponse> getArticles(@Query("page") int page);

  @GET('/article')
  Future<ArticleResponse> getArticlesByCategory(
    @Query("category") String categorySlug,
    @Query("page") int page,
  );

  @GET('/article/{slug}')
  Future<ArticleDetailModel> getArticleBySlug(@Path("slug") String slug);

  @GET('/author')
  Future<List<Author>> getAuthors();

  @GET('/category')
  Future<List<CategoryModel>> getCategories();

  @GET('/tag')
  Future<List<TagModel>> getTags();
}