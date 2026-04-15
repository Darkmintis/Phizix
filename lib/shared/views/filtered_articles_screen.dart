import 'package:flutter/material.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';
import 'package:phizix/shared/viewmodels/filtered_articles_view_model.dart';
import 'package:phizix/shared/widgets/article_card.dart';
import 'package:provider/provider.dart';
import '../../core/enums/view_state.dart';

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

  static const int _prefetchThreshold = 3;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<FilteredArticlesViewModel>();

    Widget body;

    switch (vm.state) {
      case ViewState.loading:
        body = const Center(child: CircularProgressIndicator());
        break;
      case ViewState.error:
        body = Center(child: Text(vm.errorMessage));
        break;
      case ViewState.success:
        if (vm.articles.isEmpty) {
          body = const Center(child: Text('No articles found'));
          break;
        }

        body = ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: vm.articles.length,
          itemBuilder: (context, index) {
            final shouldPrefetch =
                vm.hasMore && index >= vm.articles.length - _prefetchThreshold;

            if (shouldPrefetch) {
              vm.loadMoreArticles();
            }

            return ArticleCard(article: vm.articles[index]);
          },
        );
        break;
      case ViewState.idle:
        body = const SizedBox.shrink();
        break;
    }

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
    );
  }
}
