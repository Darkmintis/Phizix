import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import '../../../core/di/service_locator.dart';
import '../viewmodels/article_detail_viewmodel.dart';

class ArticleDetailsScreen extends StatelessWidget {
  final String slug;

  const ArticleDetailsScreen({super.key, required this.slug});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) =>
          getIt<ArticleDetailViewModel>()..loadArticle(slug),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ArticleDetailViewModel>();

    if (vm.state == DetailState.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.state == DetailState.error) {
      return Scaffold(
        body: Center(child: Text(vm.error)),
      );
    }

    if (vm.state == DetailState.success) {
      final article = vm.article!;

      return Scaffold(
        appBar: AppBar(title: Text(article.title)),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(article.featureImage),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Html(data: article.content),
              ),
            ],
          ),
        ),
      );
    }

    return const SizedBox();
  }
}