import 'package:phizix/features/articles/models/article_model.dart';

class ArticlePagination {
  final List<Article> articles;
  final int currentPage;
  final int totalPages;
  final int totalItems;

  ArticlePagination({
    required this.articles,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
  });
}