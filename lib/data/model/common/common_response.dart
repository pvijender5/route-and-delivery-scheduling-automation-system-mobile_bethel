/// A class representing a common response structure with a status and message.
///
/// The `CommonResponse` class is used to parse and serialize JSON data for API responses.
/// It contains two fields:
/// - `status`: A string indicating the status of the response.
/// - `message`: A string containing the message associated with the response.

class CommonResponse {
  String status;
  String message;

  CommonResponse({required this.status, required this.message});

  factory CommonResponse.fromJson(Map<String, dynamic> json) =>
      CommonResponse(status: json["status"], message: json["message"]);

  Map<String, dynamic> toJson() => {"status": status, "message": message};
}
