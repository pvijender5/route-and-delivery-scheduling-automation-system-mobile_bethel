/// `AppException` represents a general application-level exception.
/// It extends `BaseException` and provides a customizable error message.

import 'package:bethel_farm/data/network/exceptions/base_exception.dart';

class AppException extends BaseException {
  AppException({
    String message = "",
  }) : super(message: message);
}
