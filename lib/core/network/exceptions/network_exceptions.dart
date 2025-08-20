import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_exceptions.freezed.dart';

/// Custom exception class to handle various network-related errors
@freezed
class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorizedRequest() = UnauthorizedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.forbidden() = Forbidden;

  const factory NetworkExceptions.forbiddenRequest() = ForbiddenRequest;

  const factory NetworkExceptions.notFound() = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.receiveTimeout() = ReceiveTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  const factory NetworkExceptions.badCertificate() = BadCertificate;

  /// Returns a message associated with the exception type
  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";

    networkExceptions.when(
      requestCancelled: () {
        errorMessage = "Request was cancelled";
      },
      unauthorizedRequest: () {
        errorMessage = "Unauthorized request";
      },
      badRequest: () {
        errorMessage = "Bad request";
      },
      forbidden: () {
        errorMessage = "Forbidden";
      },
      forbiddenRequest: () {
        errorMessage = "Forbidden request";
      },
      notFound: () {
        errorMessage = "The requested resource could not be found";
      },
      methodNotAllowed: () {
        errorMessage = "Method not allowed";
      },
      notAcceptable: () {
        errorMessage = "The request is not acceptable";
      },
      requestTimeout: () {
        errorMessage = "Request timeout";
      },
      receiveTimeout: () {
        errorMessage = "Receive timeout";
      },
      sendTimeout: () {
        errorMessage = "Send timeout";
      },
      conflict: () {
        errorMessage = "Resource conflict";
      },
      internalServerError: () {
        errorMessage = "Internal server error";
      },
      notImplemented: () {
        errorMessage = "Not implemented";
      },
      serviceUnavailable: () {
        errorMessage = "Service unavailable";
      },
      noInternetConnection: () {
        errorMessage = "No internet connection";
      },
      formatException: () {
        errorMessage = "Format exception";
      },
      unableToProcess: () {
        errorMessage = "Unable to process the data";
      },
      defaultError: (String error) {
        errorMessage = error;
      },
      unexpectedError: () {
        errorMessage = "An unexpected error occurred";
      },
      badCertificate: () {
        errorMessage = "Bad certificate";
      },
    );

    return errorMessage;
  }
}
