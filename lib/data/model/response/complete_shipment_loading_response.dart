import 'dart:convert';

import 'package:bethel_farm/data/model/response/pickup_order_detail_response.dart';

/// Converts a JSON string into a CompleteShipmentLoadingResponse object.
CompleteShipmentLoadingResponse completeShipmentLoadingResponseFromJson(String str) =>
    CompleteShipmentLoadingResponse.fromJson(json.decode(str));

/// Converts a CompleteShipmentLoadingResponse object into a JSON string.
String completeShipmentLoadingResponseToJson(CompleteShipmentLoadingResponse data) => json.encode(data.toJson());

/// Represents the response for a complete shipment loading operation.
class CompleteShipmentLoadingResponse {
  String? status; // Status of the response (e.g., success, failure)
  String? message; // Message associated with the response
  Data? data; // Detailed data for the shipment loading response

  /// Constructor for initializing the CompleteShipmentLoadingResponse object.
  CompleteShipmentLoadingResponse({
    this.status,
    this.message,
    this.data,
  });

  /// Factory method to create a CompleteShipmentLoadingResponse object from a JSON map.
  factory CompleteShipmentLoadingResponse.fromJson(Map<String, dynamic> json) => CompleteShipmentLoadingResponse(
        status: json["status"], // Extract status from the JSON map
        message: json["message"], // Extract message from the JSON map
        data: json["data"] == null ? null : Data.fromJson(json["data"]), // Extract data object if present
      );

  /// Converts the CompleteShipmentLoadingResponse object into a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status, // Add status to the JSON map
        "message": message, // Add message to the JSON map
        "data": data?.toJson(), // Add data object to the JSON map if present
      };
}

/// Represents detailed data for the shipment loading response.
class Data {
  int? id; // Unique identifier for the shipment loading
  int? routeId; // Identifier for the route
  int? shipmentId; // Identifier for the shipment
  int? routeNo; // Route number
  String? deliveryStatus; // Status of the delivery (e.g., completed, pending)
  int? isReplacing; // Indicates if the shipment is replacing another
  dynamic eta; // Estimated time of arrival
  int? load; // Load quantity
  int? duration; // Duration of the route
  int? distance; // Distance covered in the route
  dynamic lat; // Latitude of the delivery location
  dynamic lng; // Longitude of the delivery location
  int? onTimeDelivery; // Indicates if the delivery was on time
  String? arrivedAt; // Timestamp of arrival at the delivery location
  List<PropsNotes>? noteByDriver; // Notes provided by the driver
  dynamic fhfPointNote; // Notes related to FHF points
  dynamic customerRating; // Rating provided by the customer
  dynamic customerFeedback; // Feedback provided by the customer
  int? pQuantity; // Quantity of products delivered
  int? rQuantity; // Quantity of products returned
  int? tQuantity; // Total quantity handled
  int? loadingComplete; // Indicates if loading is complete
  DateTime? createdAt; // Timestamp of creation
  DateTime? updatedAt; // Timestamp of last update
  Routes? routes; // Route details associated with the shipment

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
    this.routes,
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
        arrivedAt: json["arrived_at"], // Extract arrival timestamp from the JSON map
        noteByDriver: json["note_by_driver"] == null
            ? []
            : List<PropsNotes>.from(json["note_by_driver"]!.map((x) => PropsNotes.fromJson(x))), // Extract driver notes
        fhfPointNote: json["fhf_point_note"], // Extract FHF point notes from the JSON map
        customerRating: json["customer_rating"], // Extract customer rating from the JSON map
        customerFeedback: json["customer_feedback"], // Extract customer feedback from the JSON map
        pQuantity: json["P_quantity"], // Extract delivered quantity from the JSON map
        rQuantity: json["R_quantity"], // Extract returned quantity from the JSON map
        tQuantity: json["T_quantity"], // Extract total quantity from the JSON map
        loadingComplete: json["loading_complete"], // Extract loading complete status from the JSON map
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]), // Parse creation timestamp
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]), // Parse update timestamp
        routes: json["routes"] == null ? null : Routes.fromJson(json["routes"]), // Extract route details
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
        "arrived_at": arrivedAt, // Add arrival timestamp to the JSON map
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
        "routes": routes?.toJson(), // Add route details to the JSON map
      };
}

/// Represents detailed route information associated with the shipment.
class Routes {
  int? id; // Unique identifier for the route
  DateTime? deliveryDate; // Delivery date for the route
  String? totalStops; // Total number of stops in the route
  String? originPoints; // Origin points of the route
  String? lastDropoffLocation; // Last drop-off location in the route
  int? forkLift; // Indicates if a forklift is used
  int? totalQuantity; // Total quantity of goods loaded
  DateTime? plannedDepartureTime; // Planned departure time for the route
  int? loadedDuration; // Duration of the loading process
  int? totalDuration; // Total duration of the route
  int? totalDistance; // Total distance covered in the route
  int? loadedDistance; // Distance covered during loading
  int? totalLoad; // Total load capacity
  dynamic recommendedPrice; // Recommended price for the route
  dynamic totalPrice; // Total price for the route
  String? loadingBy; // Name of the person responsible for loading
  int? assignedDriver; // ID of the assigned driver
  int? assignedTruck; // ID of the assigned truck
  int? loadingComplete; // Indicates if loading is complete
  String? status; // Status of the route (e.g., active, completed)
  int? isPaused; // Indicates if the route is paused
  int? pQuantity; // Quantity of products delivered
  int? rQuantity; // Quantity of products returned
  int? tQuantity; // Total quantity handled
  String? deliveryInstruction; // Delivery instructions for the route
  dynamic createdBy; // ID of the person who created the route
  dynamic deletedBy; // ID of the person who deleted the route
  dynamic deletedAt; // Timestamp of deletion
  DateTime? createdAt; // Timestamp of creation
  DateTime? updatedAt; // Timestamp of last update

