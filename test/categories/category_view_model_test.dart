import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/features/categories/models/category_model.dart';
import 'package:phizix/features/categories/repositories/category_repository.dart';
import 'package:phizix/features/categories/viewmodels/category_view_model.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

CategoryModel fakeCategory() => CategoryModel(
  name: 'Astrophysics',
  slug: 'astrophysics',
  description: 'Space and cosmos',
  image: 'https://example.com/category.jpg',
  articleCount: 45,
);

void main() {
  late MockCategoryRepository mockRepository;
  late CategoryViewModel viewModel;

  setUp(() {
    mockRepository = MockCategoryRepository();
    viewModel = CategoryViewModel(mockRepository);
  });

  group('initial state', () {
    test('starts with empty categories list', () {
      expect(viewModel.categories, isEmpty);
    });

    test('isLoading is false initially', () {
      expect(viewModel.isLoading, false);
    });

    test('starts with empty error', () {
      expect(viewModel.error, '');
    });
  });

  group('loadCategories', () {
    test('loads categories on success', () async {
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => [fakeCategory()]);

      await viewModel.loadCategories();

      expect(viewModel.isLoading, false);
      expect(viewModel.error, '');
      expect(viewModel.categories.length, 1);
      expect(viewModel.categories.first.name, 'Astrophysics');
    });

    test('sets error when repository throws', () async {
      when(() => mockRepository.getCategories())
          .thenThrow(Exception('failure'));

      await viewModel.loadCategories();

      expect(viewModel.isLoading, false);
      expect(viewModel.categories, isEmpty);
      expect(viewModel.error, contains('Failed to load categories'));
    });
  });
}
