/// `BaseApiException` is an abstract class that represents API-related exceptions.
/// It extends `AppException` and includes additional fields such as `httpCode`
/// and `status` to provide more context about the API error.

import 'package:bethel_farm/data/network/exceptions/app_exception.dart';

abstract class BaseApiException extends AppException {
  final int httpCode;
  final String status;

  BaseApiException({this.httpCode = -1, this.status = "", String message = ""}) : super(message: message);
}
