/// API constants for the application
class ApiConstants {
  /// Base URL for the API
  static const String baseUrl = 'https://api.example.com';

  /// API version
  static const String apiVersion = 'v1';

  /// Timeout in milliseconds
  static const int timeout = 30000;

  /// Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/user/profile';
  static const String products = '/products';

  /// Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Get a full endpoint URL
  static String getEndpoint(String endpoint) {
    return '$baseUrl/$apiVersion$endpoint';
  }
}
