import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'dio_interceptor.dart';

class DioClient {
  late final Dio _dio;
  
  DioClient(){
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: ApiConstants.headers,
    ));

    _setupInterceptors();
  }

  Dio get dio => _dio;
  
  void _setupInterceptors(){
    _dio.interceptors.add(AppInterceptor());
  }

  void dispose(){
    _dio.close();    
  }
}