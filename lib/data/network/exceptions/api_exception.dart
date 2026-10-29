/// `ApiException` represents an exception that occurs during API calls.
/// It extends `BaseApiException` and provides additional context such as
/// HTTP status code, status message, and an optional error message.
import 'package:bethel_farm/data/network/exceptions/base_api_exception.dart';

class ApiException extends BaseApiException {
  ApiException({
    required int httpCode,
    required String status,
    String message = "",
  }) : super(httpCode: httpCode, status: status, message: message);
}
