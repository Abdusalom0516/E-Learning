import 'package:dio/dio.dart';

import '../exceptions/network_exceptions.dart';

/// Status of the API response
enum ApiStatus {
  success,
  error,
  loading,
}

/// Wrapper class for API responses to handle success and error states
class ApiResponse<T> {
  final ApiStatus status;
  final T? data;
  final NetworkExceptions? error;
  final Response<dynamic>? response;

  ApiResponse({
    required this.status,
    this.data,
    this.error,
    this.response,
  });

  /// Create a successful response
  factory ApiResponse.success(T data, {Response<dynamic>? response}) {
    return ApiResponse<T>(
      status: ApiStatus.success,
      data: data,
      response: response,
    );
  }

  /// Create an error response
  factory ApiResponse.withError(NetworkExceptions error) {
    return ApiResponse<T>(
      status: ApiStatus.error,
      error: error,
    );
  }

  /// Create a loading response
  factory ApiResponse.loading() {
    return ApiResponse<T>(status: ApiStatus.loading);
  }

  /// Create a response from a Dio response
  factory ApiResponse.fromResponse(
    Response<dynamic> response, {
    T? data,
  }) {
    return ApiResponse<T>(
      status: ApiStatus.success,
      data: data ?? response.data as T,
      response: response,
    );
  }

  /// Check if the response is successful
  bool get isSuccess => status == ApiStatus.success;

  /// Check if the response has an error
  bool get isError => status == ApiStatus.error;

  /// Check if the response is loading
  bool get isLoading => status == ApiStatus.loading;

  /// Get the HTTP status code if available
  int? get statusCode => response?.statusCode;

  /// Get the error message if available
  String get errorMessage => error != null
      ? NetworkExceptions.getErrorMessage(error!)
      : 'Unknown error';
}
