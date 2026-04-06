import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../views/articles/models/article_model.dart';
import '../../views/articles/models/article_response.dart';

part 'article_api.g.dart';

@RestApi()
abstract class ArticleApi {
  factory ArticleApi(Dio dio, {String baseUrl}) = _ArticleApi;

  @GET('/article')
  Future<ArticleResponse> getArticles(@Query("page") int page);

  @GET('/article/{slug}')
  Future<Article> getArticleBySlug(@Path("slug") String slug);
}