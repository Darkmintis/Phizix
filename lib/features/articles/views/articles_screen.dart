import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phizix/shared/widgets/article_card.dart';
import '../viewmodels/articles_view_model.dart';
import '../../../core/di/service_locator.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<ArticlesViewModel>()..loadArticles(),
      child: const _ArticlesContent(),
    );
  }
}

class _ArticlesContent extends StatelessWidget {
  const _ArticlesContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ArticlesViewModel>();
  

    // Handle different states
    switch (viewModel.state) {
      case ViewState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      
      case ViewState.error:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading articles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  viewModel.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.retry(),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        );
      
      case ViewState.success:
        if (viewModel.articles.isEmpty) {
          return const Center(
            child: Text('No articles found'),
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => viewModel.refreshArticles(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: viewModel.articles.length,
            itemBuilder: (context, index) {
              final article = viewModel.articles[index];
              return ArticleCard(article: article);
            },
          ),
        );
      
      default:
        return const SizedBox.shrink();
    }
  }
}