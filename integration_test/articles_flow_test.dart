import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:phizix/main.dart' as app;
import 'package:phizix/shared/widgets/article_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Articles flow: open detail and return', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    Future<void> waitForLoadComplete() async {
      for (var i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 400));
        if (find.byType(CircularProgressIndicator).evaluate().isEmpty) {
          break;
        }
      }
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
    }

    final articlesTab = find.text('Articles');
    expect(articlesTab, findsOneWidget);
    await tester.tap(articlesTab);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await waitForLoadComplete();

    final articleCards = find.byType(ArticleCard);
    expect(
      articleCards,
      findsWidgets,
      reason: 'No article cards found after loading',
    );

    final listView = find.byType(ListView);
    if (listView.evaluate().isNotEmpty) {
      await tester.fling(listView, const Offset(0, -400), 800);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      await tester.fling(listView, const Offset(0, 400), 800);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    await tester.tap(articleCards.first);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await waitForLoadComplete();

    expect(
      find.byType(AppBar),
      findsOneWidget,
      reason: 'Article details app bar not found',
    );

    final detailScroll = find.byType(SingleChildScrollView);
    if (detailScroll.evaluate().isNotEmpty) {
      await tester.fling(detailScroll, const Offset(0, -600), 800);
      await tester.pumpAndSettle(const Duration(seconds: 1));
    }

    await tester.pageBack();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(
      find.byType(ArticleCard),
      findsWidgets,
      reason: 'Should return to articles list after page back',
    );
  });
}
