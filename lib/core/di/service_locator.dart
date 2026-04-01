import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../services/api_service.dart';
import '../../views/articles/repositories/article_repository.dart';
import '../../views/articles/articles_view_model.dart';

final getIt = GetIt.instance;

class ServiceLocator {
  static void setup() {
    // Network
    getIt.registerLazySingleton<DioClient>(() => DioClient());
    
    // Services
    getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<DioClient>()));
    
    // Repositories
    getIt.registerLazySingleton<ArticleRepository>(
      () => ArticleRepository(getIt<ApiService>()),
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