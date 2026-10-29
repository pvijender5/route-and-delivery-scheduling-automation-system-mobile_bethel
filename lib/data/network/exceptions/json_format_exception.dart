/// `JsonFormatException` represents an exception that occurs when there is an issue
/// with the format of JSON data. It extends `BaseException` to provide a customizable
/// error message specific to JSON formatting errors.

import 'package:bethel_farm/data/network/exceptions/base_exception.dart';

class JsonFormatException extends BaseException {
  JsonFormatException(String message) : super(message: message);
}
