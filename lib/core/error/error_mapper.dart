import 'exceptions/error_exception.dart';
import 'failures/failure.dart';

/// Maps exceptions to failures for use in repositories
class ErrorMapper {
  /// Maps an exception to the appropriate failure
  static Failure mapExceptionToFailure(Exception exception) {
    if (exception is ErrorException) {
      return _mapErrorExceptionToFailure(exception);
    }

    return UnexpectedFailure(
      message: exception.toString(),
    );
  }

  /// Maps an ErrorException to the appropriate failure
  static Failure _mapErrorExceptionToFailure(ErrorException exception) {
    final message = exception.message ?? 'An error occurred';

    if (exception is ServerException) {
      return ServerFailure(message: message);
    } else if (exception is CacheException) {
      return CacheFailure(message: message);
    } else if (exception is NoInternetConnectionException) {
      return NetworkFailure(message: message);
    } else if (exception is AuthException ||
        exception is UnauthorizedException) {
      return AuthFailure(message: message);
    } else if (exception is ValidationException) {
      return ValidationFailure(
        message: message,
        fieldErrors: (exception).fieldErrors,
      );
    } else if (exception is NotFoundException) {
      return NotFoundFailure(message: message);
    } else if (exception is TimeoutException) {
      return TimeoutFailure(message: message);
    }

    return UnexpectedFailure(message: message);
  }

  /// Gets a user-friendly error message from a failure
  static String getErrorMessage(Failure failure) {
    return failure.message;
  }
}
