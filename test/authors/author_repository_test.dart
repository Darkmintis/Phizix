import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/core/services/api_exception.dart';
import 'package:phizix/features/authors/models/author_model.dart';
import 'package:phizix/features/authors/repositories/author_repository.dart';
import 'package:phizix/features/authors/repositories/author_repository_impl.dart';

import 'mocks/mock_article_api.dart';

Author fakeAuthor() => Author(
  name: 'Ram Chandra Gotame',
  slug: 'ram-chandra-gotame',
  description: 'Physics enthusiast and writer',
  image: 'https://example.com/author.jpg',
  articleCount: 178,
);

void main() {
  late MockArticleApi mockApi;
  late AuthorRepository repository;

  setUp(() {
    mockApi = MockArticleApi();
    repository = AuthorRepositoryImpl(mockApi);
  });

  group('getAuthors', () {
    test('returns list of authors on success', () async {
      when(() => mockApi.getAuthors()).thenAnswer((_) async => [fakeAuthor()]);

      final result = await repository.getAuthors();

      expect(result, isA<List<Author>>());
      expect(result.length, 1);
      expect(result.first.name, 'Ram Chandra Gotame');
      verify(() => mockApi.getAuthors()).called(1);
    });

    test('returns empty list when api returns no authors', () async {
      when(() => mockApi.getAuthors()).thenAnswer((_) async => []);

      final result = await repository.getAuthors();

      expect(result, isEmpty);
      verify(() => mockApi.getAuthors()).called(1);
    });

    test('throws when API fails', () async {
      when(() => mockApi.getAuthors()).thenThrow(Exception('Network error'));

      expect(
        () => repository.getAuthors(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            contains('Failed to fetch authors'),
          ),
        ),
      );
      verify(() => mockApi.getAuthors()).called(1);
    });
  });
}
