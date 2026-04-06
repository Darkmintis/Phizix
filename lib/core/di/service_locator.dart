import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../api/article_api.dart';
import '../../views/articles/repositories/article_repository.dart';
import '../../views/articles/articles_view_model.dart';
import '../constants/api_constants.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static void setup() {
    // Network
    getIt.registerLazySingleton<DioClient>(() => DioClient());
    
    // Services
    getIt.registerLazySingleton<ArticleApi>(() => ArticleApi(
      getIt<DioClient>().dio,
    baseUrl: ApiConstants.baseUrl));
    
    // Repositories
    getIt.registerLazySingleton<ArticleRepository>(
      () => ArticleRepository(getIt<ArticleApi>()),
    );
    
    // ViewModels
    getIt.registerFactory<ArticlesViewModel>(
      () => ArticlesViewModel(getIt<ArticleRepository>()),
    );
  }
  
  static void dispose() {
    getIt.reset();
  }
}