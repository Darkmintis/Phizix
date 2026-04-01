import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import 'package:flutter/foundation.dart';

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
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler){
        debugPrint('Request: ${options.method} ${options.path}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        debugPrint('Response: ${response.statusCode} ${response.requestOptions.path}');
        return handler.next(response);
      },
      onError: (error, handler){
        debugPrint('Error: ${error.message}');
        return handler.next(error);
      },
    ));
  }

  void dispose(){
    _dio.close();    
  }
}