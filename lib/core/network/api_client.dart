import 'dart:io';
import 'package:dio/dio.dart';

import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'models/api_response.dart';
import 'exceptions/network_exceptions.dart';

/// API client for handling network requests
class ApiClient {
  late final Dio _dio;

  /// Base URL for all API requests
  final String baseUrl;

  /// Default timeout in milliseconds
  final int timeout;

  /// Whether to use authentication interceptor
  final bool useAuth;

  /// API client constructor
  ApiClient({
    required this.baseUrl,
    this.timeout = 30000,
    this.useAuth = true,
  }) {
    _initDio();
  }

  /// Initialize Dio client with base options and interceptors
  void _initDio() {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: timeout),
      receiveTimeout: Duration(milliseconds: timeout),
      responseType: ResponseType.json,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    _dio = Dio(options);

    // Add interceptors
    _dio.interceptors.add(LoggingInterceptor());

    if (useAuth) {
      _dio.interceptors.add(AuthInterceptor());
    }
  }

  /// GET request
  Future<ApiResponse<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// POST request
  Future<ApiResponse<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// PUT request
  Future<ApiResponse<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// DELETE request
  Future<ApiResponse<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// PATCH request
  Future<ApiResponse<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.patch<dynamic>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return ApiResponse<T>.fromResponse(response);
    } catch (e) {
      return ApiResponse<T>.withError(_handleError(e));
    }
  }

  /// Download file
  Future<ApiResponse<String>> download(
    String url,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    Options? options,
  }) async {
    try {
      final response = await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        options: options,
      );

      return ApiResponse<String>.fromResponse(response, data: savePath);
    } catch (e) {
      return ApiResponse<String>.withError(_handleError(e));
    }
  }

  /// Handle all possible errors from Dio
  NetworkExceptions _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return const NetworkExceptions.requestTimeout();
        case DioExceptionType.sendTimeout:
          return const NetworkExceptions.sendTimeout();
        case DioExceptionType.receiveTimeout:
          return const NetworkExceptions.receiveTimeout();
        case DioExceptionType.cancel:
          return const NetworkExceptions.requestCancelled();
        case DioExceptionType.badResponse:
          return _handleBadResponse(error);
        case DioExceptionType.connectionError:
          return const NetworkExceptions.noInternetConnection();
        case DioExceptionType.badCertificate:
          return const NetworkExceptions.badCertificate();
        default:
          return const NetworkExceptions.unexpectedError();
      }
    } else if (error is SocketException) {
      return const NetworkExceptions.noInternetConnection();
    } else {
      return const NetworkExceptions.unexpectedError();
    }
  }

  /// Handle bad responses with different status codes
  NetworkExceptions _handleBadResponse(DioException error) {
    if (error.response == null) {
      return const NetworkExceptions.unexpectedError();
    }

    switch (error.response!.statusCode) {
      case 400:
        return const NetworkExceptions.badRequest();
      case 401:
        return const NetworkExceptions.unauthorizedRequest();
      case 403:
        return const NetworkExceptions.forbiddenRequest();
      case 404:
        return const NetworkExceptions.notFound();
      case 409:
        return const NetworkExceptions.conflict();
      case 408:
        return const NetworkExceptions.requestTimeout();
      case 500:
        return const NetworkExceptions.internalServerError();
      case 503:
        return const NetworkExceptions.serviceUnavailable();
      default:
        return NetworkExceptions.defaultError(
          'Error with status code: ${error.response!.statusCode}',
        );
    }
  }

  /// Get raw Dio client (use with caution)
  Dio get dio => _dio;
}
