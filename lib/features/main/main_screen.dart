import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../shared/widgets/phizix_app_bar.dart';
import '../articles/views/articles_screen.dart';
import '../categories/views/categories_screen.dart';
import '../tags/views/tags_screen.dart';
import '../authors/views/author_screen.dart';
import '../../core/providers/tab_index_provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class MainScreen extends StatelessWidget{
  const MainScreen({super.key});

  @override  
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (_) => TabIndexProvider(),
      child: const MainScreenContent(),
    );
  }
}

class MainScreenContent extends StatelessWidget{
  const MainScreenContent({super.key});

  static const List<Widget> screens = [
    ArticlesScreen(),
    CategoriesScreen(),
    TagsScreen(),
    AuthorsScreen(),
  ];


  @override
  Widget build(BuildContext context){
  final tabProvider = context.watch<TabIndexProvider>();
  return Scaffold(  
    appBar: const PhizixAppBar(),
    body: screens[tabProvider.currentIndex],
    floatingActionButton: kDebugMode
        ? FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              FirebaseCrashlytics.instance.crash();
            },
            child: const Icon(Icons.bug_report),
          )
        : null,
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: tabProvider.currentIndex,
      onTap: tabProvider.setIndex,
      type: BottomNavigationBarType.fixed,
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.article),
          label: 'Articles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_offer),
          label: 'Tags',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Authors',
        ),
      ],
    ),
  );
  }
}