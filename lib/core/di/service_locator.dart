import 'package:get_it/get_it.dart';
import 'package:phizix/views/categories/repositories/category_repository.dart';
import 'package:phizix/views/categories/repositories/category_repository_impl.dart';
import 'package:phizix/views/categories/viewmodel/category_view_model.dart';
import 'package:phizix/views/tags/repositories/tag_repository.dart';
import 'package:phizix/views/tags/repositories/tag_repository_impl.dart';
import 'package:phizix/views/tags/viewmodel/tag_view_model.dart';
import '../network/dio_client.dart';
import '../api/article_api.dart';
import '../../views/articles/repositories/article_repository_impl.dart';
import '../../views/articles/repositories/article_repository.dart';
import '../../views/articles/viewmodel/articles_view_model.dart';
import '../../views/articles/viewmodel/article_detail_viewmodel.dart';
import '../../views/authors/viewmodel/author_view_model.dart';
import '../../views/authors/repositories/author_repository.dart';
import '../../views/authors/repositories/author_repository_impl.dart';
import '../constants/api_constants.dart';


final getIt = GetIt.instance;

class ServiceLocator {
  static void setup() {
    // Network
    getIt.registerLazySingleton<DioClient>(() => DioClient());
    
    // API
    getIt.registerLazySingleton<ArticleApi>(() => ArticleApi(
      getIt<DioClient>().dio,
    baseUrl: ApiConstants.baseUrl));
    
    // Repositories
    getIt.registerLazySingleton<ArticleRepository>(
      () => ArticleRepositoryImpl(getIt<ArticleApi>()),
    );
    
    // ViewModels
    getIt.registerFactory<ArticlesViewModel>(
      () => ArticlesViewModel(getIt<ArticleRepository>()),
    );

    getIt.registerFactory<ArticleDetailViewModel>(
      () => ArticleDetailViewModel(getIt<ArticleRepository>()),
    );

    getIt.registerLazySingleton<AuthorRepository>(
    () => AuthorRepositoryImpl(getIt<ArticleApi>()),
    );

    getIt.registerFactory<AuthorsViewModel>(
    () => AuthorsViewModel(getIt<AuthorRepository>()),
    );

    getIt.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(getIt<ArticleApi>()),
    );

    getIt.registerFactory<CategoryViewModel>(
    () => CategoryViewModel(getIt<CategoryRepository>()),
    );
    
    getIt.registerLazySingleton<TagRepository>(  
      () => TagRepositoryImpl(getIt<ArticleApi>()),
    );

    getIt.registerFactory<TagViewModel>( 
      () => TagViewModel(getIt<TagRepository>()),
    );
  }
  
  static void dispose() {
    getIt.reset();
  }
}