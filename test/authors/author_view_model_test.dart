import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/features/authors/models/author_model.dart';
import 'package:phizix/features/authors/repositories/author_repository.dart';
import 'package:phizix/features/authors/viewmodels/author_view_model.dart';

class MockAuthorRepository extends Mock implements AuthorRepository {}

Author fakeAuthor() => Author(
  name: 'Ram Chandra Gotame',
  slug: 'ram-chandra-gotame',
  description: 'Physics enthusiast and writer',
  image: 'https://example.com/author.jpg',
  articleCount: 178,
);

void main() {
  late MockAuthorRepository mockRepository;
  late AuthorsViewModel viewModel;

  setUp(() {
    mockRepository = MockAuthorRepository();
    viewModel = AuthorsViewModel(mockRepository);
  });

  group('initial state', () {
    test('starts with empty authors list', () {
      expect(viewModel.authors, isEmpty);
    });

    test('isLoading is false initially', () {
      expect(viewModel.isLoading, false);
    });

    test('starts with empty error', () {
      expect(viewModel.error, '');
    });
  });

  group('loadAuthors', () {
    test('loads authors on success', () async {
      when(() => mockRepository.getAuthors())
          .thenAnswer((_) async => [fakeAuthor()]);

      await viewModel.loadAuthors();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, '');
      expect(viewModel.authors.length, 1);
      expect(viewModel.authors.first.name, 'Ram Chandra Gotame');
    });

    test('sets error when repository throws', () async {
      when(() => mockRepository.getAuthors())
          .thenThrow(Exception('failure'));

      await viewModel.loadAuthors();

      expect(viewModel.isLoading, false);
      expect(viewModel.authors, isEmpty);
      expect(viewModel.error, contains('Failed to load authors'));
    });
  });
}
