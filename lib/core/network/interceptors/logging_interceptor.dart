import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Interceptor for logging requests, responses, and errors
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final method = options.method.toUpperCase();
      final url = options.uri.toString();

      print('\n--> $method $url');

      if (options.headers.isNotEmpty) {
        print('Headers:');
        options.headers.forEach((key, value) => print('$key: $value'));
      }

      if (options.data != null) {
        print('Request Body:');
        _prettyPrintJson(options.data);
      }

      if (options.queryParameters.isNotEmpty) {
        print('Query Parameters:');
        options.queryParameters.forEach((key, value) => print('$key: $value'));
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      final statusCode = response.statusCode;
      final method = response.requestOptions.method.toUpperCase();
      final url = response.requestOptions.uri.toString();

      print('\n<-- $statusCode $method $url');

      if (response.headers.map.isNotEmpty) {
        print('Headers:');
        response.headers
            .forEach((name, values) => print('$name: ${values.join(',')}'));
      }

      print('Response Body:');
      _prettyPrintJson(response.data);
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final statusCode = err.response?.statusCode;
      final method = err.requestOptions.method.toUpperCase();
      final url = err.requestOptions.uri.toString();

      print('\n<-- Error $statusCode $method $url');
      print('Error: ${err.error}');

      if (err.response != null) {
        print('Response Body:');
        _prettyPrintJson(err.response!.data);
      }
    }

    super.onError(err, handler);
  }

  /// Helper method to pretty print JSON data
  void _prettyPrintJson(dynamic data) {
    if (data == null) {
      print('null');
      return;
    }

    if (data is Map || data is List) {
      try {
        // Try to use json.encode for nice formatting
        // but this might not work for all data types
        print(data.toString());
      } catch (e) {
        print(data.toString());
      }
    } else {
      print(data.toString());
    }
  }
}
