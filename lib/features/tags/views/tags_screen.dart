import 'package:flutter/material.dart';
import 'package:phizix/core/constants/app_routes.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:phizix/shared/viewmodels/filtered_articles_view_model.dart';
import 'package:provider/provider.dart';
import '../viewmodels/tag_view_model.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<TagViewModel>()..loadTags(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TagViewModel>();

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error.isNotEmpty) {
      return Center(child: Text(vm.error));
    }

    return Padding(
      padding: const EdgeInsets.all(12),
      child: ListView.builder(
        itemCount: vm.tags.length,
        itemBuilder: (context, index) {
          final tag = vm.tags[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              onTap: () {
                if ((tag.slug ?? '').isEmpty) {
                  return;
                }

                Navigator.pushNamed(
                  context,
                  AppRoutes.filteredArticles,
                  arguments: {
                    AppRoutes.argTitle: tag.name ?? 'Tag',
                    AppRoutes.argSlug: tag.slug!,
                    AppRoutes.argFilterType: FilterType.tag,
                  },
                );
              },
              title: Text(
                tag.name ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text('${tag.articleCount ?? 0} articles'),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}