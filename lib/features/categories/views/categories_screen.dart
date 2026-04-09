import 'package:flutter/material.dart';
import 'package:phizix/core/constants/app_routes.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:phizix/features/categories/viewmodels/category_view_model.dart';
import 'package:phizix/shared/viewmodels/filtered_articles_view_model.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<CategoryViewModel>()..loadCategories(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CategoryViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error.isNotEmpty) {
      return Center(child: Text(vm.error));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: vm.categories.length,
      itemBuilder: (context, index) {
        final category = vm.categories[index];
        final imageUrl = category.image ?? '';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            onTap: () {
              if ((category.slug ?? '').isEmpty) {
                return;
              }

              Navigator.pushNamed(
                context,
                AppRoutes.filteredArticles,
                arguments: {
                  AppRoutes.argTitle: category.name ?? 'Category',
                  AppRoutes.argSlug: category.slug!,
                  AppRoutes.argFilterType: FilterType.category,
                },
              );
            },
            leading: CircleAvatar(
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty ? const Icon(Icons.category) : null,
            ),
            title: Text(category.name ?? 'Unknown Category'),
            subtitle: Text('${category.articleCount ?? 0} articles'),
            trailing: const Icon(Icons.chevron_right),
          ),
        );
      },
    );
  }
}