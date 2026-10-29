/// `UnauthorizedException` represents an exception that occurs when a request
/// is made without proper authorization. It extends `BaseApiException` and provides
/// a specific HTTP status code (`HttpStatus.unauthorized`) along with a customizable
/// error message and status.

import 'dart:io';

import 'package:bethel_farm/data/network/exceptions/base_api_exception.dart';

class UnauthorizedException extends BaseApiException {
  UnauthorizedException(String message)
      : super(httpCode: HttpStatus.unauthorized, message: message, status: "unauthorized");
}
