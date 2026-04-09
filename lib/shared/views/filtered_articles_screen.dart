import 'package:flutter/material.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';
import 'package:phizix/shared/viewmodels/filtered_articles_view_model.dart';
import 'package:phizix/shared/widgets/article_card.dart';
import 'package:provider/provider.dart';

class FilteredArticlesScreen extends StatelessWidget {
  final String title;
  final String slug;
  final FilterType filterType;

  const FilteredArticlesScreen({
    super.key,
    required this.title,
    required this.slug,
    required this.filterType,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FilteredArticlesViewModel(
        getIt<ArticleRepository>(),
        filterType,
        slug,
      )..loadArticles(),
      child: _Body(title: title),
    );
  }
}

class _Body extends StatelessWidget {
  final String title;

  const _Body({required this.title});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FilteredArticlesViewModel>();

    switch (vm.state) {
      case FilteredArticlesState.loading:
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      case FilteredArticlesState.error:
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: Text(vm.errorMessage)),
        );
      case FilteredArticlesState.success:
        if (vm.articles.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: const Center(child: Text('No articles found')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: vm.articles.length,
            itemBuilder: (context, index) {
              return ArticleCard(article: vm.articles[index]);
            },
          ),
        );
      case FilteredArticlesState.idle:
        return const SizedBox.shrink();
    }
  }
}
