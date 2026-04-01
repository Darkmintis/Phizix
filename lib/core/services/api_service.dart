import 'package:dio/dio.dart';
import '../network/dio_client.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<dynamic> get(String endpoint, {Map<String, dynamic>? queryParams}) async{
    try{
      final response = await _dioClient.dio.get(
        endpoint,
        queryParameters: queryParams,
      );
      return response.data;
    } on DioException catch (e){
      throw _handleError(e);
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async{
    try{
      final response = await _dioClient.dio.post(
        endpoint,
        data: data,
      );
      return response.data;
    } on DioException catch (e){
      throw _handleError(e);
    }
  }

  Future<dynamic> put(String endpoint, {Map<String, dynamic>? data}) async{
    try{
      final response = await _dioClient.dio.put(
        endpoint,
        data: data,
      );
      return response.data;
    } on DioException catch (e){
      throw _handleError(e);
    }
  }

  Future<dynamic> delete(String endpoint) async{
    try{
      final response = await _dioClient.dio.delete(endpoint);
      return response.data;
    } on DioException catch(e){
      throw _handleError(e);
    }
  }
  String _handleError(DioException error) {
    if (error.response != null) {
      switch (error.response!.statusCode) {
        case 400:
          return 'Bad request';
        case 401:
          return 'Unauthorized';
        case 403:
          return 'Forbidden';
        case 404:
          return 'Not found';
        case 500:
          return 'Internal server error';
        default:
          return 'Something went wrong';
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return 'Connection timeout';
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return 'Receive timeout';
    } else if (error.type == DioExceptionType.cancel) {
      return 'Request cancelled';
    } else {
      return 'No internet connection';
    }
  }
}