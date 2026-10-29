/// `NetworkException` represents an exception that occurs during network operations.
/// It extends `BaseException` to provide a customizable error message specific to network-related errors.

import 'package:bethel_farm/data/network/exceptions/base_exception.dart';

class NetworkException extends BaseException {
  NetworkException(String message) : super(message: message);
}
