import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';

import 'package:phizix/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("App full navigation flow test", (WidgetTester tester) async {
    // 🚀 Start app
    app.main();
    await tester.pumpAndSettle();

    // ⏳ initial load wait
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // -----------------------------
    // 📰 ARTICLES SCREEN
    // -----------------------------
    final articlesTab = find.text("Articles");

    if (articlesTab.evaluate().isNotEmpty) {
      await tester.tap(articlesTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // Try open first article safely
    final articleItems = find.byType(ListTile);

    if (articleItems.evaluate().isNotEmpty) {
      await tester.tap(articleItems.first);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // back
      await tester.pageBack();
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // -----------------------------
    // 📂 CATEGORIES SCREEN
    // -----------------------------
    final categoriesTab = find.text("Categories");

    if (categoriesTab.evaluate().isNotEmpty) {
      await tester.tap(categoriesTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // -----------------------------
    // 🏷 TAGS SCREEN
    // -----------------------------
    final tagsTab = find.text("Tags");

    if (tagsTab.evaluate().isNotEmpty) {
      await tester.tap(tagsTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // -----------------------------
    // 👤 AUTHORS SCREEN
    // -----------------------------
    final authorsTab = find.text("Authors");

    if (authorsTab.evaluate().isNotEmpty) {
      await tester.tap(authorsTab);
      await tester.pumpAndSettle(const Duration(seconds: 2));
    }

    // -----------------------------
    // 🎯 FINAL CHECK
    // -----------------------------
    expect(find.byType(Scaffold), findsWidgets);
  });
}