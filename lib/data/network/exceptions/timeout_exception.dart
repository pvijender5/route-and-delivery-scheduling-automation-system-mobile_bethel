/// `TimeoutException` represents an exception that occurs when a network operation
/// exceeds the allowed time limit. It extends `BaseException` to provide a customizable
/// error message specific to timeout-related errors.
import 'package:bethel_farm/data/network/exceptions/base_exception.dart';

class TimeoutException extends BaseException {
  TimeoutException(String message) : super(message: message);
}
