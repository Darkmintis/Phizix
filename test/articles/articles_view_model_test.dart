import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:phizix/core/services/api_exception.dart';
import 'package:phizix/features/articles/models/article_model.dart';
import 'package:phizix/features/articles/repositories/article_repository.dart';
import 'package:phizix/features/articles/viewmodels/articles_view_model.dart';

class MockArticleRepository extends Mock implements ArticleRepository{}

Article fakeArticle() => Article(  
  title: 'Test Article',
  slug: 'test-article',
  excerpt: 'Test excerpt',
  content: 'Test content',
  featureImage: 'https://image.com/test.jpg',
  publishedAt: DateTime(2024, 1, 1),
);

void main(){
  late MockArticleRepository mockRepository;
  late ArticlesViewModel viewModel;

  setUp((){
    mockRepository = MockArticleRepository();
    viewModel = ArticlesViewModel(mockRepository);
  });

  group('initial state', (){

    test('starts with idle state', (){
      expect(viewModel.state, ViewState.idle);
    });

    test('starts with empty articles list', (){
      expect(viewModel.articles, isEmpty);
    });

    test('starts with empty error message', (){
      expect(viewModel.errorMessage, '');
    });

    test('isLoading is false initially', (){
      expect(viewModel.isLoading, '');
    });
  });

  group('loadArticles', (){
    test('state is loading then success on success', ()async {
      when(() => mockRepository.getArticles(page: 1))
      .thenAnswer((_) async => [fakeArticle()]);

      final future = viewModel.loadArticles();
      expect(viewModel.state, ViewState.loading);
      expect(viewModel.isLoading, true);

      await future;

      expect(viewModel.state, ViewState.success);
      expect(viewModel.isLoading, false);
    });

    test('articles are populated on success', () async{
      when(() => mockRepository.getArticles(page: 1))
      .thenAnswer((_) async => [fakeArticle()]);

      await viewModel.loadArticles();

      expect(viewModel.articles.length, 1);
      expect(viewModel.articles.first.title, 'Test Article');
    });

    test('error message is cleared on success', () async{
      when(() => mockRepository.getArticles(page: 1))
      .thenAnswer((_) async => [fakeArticle()]);

      await viewModel.loadArticles();

      expect(viewModel.errorMessage, '');
    });

    test('state is error when repository throws generic exception', () async{
      when(() => mockRepository.getArticles(page: 1))
      .thenThrow(Exception('Something failed'));

      await viewModel.loadArticles();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, 'Something went wrong');
    });

    test('shows ApiException message on DioExceptino with ApiException', () async{
      final apiException = ApiException(message: 'Article not found', statusCode: 404);
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/article'),
        error: apiException,
      );

      when(() => mockRepository.getArticles(page: 1))
      .thenThrow(dioException);

      await viewModel.loadArticles();

      expect(viewModel.state, ViewState.error);
      expect(viewModel.errorMessage, 'Article not found');
    });

    test('articles list is empty on error', () async{
      when(() => mockRepository.getArticles(page: 1))
      .thenThrow(Exception('fail'));

      await viewModel.loadArticles();

      expect(viewModel.articles, isEmpty);
    });
  });

  group('refereshArticles', (){
    test('behaves same as loadArticles on success', () async {
      when(() => mockRepository.getArticles(page: 1))
      .thenAnswer((_) async => [fakeArticle()]);

      await viewModel.refreshArticles();

      expect(viewModel.state, ViewState.success);
      expect(viewModel.articles.length, 1);
    });
  });

  group('retry', (){
    test('recovers from error state on success', () async{
      when(() => mockRepository.getArticles(page: 1))
      .thenThrow(Exception('fail'));
      await viewModel.loadArticles();
      expect(viewModel.state, ViewState.error);

      when(() => mockRepository.getArticles(page: 1))
      .thenAnswer((_) async => [fakeArticle()]);
      await viewModel.retry();

      expect(viewModel.state, ViewState.success);
      expect(viewModel.articles.length, 1);
    });
  });
}