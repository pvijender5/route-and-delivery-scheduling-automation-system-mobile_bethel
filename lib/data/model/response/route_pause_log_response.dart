import 'dart:convert';

/// Converts a JSON string into a RoutePauseLogResponse object.
RoutePauseLogResponse routePauseLogResponseFromJson(String str) => RoutePauseLogResponse.fromJson(json.decode(str));

/// Converts a RoutePauseLogResponse object into a JSON string.
String routePauseLogResponseToJson(RoutePauseLogResponse data) => json.encode(data.toJson());

/// Represents the response for a route pause log operation.
class RoutePauseLogResponse {
  String? status; // Status of the response (e.g., success, failure)
  String? message; // Message associated with the response
  RoutePauseLog? data; // Detailed data for the route pause log

  /// Constructor for initializing the RoutePauseLogResponse object.
  RoutePauseLogResponse({
    this.status,
    this.message,
    this.data,
  });

  /// Factory method to create a RoutePauseLogResponse object from a JSON map.
  factory RoutePauseLogResponse.fromJson(Map<String, dynamic> json) => RoutePauseLogResponse(
        status: json["status"], // Extract status from the JSON map
        message: json["message"], // Extract message from the JSON map
        data: json["data"] == null
            ? null
            : RoutePauseLog.fromJson(json["data"]), // Extract route pause log data if present
      );

  /// Converts the RoutePauseLogResponse object into a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status, // Add status to the JSON map
        "message": message, // Add message to the JSON map
        "data": data?.toJson(), // Add route pause log data to the JSON map if present
      };
}

/// Represents detailed data for a route pause log.
class RoutePauseLog {
  int? id; // Unique identifier for the route pause log
  int? routeId; // Identifier for the route
  DateTime? startTime; // Start time of the pause
  DateTime? endTime; // End time of the pause
  int? duration; // Duration of the pause in minutes
  dynamic deliveryDetailId; // Identifier for the delivery detail associated with the pause
  String? breakReason; // Reason for the pause
  dynamic note; // Additional notes about the pause
  DateTime? createdAt; // Timestamp of creation
  DateTime? updatedAt; // Timestamp of last update

  /// Constructor for initializing the RoutePauseLog object.
  RoutePauseLog({
    this.id,
    this.routeId,
    this.startTime,
    this.endTime,
    this.duration,
    this.deliveryDetailId,
    this.breakReason,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create a RoutePauseLog object from a JSON map.
  factory RoutePauseLog.fromJson(Map<String, dynamic> json) => RoutePauseLog(
        id: json["id"], // Extract ID from the JSON map
        routeId: json["route_id"], // Extract route ID from the JSON map
        startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]), // Parse start time
        endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]), // Parse end time
        duration: json["duration"], // Extract duration from the JSON map
        deliveryDetailId: json["delivery_detail_id"], // Extract delivery detail ID from the JSON map
        breakReason: json["break_reason"], // Extract break reason from the JSON map
        note: json["note"], // Extract additional notes from the JSON map
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]), // Parse creation timestamp
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]), // Parse update timestamp
      );

  /// Converts the RoutePauseLog object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "route_id": routeId, // Add route ID to the JSON map
        "start_time": startTime?.toIso8601String(), // Add start time to the JSON map
        "end_time": endTime?.toIso8601String(), // Add end time to the JSON map
        "duration": duration, // Add duration to the JSON map
        "delivery_detail_id": deliveryDetailId, // Add delivery detail ID to the JSON map
        "break_reason": breakReason, // Add break reason to the JSON map
        "note": note, // Add additional notes to the JSON map
        "created_at": createdAt?.toIso8601String(), // Add creation timestamp to the JSON map
        "updated_at": updatedAt?.toIso8601String(), // Add update timestamp to the JSON map
      };
}
