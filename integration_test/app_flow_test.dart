import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:phizix/main.dart' as app;
import 'package:phizix/shared/widgets/article_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App full navigation flow test', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Articles'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('Tags'), findsOneWidget);
    expect(find.text('Authors'), findsOneWidget);

    Future<void> openTab(String label) async {
      final tab = find.text(label);
      expect(tab, findsOneWidget, reason: 'Missing $label tab');
      await tester.tap(tab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    Future<void> waitForLoadComplete() async {
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 400));
        if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
          break;
        }
      }
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
    }

    await openTab('Articles');
    await waitForLoadComplete();

    final articleCards = find.byType(ArticleCard);
    expect(
      articleCards,
      findsWidgets,
      reason: 'Articles list should render at least one card',
    );

    await tester.tap(articleCards.first);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    expect(find.byType(AppBar), findsOneWidget);
    await tester.pageBack();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await openTab('Categories');
    await waitForLoadComplete();

    final categoryTiles = find.byType(ListTile);
    expect(
      categoryTiles,
      findsWidgets,
      reason: 'Categories list should show tappable categories',
    );

    await tester.tap(categoryTiles.first);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await waitForLoadComplete();

    expect(find.byType(AppBar), findsOneWidget);
    expect(
      find.byType(ArticleCard).evaluate().isNotEmpty ||
          find.text('No articles found').evaluate().isNotEmpty,
      isTrue,
      reason: 'Category detail should show article cards or empty-state text',
    );

    if (find.byType(ArticleCard).evaluate().isNotEmpty) {
      await tester.tap(find.byType(ArticleCard).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(AppBar), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    await tester.pageBack();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await openTab('Tags');
    await waitForLoadComplete();

    final tagTiles = find.byType(ListTile);
    expect(tagTiles, findsWidgets, reason: 'Tags list should be tappable');

    await tester.tap(tagTiles.first);
    await tester.pumpAndSettle(const Duration(seconds: 2));
    await waitForLoadComplete();

    expect(find.byType(AppBar), findsOneWidget);
    expect(
      find.byType(ArticleCard).evaluate().isNotEmpty ||
          find.text('No articles found').evaluate().isNotEmpty,
      isTrue,
      reason: 'Tag detail should show article cards or empty-state text',
    );

    if (find.byType(ArticleCard).evaluate().isNotEmpty) {
      await tester.tap(find.byType(ArticleCard).first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.byType(AppBar), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    await tester.pageBack();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await openTab('Authors');
    await waitForLoadComplete();
    expect(find.byType(ListView), findsOneWidget);

    final navBar = find.byType(BottomNavigationBar);
    expect(navBar, findsOneWidget, reason: 'Main navigation bar should exist');
  });
}
