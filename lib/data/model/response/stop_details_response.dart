import 'dart:convert';

/// Converts a JSON string into a StopDetailsResponse object.
StopDetailsResponse stopDetailsResponseFromJson(String str) => StopDetailsResponse.fromJson(json.decode(str));

/// Converts a StopDetailsResponse object into a JSON string.
String stopDetailsResponseToJson(StopDetailsResponse data) => json.encode(data.toJson());

/// Represents the response for stop details.
class StopDetailsResponse {
  String? status; // Status of the response (e.g., success, failure)
  String? message; // Message associated with the response
  Data? data; // Detailed data for the stop

  /// Constructor for initializing the StopDetailsResponse object.
  StopDetailsResponse({
    this.status,
    this.message,
    this.data,
  });

  /// Factory method to create a StopDetailsResponse object from a JSON map.
  factory StopDetailsResponse.fromJson(Map<String, dynamic> json) => StopDetailsResponse(
        status: json["status"], // Extract status from the JSON map
        message: json["message"], // Extract message from the JSON map
        data: json["data"] == null ? null : Data.fromJson(json["data"]), // Extract stop data if present
      );

  /// Converts the StopDetailsResponse object into a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status, // Add status to the JSON map
        "message": message, // Add message to the JSON map
        "data": data?.toJson(), // Add stop data to the JSON map if present
      };
}

/// Represents detailed data for a stop.
class Data {
  int? id; // Unique identifier for the stop
  int? shipmentId; // Identifier for the shipment
  int? routeId; // Identifier for the route
  int? routeNo; // Route number
  int? eta; // Estimated time of arrival
  int? duration; // Duration of the stop
  String? deliveryStatus; // Status of the delivery (e.g., completed, pending)
  List<NoteByDriver>? noteByDriver; // Notes provided by the driver
  int? pQuantity; // Quantity of products delivered
  int? rQuantity; // Quantity of products returned
  int? tQuantity; // Total quantity handled
  int? distance; // Distance covered during the stop
  DateTime? arrivedAt; // Timestamp of arrival at the stop
  DateTime? undelivered_at; // Timestamp of undelivered status
  DateTime? delivered_at; // Timestamp of delivery completion
  DateTime? canceled_at; // Timestamp of cancellation
  int? loadingComplete; // Indicates if loading is complete
  Shipment? shipment; // Shipment details associated with the stop
  Routes? routes; // Route details associated with the stop
  List<DeliveryProof>? deliveryProofs; // List of delivery proofs (e.g., images, documents)

  /// Constructor for initializing the Data object.
  Data({
    this.id,
    this.shipmentId,
    this.routeId,
    this.routeNo,
    this.eta,
    this.duration,
    this.deliveryStatus,
    this.noteByDriver,
    this.pQuantity,
    this.rQuantity,
    this.tQuantity,
    this.distance,
    this.arrivedAt,
    this.undelivered_at,
    this.delivered_at,
    this.canceled_at,
    this.loadingComplete,
    this.shipment,
    this.routes,
    this.deliveryProofs,
  });

  /// Factory method to create a Data object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"], // Extract ID from the JSON map
        shipmentId: json["shipment_id"], // Extract shipment ID from the JSON map
        routeId: json["route_id"], // Extract route ID from the JSON map
        routeNo: json["route_no"], // Extract route number from the JSON map
        eta: json["eta"], // Extract ETA from the JSON map
        duration: json["duration"], // Extract duration from the JSON map
        deliveryStatus: json["delivery_status"], // Extract delivery status from the JSON map
        noteByDriver: json["note_by_driver"] == null
            ? []
            : List<NoteByDriver>.from(
                json["note_by_driver"]!.map((x) => NoteByDriver.fromJson(x))), // Extract driver notes
        pQuantity: json["P_quantity"], // Extract delivered quantity from the JSON map
        rQuantity: json["R_quantity"], // Extract returned quantity from the JSON map
        tQuantity: json["T_quantity"], // Extract total quantity from the JSON map
        distance: json["distance"], // Extract distance from the JSON map
        arrivedAt: json["arrived_at"] == null ? null : DateTime.parse(json["arrived_at"]), // Parse arrival timestamp
        undelivered_at: json["undelivered_at"] == null
            ? null
            : DateTime.parse(json["undelivered_at"]), // Parse undelivered timestamp
        delivered_at:
            json["delivered_at"] == null ? null : DateTime.parse(json["delivered_at"]), // Parse delivered timestamp
        canceled_at:
            json["canceled_at"] == null ? null : DateTime.parse(json["canceled_at"]), // Parse canceled timestamp
        loadingComplete: json["loading_complete"], // Extract loading complete status from the JSON map
        shipment: json["shipment"] == null ? null : Shipment.fromJson(json["shipment"]), // Extract shipment details
        routes: json["routes"] == null ? null : Routes.fromJson(json["routes"]), // Extract route details
        deliveryProofs: json["delivery_proofs"] == null
            ? []
            : List<DeliveryProof>.from(
                json["delivery_proofs"]!.map((x) => DeliveryProof.fromJson(x))), // Extract delivery proofs
      );

  /// Converts the Data object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "shipment_id": shipmentId, // Add shipment ID to the JSON map
        "route_id": routeId, // Add route ID to the JSON map
        "route_no": routeNo, // Add route number to the JSON map
        "eta": eta, // Add ETA to the JSON map
        "duration": duration, // Add duration to the JSON map
        "delivery_status": deliveryStatus, // Add delivery status to the JSON map
        "note_by_driver": noteByDriver == null
            ? []
            : List<dynamic>.from(noteByDriver!.map((x) => x.toJson())), // Add driver notes to the JSON map
        "P_quantity": pQuantity, // Add delivered quantity to the JSON map
        "R_quantity": rQuantity, // Add returned quantity to the JSON map
        "T_quantity": tQuantity, // Add total quantity to the JSON map
        "distance": distance, // Add distance to the JSON map
        "arrived_at": arrivedAt?.toIso8601String(), // Add arrival timestamp to the JSON map
        "undelivered_at": undelivered_at?.toIso8601String(), // Add undelivered timestamp to the JSON map
        "delivered_at": delivered_at?.toIso8601String(), // Add delivered timestamp to the JSON map
        "canceled_at": canceled_at?.toIso8601String(), // Add canceled timestamp to the JSON map
        "loading_complete": loadingComplete, // Add loading complete status to the JSON map
        "shipment": shipment?.toJson(), // Add shipment details to the JSON map
        "routes": routes?.toJson(), // Add route details to the JSON map
        "delivery_proofs": deliveryProofs == null
            ? []
            : List<dynamic>.from(deliveryProofs!.map((x) => x.toJson())), // Add delivery proofs to the JSON map
      };
}
