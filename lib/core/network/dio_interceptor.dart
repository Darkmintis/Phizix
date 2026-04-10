import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:phizix/shared/models/error_model.dart';
import '../services/api_exception.dart';

class AppInterceptor extends Interceptor{
  @override
    void onRequest(RequestOptions options, RequestInterceptorHandler handler){
        if (kDebugMode) {
        debugPrint('Request: ${options.method} ${options.path}');
        }
        handler.next(options);
      }
      @override
    void onResponse(Response response, ResponseInterceptorHandler handler) {
        if (kDebugMode) {
        debugPrint('Response: ${response.statusCode} ${response.requestOptions.path}');
        }
        handler.next(response);
      }
      @override
     void onError(DioException err, ErrorInterceptorHandler handler){
        if (kDebugMode) {
        debugPrint('Error: ${err.message}');
        }

        final exception = _mapError(err);
        handler.next(err.copyWith(error: exception));
      }

      ApiException _mapError(DioException error){
        try {
          if (error.response?.data != null){
            final errorModel = ErrorModel.fromJson(error.response?.data);
            if (errorModel.message != null){
              return ApiException(
                message: errorModel.message!,
                statusCode: errorModel.statusCode,
                type: errorModel.message,
              );
            }
          }
        } catch (_) {}
        final statusCode = error.response?.statusCode;

        if (statusCode != null) {
      switch (statusCode) {
        case 400:
          return ApiException(
            message: "Invalid request",
            statusCode: 400,
            type: "bad_request",
          );
        case 401:
          return ApiException(
            message: "Unauthorized",
            statusCode: 401,
            type: "auth_error",
          );
        case 403:
          return ApiException(
            message: "Access denied",
            statusCode: 403,
            type: "forbidden",
          );
        case 404:
          return ApiException(
            message: "Data not found",
            statusCode: 404,
            type: "not_found",
          );
        case 500:
          return ApiException(
            message: "Server error",
            statusCode: 500,
            type: "server_error",
          );
        default:
          return ApiException(
            message: "Unexpected error",
            statusCode: statusCode,
            type: "unknown",
          );
      }
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          message: "Connection timeout",
          type: "timeout",
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: "Receive timeout",
          type: "timeout",
        );
      case DioExceptionType.cancel:
        return ApiException(
          message: "Request cancelled",
          type: "cancelled",
        );
      default:
        return ApiException(
          message: "No internet connection",
          type: "network",
        );
    }
  }
}

