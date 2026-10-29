import 'dart:convert';

/// Converts a JSON string into a CompleteShipmentDeliveryRes object.
CompleteShipmentDeliveryRes completeShipmentDeliveryResFromJson(String str) =>
    CompleteShipmentDeliveryRes.fromJson(json.decode(str));

/// Converts a CompleteShipmentDeliveryRes object into a JSON string.
String completeShipmentDeliveryResToJson(CompleteShipmentDeliveryRes data) => json.encode(data.toJson());

/// Represents the response for a complete shipment delivery operation.
class CompleteShipmentDeliveryRes {
  String? status; // Status of the response (e.g., success, failure)
  String? message; // Message associated with the response
  Data? data; // Detailed data for the shipment delivery response

  /// Constructor for initializing the CompleteShipmentDeliveryRes object.
  CompleteShipmentDeliveryRes({
    this.status,
    this.message,
    this.data,
  });

  /// Factory method to create a CompleteShipmentDeliveryRes object from a JSON map.
  factory CompleteShipmentDeliveryRes.fromJson(Map<String, dynamic> json) => CompleteShipmentDeliveryRes(
        status: json["status"], // Extract status from the JSON map
        message: json["message"], // Extract message from the JSON map
        data: json["data"] == null ? null : Data.fromJson(json["data"]), // Extract data object if present
      );

  /// Converts the CompleteShipmentDeliveryRes object into a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status, // Add status to the JSON map
        "message": message, // Add message to the JSON map
        "data": data?.toJson(), // Add data object to the JSON map if present
      };
}

/// Represents detailed data for the shipment delivery response.
class Data {
  int? id; // Unique identifier for the shipment delivery
  int? routeId; // Identifier for the route
  int? shipmentId; // Identifier for the shipment
  int? routeNo; // Route number
  String? deliveryStatus; // Status of the delivery (e.g., completed, pending)
  int? isReplacing; // Indicates if the shipment is replacing another
  int? eta; // Estimated time of arrival
  int? load; // Load quantity
  int? duration; // Duration of the route
  int? distance; // Distance covered in the route
  dynamic lat; // Latitude of the delivery location
  dynamic lng; // Longitude of the delivery location
  int? onTimeDelivery; // Indicates if the delivery was on time
  DateTime? arrivedAt; // Timestamp of arrival at the delivery location
  DateTime? deliveredAt; // Timestamp of delivery completion
  List<NoteByDriver>? noteByDriver; // Notes provided by the driver
  dynamic fhfPointNote; // Notes related to FHF points
  dynamic customerRating; // Rating provided by the customer
  dynamic customerFeedback; // Feedback provided by the customer
  int? pQuantity; // Quantity of products delivered
  int? rQuantity; // Quantity of products returned
  int? tQuantity; // Total quantity handled
  int? loadingComplete; // Indicates if loading is complete
  DateTime? createdAt; // Timestamp of creation
  DateTime? updatedAt; // Timestamp of last update
  List<DeliveryProof>? deliveryProofs; // List of delivery proofs (e.g., images, documents)

  /// Constructor for initializing the Data object.
  Data({
    this.id,
    this.routeId,
    this.shipmentId,
    this.routeNo,
    this.deliveryStatus,
    this.isReplacing,
    this.eta,
    this.load,
    this.duration,
    this.distance,
    this.lat,
    this.lng,
    this.onTimeDelivery,
    this.arrivedAt,
    this.deliveredAt,
    this.noteByDriver,
    this.fhfPointNote,
    this.customerRating,
    this.customerFeedback,
    this.pQuantity,
    this.rQuantity,
    this.tQuantity,
    this.loadingComplete,
    this.createdAt,
    this.updatedAt,
    this.deliveryProofs,
  });

