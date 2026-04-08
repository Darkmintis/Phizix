import 'package:flutter/material.dart';
import 'package:phizix/core/di/service_locator.dart';
import 'package:phizix/views/categories/viewmodel/category_view_model.dart';
import 'package:provider/provider.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => getIt<CategoryViewModel>()..loadAuthors(),
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
      appBar: AppBar(title: const Text("Categories")),
      body: ListView.builder(
        itemCount: vm.categories.length,
        itemBuilder: (context, index) {
          final category = vm.categories[index];

          return ListTile(
            leading: CircleAvatar(
              
              backgroundImage: category.image == null ? NetworkImage('https://imgs.search.brave.com/AFQDS58XTLxZRmWDU93yJeuZRE5X6v3P7HrJ7axRXN4/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93YWxs/cGFwZXJzLmNvbS9p/bWFnZXMvaGQvcGxh/aW4tZ3JleS1iYWNr/Z3JvdW5kLTJiZmV4/NXlyeWN1NHdmbXgu/anBn') :NetworkImage(category.image!),
            ),
            title: Text(category.name!),
            subtitle: Text("${category.articleCount} articles"),
            
          );
        },
      ),
    );
  }
}