import 'package:flutter/material.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:provider/provider.dart';
import '../viewmodel/author_view_model.dart';

class AuthorsScreen extends StatelessWidget {
  const AuthorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<AuthorsViewModel>()..loadAuthors(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AuthorsViewModel>();

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
      appBar: AppBar(title: const Text("Authors")),
      body: ListView.builder(
        itemCount: vm.authors.length,
        itemBuilder: (context, index) {
          final author = vm.authors[0];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(author.image),
            ),
            title: Text(author.name),
            subtitle: Text("${author.articleCount} articles"),
            
          );
        },
      ),
    );
  }
}