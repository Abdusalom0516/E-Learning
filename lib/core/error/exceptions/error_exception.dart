import 'package:equatable/equatable.dart';

/// Base exception class for application errors
class ErrorException extends Equatable implements Exception {
  final String? message;

  const ErrorException({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Authentication related exception
class AuthException extends ErrorException {
  const AuthException([String? message])
      : super(message: message ?? 'Authentication error occurred');
}

/// Server related exception
class ServerException extends ErrorException {
  const ServerException([String? message])
      : super(message: message ?? 'Server error occurred');
}

/// Unauthorized access exception
class UnauthorizedException extends ErrorException {
  const UnauthorizedException([String? message])
      : super(message: message ?? 'Unauthorized access');
}

/// Resource not found exception
class NotFoundException extends ErrorException {
  const NotFoundException([String? message])
      : super(message: message ?? 'Resource not found');
}

/// Conflict exception for duplicate resources
class ConflictException extends ErrorException {
  const ConflictException([String? message])
      : super(message: message ?? 'Conflict occurred');
}

/// Internal server error exception
class InternalServerErrorException extends ErrorException {
  const InternalServerErrorException([String? message])
      : super(message: message ?? 'Internal server error occurred');
}

/// No internet connection exception
class NoInternetConnectionException extends ErrorException {
  const NoInternetConnectionException([String? message])
      : super(message: message ?? 'No internet connection');
}

/// Cache related exception
class CacheException extends ErrorException {
  const CacheException([String? message])
      : super(message: message ?? 'Cache error occurred');
}

/// Format exception for data parsing errors
class FormatErrorException extends ErrorException {
  const FormatErrorException([String? message])
      : super(message: message ?? 'Format error occurred');
}

/// Validation exception for input validation errors
class ValidationException extends ErrorException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    String? message,
    this.fieldErrors,
  }) : super(message: message ?? 'Validation error occurred');

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// Timeout exception for request timeouts
class TimeoutException extends ErrorException {
  const TimeoutException([String? message])
      : super(message: message ?? 'Request timeout');
}

/// Cancellation exception for cancelled requests
class CancellationException extends ErrorException {
  const CancellationException([String? message])
      : super(message: message ?? 'Request cancelled');
}
