import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/features/tags/models/tag_model.dart';
import 'package:phizix/features/tags/repositories/tag_repository.dart';
import 'package:phizix/features/tags/viewmodels/tag_view_model.dart';

class MockTagRepository extends Mock implements TagRepository {}

TagModel fakeTag() => TagModel(
  name: 'nanomaterials',
  slug: 'nanomaterials',
  description: 'Nano-scale materials and science',
  image: 'https://example.com/tag.jpg',
  articleCount: 21,
);

void main() {
  late MockTagRepository mockRepository;
  late TagViewModel viewModel;

  setUp(() {
    mockRepository = MockTagRepository();
    viewModel = TagViewModel(mockRepository);
  });

  group('initial state', () {
    test('starts with empty tags list', () {
      expect(viewModel.tags, isEmpty);
    });

    test('isLoading is false initially', () {
      expect(viewModel.isLoading, false);
    });

    test('starts with empty error', () {
      expect(viewModel.error, '');
    });
  });

  group('loadTags', () {
    test('loads tags on success', () async {
      when(() => mockRepository.getTags()).thenAnswer((_) async => [fakeTag()]);

      await viewModel.loadTags();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, '');
      expect(viewModel.tags.length, 1);
      expect(viewModel.tags.first.name, 'nanomaterials');
      verify(() => mockRepository.getTags()).called(1);
    });

    test('sets error when repository throws', () async {
      when(() => mockRepository.getTags()).thenThrow(Exception('failure'));

      await viewModel.loadTags();

      expect(viewModel.isLoading, false);
      expect(viewModel.tags, isEmpty);
      expect(viewModel.error, contains('Failed to load tags'));
      verify(() => mockRepository.getTags()).called(1);
    });

    test('loadAuthors remains a compatibility alias to loadTags', () async {
      when(() => mockRepository.getTags()).thenAnswer((_) async => [fakeTag()]);

      await viewModel.loadAuthors();

      expect(viewModel.tags.length, 1);
      verify(() => mockRepository.getTags()).called(1);
    });
  });
}
