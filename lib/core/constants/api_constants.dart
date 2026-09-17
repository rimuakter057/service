
class ApiConstants {
  const ApiConstants._();

  static const String baseUrl = 'http://10.10.28.184:8005/api/v1';

  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
