/// `BaseException` is an abstract class that serves as the base for all exceptions in the application.
/// It implements the `Exception` interface and provides a customizable error message.

abstract class BaseException implements Exception {
  final String message;

  BaseException({this.message = ""});
}
