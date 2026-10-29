/// `NotFoundException` represents an exception that occurs when a requested resource
/// is not found. It extends `ApiException` and provides a specific HTTP status code
/// (`HttpStatus.notFound`) along with a customizable error message and status.

import 'dart:io';

import 'package:bethel_farm/data/network/exceptions/api_exception.dart';

class NotFoundException extends ApiException {
  NotFoundException(String message, String status)
      : super(httpCode: HttpStatus.notFound, status: status, message: message);
}
