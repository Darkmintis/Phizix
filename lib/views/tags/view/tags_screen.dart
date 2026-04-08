import 'package:flutter/material.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import '../viewmodel/tag_view_model.dart';

class TagsScreen extends StatelessWidget {
  const TagsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<TagViewModel>()..loadAuthors(),
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (vm.error.isNotEmpty) {
      return Scaffold(
        body: Center(child: Text(vm.error)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Tags")),
      body: ListView.builder(
        itemCount: vm.tags.length,
        itemBuilder: (context, index) {
          final tag = vm.tags[index];

          return ListTile(
            title: Text(tag.name!),
            trailing: Text("${tag.articleCount}"),
            
          );
        },
      ),
    );
  }
}