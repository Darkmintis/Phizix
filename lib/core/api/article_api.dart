import 'package:dio/dio.dart';
import 'package:phizix/views/articles/models/article_detail_model.dart';
import 'package:retrofit/retrofit.dart';
import '../../views/articles/models/article_response.dart';

part 'article_api.g.dart';

@RestApi()
abstract class ArticleApi {
  factory ArticleApi(Dio dio, {String baseUrl}) = _ArticleApi;

  @GET('/article')
  Future<ArticleResponse> getArticles(@Query("page") int page);

  @GET('/article/{slug}')
  Future<ArticleDetailModel> getArticleBySlug(@Path("slug") String slug);
}