  /// Factory method to create a Data object from a JSON map.
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"], // Extract ID from the JSON map
        routeId: json["route_id"], // Extract route ID from the JSON map
        shipmentId: json["shipment_id"], // Extract shipment ID from the JSON map
        routeNo: json["route_no"], // Extract route number from the JSON map
        deliveryStatus: json["delivery_status"], // Extract delivery status from the JSON map
        isReplacing: json["is_replacing"], // Extract replacing status from the JSON map
        eta: json["eta"], // Extract ETA from the JSON map
        load: json["load"], // Extract load quantity from the JSON map
        duration: json["duration"], // Extract duration from the JSON map
        distance: json["distance"], // Extract distance from the JSON map
        lat: json["lat"], // Extract latitude from the JSON map
        lng: json["lng"], // Extract longitude from the JSON map
        onTimeDelivery: json["on_time_delivery"], // Extract on-time delivery status from the JSON map
        arrivedAt: json["arrived_at"] == null ? null : DateTime.parse(json["arrived_at"]), // Parse arrival timestamp
        deliveredAt:
            json["delivered_at"] == null ? null : DateTime.parse(json["delivered_at"]), // Parse delivery timestamp
        noteByDriver: json["note_by_driver"] == null
            ? []
            : List<NoteByDriver>.from(
                json["note_by_driver"]!.map((x) => NoteByDriver.fromJson(x))), // Extract driver notes
        fhfPointNote: json["fhf_point_note"], // Extract FHF point notes from the JSON map
        customerRating: json["customer_rating"], // Extract customer rating from the JSON map
        customerFeedback: json["customer_feedback"], // Extract customer feedback from the JSON map
        pQuantity: json["P_quantity"], // Extract delivered quantity from the JSON map
        rQuantity: json["R_quantity"], // Extract returned quantity from the JSON map
        tQuantity: json["T_quantity"], // Extract total quantity from the JSON map
        loadingComplete: json["loading_complete"], // Extract loading complete status from the JSON map
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]), // Parse creation timestamp
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]), // Parse update timestamp
        deliveryProofs: json["delivery_proofs"] == null
            ? []
            : List<DeliveryProof>.from(
                json["delivery_proofs"]!.map((x) => DeliveryProof.fromJson(x))), // Extract delivery proofs
      );

  /// Converts the Data object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "route_id": routeId, // Add route ID to the JSON map
        "shipment_id": shipmentId, // Add shipment ID to the JSON map
        "route_no": routeNo, // Add route number to the JSON map
        "delivery_status": deliveryStatus, // Add delivery status to the JSON map
        "is_replacing": isReplacing, // Add replacing status to the JSON map
        "eta": eta, // Add ETA to the JSON map
        "load": load, // Add load quantity to the JSON map
        "duration": duration, // Add duration to the JSON map
        "distance": distance, // Add distance to the JSON map
        "lat": lat, // Add latitude to the JSON map
        "lng": lng, // Add longitude to the JSON map
        "on_time_delivery": onTimeDelivery, // Add on-time delivery status to the JSON map
        "arrived_at": arrivedAt?.toIso8601String(), // Add arrival timestamp to the JSON map
        "delivered_at": deliveredAt?.toIso8601String(), // Add delivery timestamp to the JSON map
        "note_by_driver": noteByDriver == null
            ? []
            : List<dynamic>.from(noteByDriver!.map((x) => x.toJson())), // Add driver notes to the JSON map
        "fhf_point_note": fhfPointNote, // Add FHF point notes to the JSON map
        "customer_rating": customerRating, // Add customer rating to the JSON map
        "customer_feedback": customerFeedback, // Add customer feedback to the JSON map
        "P_quantity": pQuantity, // Add delivered quantity to the JSON map
        "R_quantity": rQuantity, // Add returned quantity to the JSON map
        "T_quantity": tQuantity, // Add total quantity to the JSON map
        "loading_complete": loadingComplete, // Add loading complete status to the JSON map
        "created_at": createdAt?.toIso8601String(), // Add creation timestamp to the JSON map
        "updated_at": updatedAt?.toIso8601String(), // Add update timestamp to the JSON map
        "delivery_proofs": deliveryProofs == null
            ? []
            : List<dynamic>.from(deliveryProofs!.map((x) => x.toJson())), // Add delivery proofs to the JSON map
      };
}

/// Represents proof of delivery, such as images or documents.
class DeliveryProof {
  int? id; // Unique identifier for the delivery proof
  int? deliveryDetailId; // Identifier for the delivery detail
  String? attachment; // Attachment file (e.g., image, document)
  String? type; // Type of proof (e.g., image, document)
  DateTime? createdAt; // Timestamp of creation
  DateTime? updatedAt; // Timestamp of last update

  /// Constructor for initializing the DeliveryProof object.
  DeliveryProof({
    this.id,
    this.deliveryDetailId,
    this.attachment,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create a DeliveryProof object from a JSON map.
  factory DeliveryProof.fromJson(Map<String, dynamic> json) => DeliveryProof(
        id: json["id"], // Extract ID from the JSON map
        deliveryDetailId: json["delivery_detail_id"], // Extract delivery detail ID from the JSON map
        attachment: json["attachment"], // Extract attachment file from the JSON map
        type: json["type"], // Extract type of proof from the JSON map
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]), // Parse creation timestamp
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]), // Parse update timestamp
      );

  /// Converts the DeliveryProof object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "delivery_detail_id": deliveryDetailId, // Add delivery detail ID to the JSON map
        "attachment": attachment, // Add attachment file to the JSON map
        "type": type, // Add type of proof to the JSON map
        "created_at": createdAt?.toIso8601String(), // Add creation timestamp to the JSON map
        "updated_at": updatedAt?.toIso8601String(), // Add update timestamp to the JSON map
      };
}

/// Represents notes provided by the driver during delivery.
class NoteByDriver {
  String? text; // Text of the note
  String? scope; // Scope of the note (e.g., general, specific)
  String? title; // Title of the note

  /// Constructor for initializing the NoteByDriver object.
  NoteByDriver({
    this.text,
    this.scope,
    this.title,
  });

  /// Factory method to create a NoteByDriver object from a JSON map.
  factory NoteByDriver.fromJson(Map<String, dynamic> json) => NoteByDriver(
        text: json["text"], // Extract text from the JSON map
        scope: json["scope"], // Extract scope from the JSON map
        title: json["title"], // Extract title from the JSON map
      );

  /// Converts the NoteByDriver object into a JSON map.
  Map<String, dynamic> toJson() => {
        "text": text, // Add text to the JSON map
        "scope": scope, // Add scope to the JSON map
        "title": title, // Add title to the JSON map
      };
}
