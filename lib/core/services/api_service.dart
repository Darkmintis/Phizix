import 'package:dio/dio.dart';
import '../network/dio_client.dart';
import 'api_exception.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<dynamic> get(String endpoint,
      {Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dioClient.dio.post(
        endpoint,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint,
      {Map<String, dynamic>? data}) async {
    try {
      final response = await _dioClient.dio.put(
        endpoint,
        data: data,
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dioClient.dio.delete(endpoint);
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  ApiException _handleError(DioException error) {
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