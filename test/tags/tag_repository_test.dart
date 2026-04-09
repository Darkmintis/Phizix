import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/core/services/api_exception.dart';
import 'package:phizix/features/tags/models/tag_model.dart';
import 'package:phizix/features/tags/repositories/tag_repository.dart';
import 'package:phizix/features/tags/repositories/tag_repository_impl.dart';

import 'mocks/mock_article_api.dart';

TagModel fakeTag() => TagModel(
  name: 'nanomaterials',
  slug: 'nanomaterials',
  description: 'Nano-scale materials and science',
  image: 'https://example.com/tag.jpg',
  articleCount: 21,
);

void main() {
  late MockArticleApi mockApi;
  late TagRepository repository;

  setUp(() {
    mockApi = MockArticleApi();
    repository = TagRepositoryImpl(mockApi);
  });

  group('getTags', () {
    test('returns list of tags on success', () async {
      when(() => mockApi.getTags()).thenAnswer((_) async => [fakeTag()]);

      final result = await repository.getTags();

      expect(result, isA<List<TagModel>>());
      expect(result.length, 1);
      expect(result.first.name, 'nanomaterials');
      verify(() => mockApi.getTags()).called(1);
    });

    test('returns empty list when api returns no tags', () async {
      when(() => mockApi.getTags()).thenAnswer((_) async => []);

      final result = await repository.getTags();

      expect(result, isEmpty);
      verify(() => mockApi.getTags()).called(1);
    });

    test('throws when API fails', () async {
      when(() => mockApi.getTags()).thenThrow(Exception('Network error'));

      expect(
        () => repository.getTags(),
        throwsA(
          isA<ApiException>().having(
            (e) => e.message,
            'message',
            contains('Failed to fetch tags'),
          ),
        ),
      );
      verify(() => mockApi.getTags()).called(1);
    });
  });
}
