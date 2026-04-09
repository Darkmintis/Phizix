import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:phizix/main.dart' as app;
import 'package:phizix/features/articles/widgets/article_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Articles flow: scroll list → open article → scroll detail → go back',
      (WidgetTester tester) async {

    // ─────────────────────────────────────────
    // 🚀 Boot the app
    // ─────────────────────────────────────────
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ─────────────────────────────────────────
    // 📰 Go to Articles tab
    // ─────────────────────────────────────────
    final articlesTab = find.text('Articles');

    if (articlesTab.evaluate().isNotEmpty) {
      await tester.tap(articlesTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // ─────────────────────────────────────────
    // ⏳ Wait for articles to load
    // Loading shows CircularProgressIndicator
    // We keep pumping until it disappears
    // ─────────────────────────────────────────
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
      final isLoading = find.byType(CircularProgressIndicator);
      if (isLoading.evaluate().isEmpty) break;
    }

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ─────────────────────────────────────────
    // 📜 Scroll the articles list DOWN
    // ─────────────────────────────────────────
    final articlesList = find.byType(ListView);

    if (articlesList.evaluate().isNotEmpty) {
      await tester.fling(
        articlesList,
        const Offset(0, -400), // scroll down
        800,
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Scroll back up to top so first article is visible
      await tester.fling(
        articlesList,
        const Offset(0, 400), // scroll up
        800,
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    // ─────────────────────────────────────────
    // 👆 Tap the first ArticleCard
    // ─────────────────────────────────────────
    final articleCards = find.byType(ArticleCard);

    expect(
      articleCards,
      findsWidgets,
      reason: 'No ArticleCards found — articles may not have loaded',
    );

    await tester.tap(articleCards.first);
    await tester.pumpAndSettle(const Duration(seconds: 3));

    // ─────────────────────────────────────────
    // ⏳ Wait for article detail to finish loading
    // ─────────────────────────────────────────
    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(seconds: 1));
      final isLoading = find.byType(CircularProgressIndicator);
      if (isLoading.evaluate().isEmpty) break;
    }

    await tester.pumpAndSettle(const Duration(seconds: 1));

    // ─────────────────────────────────────────
    // 📄 We are now on ArticleDetailsScreen
    // Confirm we have a Scaffold with AppBar
    // ─────────────────────────────────────────
    expect(
      find.byType(AppBar),
      findsOneWidget,
      reason: 'ArticleDetailsScreen AppBar not found',
    );

    // ─────────────────────────────────────────
    // 📜 Scroll the article detail DOWN
    // ─────────────────────────────────────────
    final detailScroll = find.byType(SingleChildScrollView);

    if (detailScroll.evaluate().isNotEmpty) {
      await tester.fling(
        detailScroll,
        const Offset(0, -600), // scroll down through content
        800,
      );
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    // ─────────────────────────────────────────
    // 🔙 Go back to Articles list
    // Uses AppBar's automatic back arrow
    // ─────────────────────────────────────────
    await tester.pageBack();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // ─────────────────────────────────────────
    // ✅ Final check — back on Articles screen
    // ─────────────────────────────────────────
    expect(
      find.byType(ArticleCard),
      findsWidgets,
      reason: 'Should be back on Articles list after going back',
    );
  });
}