  /// Constructor for initializing the Routes object.
  Routes({
    this.id,
    this.deliveryDate,
    this.totalStops,
    this.originPoints,
    this.lastDropoffLocation,
    this.forkLift,
    this.totalQuantity,
    this.plannedDepartureTime,
    this.loadedDuration,
    this.totalDuration,
    this.totalDistance,
    this.loadedDistance,
    this.totalLoad,
    this.recommendedPrice,
    this.totalPrice,
    this.loadingBy,
    this.assignedDriver,
    this.assignedTruck,
    this.loadingComplete,
    this.status,
    this.isPaused,
    this.pQuantity,
    this.rQuantity,
    this.tQuantity,
    this.deliveryInstruction,
    this.createdBy,
    this.deletedBy,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create a Routes object from a JSON map.
  factory Routes.fromJson(Map<String, dynamic> json) => Routes(
        id: json["id"], // Extract ID from the JSON map
        deliveryDate:
            json["delivery_date"] == null ? null : DateTime.parse(json["delivery_date"]), // Parse delivery date
        totalStops: json["total_stops"], // Extract total stops from the JSON map
        originPoints: json["origin_points"], // Extract origin points from the JSON map
        lastDropoffLocation: json["last_dropoff_location"], // Extract last drop-off location from the JSON map
        forkLift: json["fork_lift"], // Extract forklift usage from the JSON map
        totalQuantity: json["total_quantity"], // Extract total quantity from the JSON map
        plannedDepartureTime: json["planned_departure_time"] == null
            ? null
            : DateTime.parse(json["planned_departure_time"]), // Parse planned departure time
        loadedDuration: json["loaded_duration"], // Extract loaded duration from the JSON map
        totalDuration: json["total_duration"], // Extract total duration from the JSON map
        totalDistance: json["total_distance"], // Extract total distance from the JSON map
        loadedDistance: json["loaded_distance"], // Extract loaded distance from the JSON map
        totalLoad: json["total_load"], // Extract total load from the JSON map
        recommendedPrice: json["recommended_price"], // Extract recommended price from the JSON map
        totalPrice: json["total_price"], // Extract total price from the JSON map
        loadingBy: json["loading_by"], // Extract loading person from the JSON map
        assignedDriver: json["assigned_driver"], // Extract assigned driver ID from the JSON map
        assignedTruck: json["assigned_truck"], // Extract assigned truck ID from the JSON map
        loadingComplete: json["loading_complete"], // Extract loading complete status from the JSON map
        status: json["status"], // Extract route status from the JSON map
        isPaused: json["is_paused"], // Extract paused status from the JSON map
        pQuantity: json["P_quantity"], // Extract delivered quantity from the JSON map
        rQuantity: json["R_quantity"], // Extract returned quantity from the JSON map
        tQuantity: json["T_quantity"], // Extract total quantity from the JSON map
        deliveryInstruction: json["delivery_instruction"], // Extract delivery instructions from the JSON map
        createdBy: json["created_by"], // Extract creator ID from the JSON map
        deletedBy: json["deleted_by"], // Extract deleter ID from the JSON map
        deletedAt: json["deleted_at"], // Extract deletion timestamp from the JSON map
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]), // Parse creation timestamp
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]), // Parse update timestamp
      );

  /// Converts the Routes object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "delivery_date": deliveryDate?.toIso8601String(), // Add delivery date to the JSON map
        "total_stops": totalStops, // Add total stops to the JSON map
        "origin_points": originPoints, // Add origin points to the JSON map
        "last_dropoff_location": lastDropoffLocation, // Add last drop-off location to the JSON map
        "fork_lift": forkLift, // Add forklift usage to the JSON map
        "total_quantity": totalQuantity, // Add total quantity to the JSON map
        "planned_departure_time": plannedDepartureTime?.toIso8601String(), // Add planned departure time to the JSON map
        "loaded_duration": loadedDuration, // Add loaded duration to the JSON map
        "total_duration": totalDuration, // Add total duration to the JSON map
        "total_distance": totalDistance, // Add total distance to the JSON map
        "loaded_distance": loadedDistance, // Add loaded distance to the JSON map
        "total_load": totalLoad, // Add total load to the JSON map
        "recommended_price": recommendedPrice, // Add recommended price to the JSON map
        "total_price": totalPrice, // Add total price to the JSON map
        "loading_by": loadingBy, // Add loading person to the JSON map
        "assigned_driver": assignedDriver, // Add assigned driver ID to the JSON map
        "assigned_truck": assignedTruck, // Add assigned truck ID to the JSON map
        "loading_complete": loadingComplete, // Add loading complete status to the JSON map
        "status": status, // Add route status to the JSON map
        "is_paused": isPaused, // Add paused status to the JSON map
        "P_quantity": pQuantity, // Add delivered quantity to the JSON map
        "R_quantity": rQuantity, // Add returned quantity to the JSON map
        "T_quantity": tQuantity, // Add total quantity to the JSON map
        "delivery_instruction": deliveryInstruction, // Add delivery instructions to the JSON map
        "created_by": createdBy, // Add creator ID to the JSON map
        "deleted_by": deletedBy, // Add deleter ID to the JSON map
        "deleted_at": deletedAt, // Add deletion timestamp to the JSON map
        "created_at": createdAt?.toIso8601String(), // Add creation timestamp to the JSON map
        "updated_at": updatedAt?.toIso8601String(), // Add update timestamp to the JSON map
      };
}
