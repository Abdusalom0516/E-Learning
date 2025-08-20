// ignore_for_file: unused_element

import 'package:dio/dio.dart';

/// Interceptor to add authentication headers to requests
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Todo: Replace with your authentication logic
    // For example, get the token from a secure storage

    // This is just a placeholder. In a real app, you would get the token from
    // a secure storage like flutter_secure_storage
    final token = _getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  /// Get the authentication token
  String? _getToken() {
    // Todo: Implement your token retrieval logic
    // For example:
    // final secureStorage = FlutterSecureStorage();
    // return await secureStorage.read(key: 'auth_token');

    return null;
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle the response
    // For example, check if the token needs to be refreshed
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle authentication errors
    if (err.response?.statusCode == 401) {
      // Todo: Handle token expiration and refresh
      // For example:
      // _refreshToken().then((_) {
      //   // Retry the request with the new token
      //   _retryRequest(err.requestOptions, handler);
      // }).catchError((_) {
      //   // Token refresh failed, handle logout
      //   _handleLogout();
      //   handler.next(err);
      // });
    } else {
      handler.next(err);
    }
  }

  /// Retry a request with updated options
  Future<void> _retryRequest(
    RequestOptions requestOptions,
    ErrorInterceptorHandler handler,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );

    final token = _getToken();

    if (token != null && token.isNotEmpty) {
      options.headers?['Authorization'] = 'Bearer $token';
    }

    try {
      final dio = Dio();
      final response = await dio.request<dynamic>(
        requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options,
      );

      handler.resolve(response);
    } catch (e) {
      handler.next(DioException(
        requestOptions: requestOptions,
        error: e.toString(),
      ));
    }
  }
}
