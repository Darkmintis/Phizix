import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/core/services/api_exception.dart';
import 'package:phizix/features/categories/models/category_model.dart';
import 'package:phizix/features/categories/repositories/category_repository.dart';
import 'package:phizix/features/categories/repositories/category_repository_impl.dart';

import 'mocks/mock_article_api.dart';

CategoryModel fakeCategory() => CategoryModel(
  name: 'Astrophysics',
  slug: 'astrophysics',
  description: 'Space and cosmos',
  image: 'https://example.com/category.jpg',
  articleCount: 45,
);

void main() {
  late MockArticleApi mockApi;
  late CategoryRepository repository;

  setUp(() {
    mockApi = MockArticleApi();
    repository = CategoryRepositoryImpl(mockApi);
  });

  group('getCategories', () {
    test('returns list of categories on success', () async {
      when(() => mockApi.getCategories())
          .thenAnswer((_) async => [fakeCategory()]);

      final result = await repository.getCategories();

      expect(result, isA<List<CategoryModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'Astrophysics');
      verify(() => mockApi.getCategories()).called(1);
    });

    test('returns empty list when api returns no categories', () async {
      when(() => mockApi.getCategories()).thenAnswer((_) async => []);

      final result = await repository.getCategories();

      expect(result, isEmpty);
      verify(() => mockApi.getCategories()).called(1);
    });

    test('throws when API fails', () async {
      when(() => mockApi.getCategories())
          .thenThrow(Exception('Network error'));

      expect(
        () => repository.getCategories(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            contains('Failed to fetch categories'),
          ),
        ),
      );
      verify(() => mockApi.getCategories()).called(1);
    });
  });
}
