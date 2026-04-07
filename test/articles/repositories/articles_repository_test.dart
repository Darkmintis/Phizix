import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/core/api/article_api.dart';
import 'package:phizix/views/articles/models/article_model.dart';
import 'package:phizix/views/articles/models/article_response.dart';
import 'package:phizix/views/articles/repositories/article_repository.dart';
import 'package:phizix/views/articles/repositories/article_repository_impl.dart';

class MockArticleApi extends Mock implements ArticleApi {}

// helper — reuse in every test
Article fakeArticle() => Article(
      title: 'Test Article',
      slug: 'test-article',
      excerpt: 'Test excerpt',
      content: 'Test content',
      featureImage: 'https://image.com/test.jpg',
      publishedAt: DateTime(2024, 1, 1),
    );

void main() {
  late MockArticleApi mockApi;
  late ArticleRepository repository;

  setUp(() {
    mockApi = MockArticleApi();
    repository = ArticleRepositoryImpl(mockApi);
  });

  // ── getArticles() ────────────────────────────────
  group('getArticles', () {

    test('returns list of articles on success', () async {
      // Arrange
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [fakeArticle()],
                pagination: {},
              ));

      // Act
      final result = await repository.getArticles();

      // Assert
      expect(result, isA<List<Article>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Article');
    });

    test('returns empty list when api returns no articles', () async {
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [],
                pagination: {},
              ));

      final result = await repository.getArticles();

      expect(result, isEmpty);
    });

    test('throws exception when API fails', () async {
      when(() => mockApi.getArticles(1))
          .thenThrow(Exception('Network error'));

      expect(() => repository.getArticles(), throwsException);
    });

  });

  // ── getArticlesWithPagination() ──────────────────
  group('getArticlesWithPagination', () {

    test('returns correct pagination map', () async {
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [fakeArticle()],
                pagination: {'page': 2, 'count': 20},
              ));

      final result = await repository.getArticlesWithPagination();

      expect(result['articles'], isA<List<Article>>());
      expect(result['currentPage'], 2);
      expect(result['totalItems'], 20);
    });

    test('returns default values when pagination keys are missing', () async {
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [],
                pagination: {},
              ));

      final result = await repository.getArticlesWithPagination();

      expect(result['currentPage'], 1);
      expect(result['totalItems'], 0);
    });

  });
}