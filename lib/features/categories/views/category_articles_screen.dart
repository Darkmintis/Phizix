import 'package:flutter/material.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';
import 'package:phizix/features/articles/widgets/article_card.dart';
import 'package:phizix/features/categories/viewmodels/category_articles_view_model.dart';
import 'package:provider/provider.dart';

class CategoryArticlesScreen extends StatelessWidget {
  final String categoryName;
  final String categorySlug;

  const CategoryArticlesScreen({
    super.key,
    required this.categoryName,
    required this.categorySlug,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CategoryArticlesViewModel(
        getIt<ArticleRepository>(),
        categorySlug,
      )..loadArticles(),
      child: _Body(categoryName: categoryName),
    );
  }
}

class _Body extends StatelessWidget {
  final String categoryName;

  const _Body({required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryArticlesViewModel>();

    switch (vm.state) {
      case CategoryArticlesState.loading:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case CategoryArticlesState.error:
        return Scaffold(
          appBar: AppBar(title: Text(categoryName)),
          body: Center(child: Text(vm.errorMessage)),
        );
      case CategoryArticlesState.success:
        if (vm.articles.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(categoryName)),
            body: const Center(child: Text('No articles found in this category')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(categoryName)),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: vm.articles.length,
            itemBuilder: (context, index) {
              return ArticleCard(article: vm.articles[index]);
            },
          ),
        );
      case CategoryArticlesState.idle:
        return const SizedBox.shrink();
    }
  }
}
