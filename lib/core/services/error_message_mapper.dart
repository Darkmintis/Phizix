import 'package:dio/dio.dart';
import 'package:phizix/core/services/api_exception.dart';

String mapErrorToMessage(
  Object error, {
  String fallback = 'Something went wrong',
}) {
  if (error is ApiException) {
    return error.message;
  }

  if (error is DioException) {
    if (error.error is ApiException) {
      return (error.error as ApiException).message;
    }
  }

  return fallback;
}