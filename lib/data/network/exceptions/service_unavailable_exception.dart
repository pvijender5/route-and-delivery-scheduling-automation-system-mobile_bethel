/// `ServiceUnavailableException` represents an exception that occurs when the service
/// is temporarily unavailable. It extends `BaseApiException` and provides a specific
/// HTTP status code (`HttpStatus.serviceUnavailable`) along with a customizable error message.
import 'dart:io';

import 'package:bethel_farm/data/network/exceptions/base_api_exception.dart';

class ServiceUnavailableException extends BaseApiException {
  ServiceUnavailableException(String message)
      : super(httpCode: HttpStatus.serviceUnavailable, message: message, status: "");
}
