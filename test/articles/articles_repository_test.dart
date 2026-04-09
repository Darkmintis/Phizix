import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/core/api/article_api.dart';
import 'package:phizix/features/articles/models/article_model.dart';
import 'package:phizix/features/articles/models/article_response.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';
import 'package:phizix/features/articles/repositories/article_repository_impl.dart';

class MockArticleApi extends Mock implements ArticleApi {}

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

  group('getArticles', () {
    test('returns list of articles on success', () async {
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [fakeArticle()],
                pagination: {},
              ));

      final result = await repository.getArticles();

      expect(result, isA<List<Article>>());
      expect(result.length, 1);
      expect(result.first.title, 'Test Article');
      verify(() => mockApi.getArticles(1)).called(1);
    });

    test('returns empty list when api returns no articles', () async {
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [],
                pagination: {},
              ));

      final result = await repository.getArticles();

      expect(result, isEmpty);
      verify(() => mockApi.getArticles(1)).called(1);
    });

    test('throws exception when API fails', () async {
      when(() => mockApi.getArticles(1))
          .thenThrow(Exception('Network error'));

      expect(() => repository.getArticles(), throwsException);
      verify(() => mockApi.getArticles(1)).called(1);
    });
  });

  group('getArticlesByCategory', () {
    test('returns category filtered articles', () async {
      when(() => mockApi.getArticlesByCategory('astrophysics', 1))
          .thenAnswer((_) async => ArticleResponse(
                results: [fakeArticle()],
                pagination: {},
              ));

      final result = await repository.getArticlesByCategory('astrophysics');

      expect(result.length, 1);
      verify(() => mockApi.getArticlesByCategory('astrophysics', 1)).called(1);
    });

    test('throws when category request fails', () async {
      when(() => mockApi.getArticlesByCategory('astrophysics', 1))
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.getArticlesByCategory('astrophysics'),
        throwsException,
      );
      verify(() => mockApi.getArticlesByCategory('astrophysics', 1)).called(1);
    });
  });

  group('getArticlesByTag', () {
    test('returns tag filtered articles', () async {
      when(() => mockApi.getArticlesByTag('nanomaterials', 1))
          .thenAnswer((_) async => ArticleResponse(
                results: [fakeArticle()],
                pagination: {},
              ));

      final result = await repository.getArticlesByTag('nanomaterials');

      expect(result.length, 1);
      verify(() => mockApi.getArticlesByTag('nanomaterials', 1)).called(1);
    });

    test('throws when tag request fails', () async {
      when(() => mockApi.getArticlesByTag('nanomaterials', 1))
          .thenThrow(Exception('Network error'));

      expect(() => repository.getArticlesByTag('nanomaterials'), throwsException);
      verify(() => mockApi.getArticlesByTag('nanomaterials', 1)).called(1);
    });
  });

  group('getArticlesWithPagination', () {
    test('returns correct pagination map', () async {
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [fakeArticle()],
                pagination: {'page': 2, 'count': 20},
              ));

      final result = await repository.getArticlesWithPagination();

      expect(result.articles, isA<List<Article>>());
      expect(result.currentPage, 2);
      expect(result.totalItems, 20);
      verify(() => mockApi.getArticles(1)).called(1);
    });

    test('returns default values when pagination keys are missing', () async {
      when(() => mockApi.getArticles(1))
          .thenAnswer((_) async => ArticleResponse(
                results: [],
                pagination: {},
              ));

      final result = await repository.getArticlesWithPagination();

      expect(result.currentPage, 1);
      expect(result.totalItems, 0);
      verify(() => mockApi.getArticles(1)).called(1);
    });
  });
}