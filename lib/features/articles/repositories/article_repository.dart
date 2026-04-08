import 'package:phizix/features/articles/models/article_detail_model.dart';
import '../models/article_model.dart';
import '../models/article_pagination.dart';

abstract class ArticleRepository {
  Future<List<Article>> getArticles({int page});

  Future<ArticlePagination> getArticlesWithPagination({int page});

  Future<ArticleDetailModel> getArticleBySlug(String slug);
}