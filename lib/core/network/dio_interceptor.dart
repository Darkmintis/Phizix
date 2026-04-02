import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class LoggingInterceptor extends Interceptor{
  @override
    void onRequest(RequestOptions options, RequestInterceptorHandler handler){
        debugPrint('Request: ${options.method} ${options.path}');
        handler.next(options);
      }
      @override
    void onResponse(Response response, ResponseInterceptorHandler handler) {
        debugPrint('Response: ${response.statusCode} ${response.requestOptions.path}');
        handler.next(response);
      }
      @override
     void onError(DioException error, ErrorInterceptorHandler handler){
        debugPrint('Error: ${error.message}');
        handler.next(error);
      }
}