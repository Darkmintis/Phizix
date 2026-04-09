import 'package:flutter/material.dart';
import 'package:phizix/core/constants/app_routes.dart';
import 'package:phizix/features/articles/views/article_details_screen.dart';
import 'package:phizix/features/main/main_screen.dart';
import 'package:phizix/shared/viewmodels/filtered_articles_view_model.dart';
import 'package:phizix/shared/views/filtered_articles_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );

      case AppRoutes.articleDetails:
        final args = settings.arguments as Map<String, dynamic>?;
        final slug = args?[AppRoutes.argSlug] as String?;

        if (slug == null || slug.isEmpty) {
          return _errorRoute('Missing article slug');
        }

        return MaterialPageRoute(
          builder: (_) => ArticleDetailsScreen(slug: slug),
          settings: settings,
        );

      case AppRoutes.filteredArticles:
        final args = settings.arguments as Map<String, dynamic>?;
        final title = args?[AppRoutes.argTitle] as String?;
        final slug = args?[AppRoutes.argSlug] as String?;
        final filterType = args?[AppRoutes.argFilterType] as FilterType?;

        if (title == null || title.isEmpty || slug == null || slug.isEmpty || filterType == null) {
          return _errorRoute('Invalid filtered articles arguments');
        }

        return MaterialPageRoute(
          builder: (_) => FilteredArticlesScreen(
            title: title,
            slug: slug,
            filterType: filterType,
          ),
          settings: settings,
        );

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Navigation Error')),
        body: Center(child: Text(message)),
      ),
    );
  }
}
