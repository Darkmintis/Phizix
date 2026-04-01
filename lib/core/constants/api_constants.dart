class ApiConstants {
  static const String baseUrl = 'https://physicsfeed.com/api';
  static const String articleEndpoint = '/article';
  static const String categoriesEndpoint = '/category';
  static const String tagsEndpoint = '/tag';
  static const String authorsEndpoint = '/author';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}