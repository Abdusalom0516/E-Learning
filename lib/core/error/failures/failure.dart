import 'package:equatable/equatable.dart';

/// Base failure class for domain layer
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

/// Server-related failure
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Cache-related failure
class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Network-related failure
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Validation-related failure
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    this.fieldErrors,
  });

  @override
  List<Object> get props => [message, if (fieldErrors != null) fieldErrors!];
}

/// Authentication-related failure
class AuthFailure extends Failure {
  const AuthFailure({required super.message});
}

/// Resource not found failure
class NotFoundFailure extends Failure {
  const NotFoundFailure({required super.message});
}

/// Permission-related failure
class PermissionFailure extends Failure {
  const PermissionFailure({required super.message});
}

/// Timeout-related failure
class TimeoutFailure extends Failure {
  const TimeoutFailure({required super.message});
}

/// Unexpected error failure
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({required super.message});
}

/// Input data-related failure
class InputFailure extends Failure {
  const InputFailure({required super.message});
}
