abstract class Failure {
  final String message;

  const Failure(this.message);
}

/// VALIDATION ERROR
class ValidationFailure extends Failure {
  const ValidationFailure(String message) : super(message);
}

/// AUTH ERROR
class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}

/// STORAGE / DATABASE ERROR
class StorageFailure extends Failure {
  const StorageFailure(String message) : super(message);
}

/// UNKNOWN ERROR
class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}
