class ApiException implements Exception{
  final String message;
  final int? statusCode;
  final String? type;

  ApiException({
    required this.message,
    this.statusCode,
    this.type,
  });

  @override
  String toString() => message;
}