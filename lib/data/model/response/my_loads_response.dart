import 'dart:convert';

/// Converts a JSON string into a MyLoadsResponse object.
MyLoadsResponse myLoadsResponseFromJson(String str) => MyLoadsResponse.fromJson(json.decode(str));

/// Converts a MyLoadsResponse object into a JSON string.
String myLoadsResponseToJson(MyLoadsResponse data) => json.encode(data.toJson());

/// Represents the response for the "My Loads" feature.
class MyLoadsResponse {
  String? status; // Status of the response (e.g., success, failure)
  String? message; // Message associated with the response
  List<RouteDetailData>? data; // List of route details
  int? count; // Total count of routes

  /// Constructor for initializing the MyLoadsResponse object.
  MyLoadsResponse({
    this.status,
    this.message,
    this.data,
    this.count,
  });

  /// Factory method to create a MyLoadsResponse object from a JSON map.
  factory MyLoadsResponse.fromJson(Map<String, dynamic> json) => MyLoadsResponse(
        status: json["status"], // Extract status from the JSON map
        message: json["message"], // Extract message from the JSON map
        data: json["data"] == null
            ? []
            : List<RouteDetailData>.from(
                json["data"]!.map((x) => RouteDetailData.fromJson(x))), // Extract route details
        count: json.containsKey("count") ? json["count"] : null, // Extract count if present
      );

  /// Converts the MyLoadsResponse object into a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status, // Add status to the JSON map
        "message": message, // Add message to the JSON map
        "data":
            data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())), // Add route details to the JSON map
        "count": count, // Add count to the JSON map
      };
}

/// Converts a JSON string into a CarrierOwnerMyLoadResponse object.
CarrierOwnerMyLoadResponse carrierOwnerMyLoadResponseFromJson(String str) =>
    CarrierOwnerMyLoadResponse.fromJson(json.decode(str));

/// Converts a CarrierOwnerMyLoadResponse object into a JSON string.
String carrierOwnerMyLoadResponseToJson(CarrierOwnerMyLoadResponse data) => json.encode(data.toJson());

/// Represents the response for the carrier owner's "My Loads" feature.
class CarrierOwnerMyLoadResponse {
  final String? status; // Status of the response
  final String? message; // Message associated with the response
  final List<RouteDetailData>? carrierownerdata; // List of routes for the carrier owner
  final List<RouteDetailData>? subDriverRoutes; // List of routes for sub-drivers

  /// Constructor for initializing the CarrierOwnerMyLoadResponse object.
  CarrierOwnerMyLoadResponse({
    this.status,
    this.message,
    this.carrierownerdata,
    this.subDriverRoutes,
  });

  /// Factory method to create a CarrierOwnerMyLoadResponse object from a JSON map.
  factory CarrierOwnerMyLoadResponse.fromJson(Map<String, dynamic> json) => CarrierOwnerMyLoadResponse(
        status: json["status"], // Extract status from the JSON map
        message: json["message"], // Extract message from the JSON map
        carrierownerdata: json["carrierownerdata"] == null
            ? []
            : List<RouteDetailData>.from(
                json["carrierownerdata"]!.map((x) => RouteDetailData.fromJson(x))), // Extract carrier owner data
        subDriverRoutes: json["subDriverRoutes"] == null
            ? []
            : List<RouteDetailData>.from(
                json["subDriverRoutes"]!.map((x) => RouteDetailData.fromJson(x))), // Extract sub-driver routes
      );

  /// Converts the CarrierOwnerMyLoadResponse object into a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status, // Add status to the JSON map
        "message": message, // Add message to the JSON map
        "carrierownerdata": carrierownerdata == null
            ? []
            : List<dynamic>.from(carrierownerdata!.map((x) => x.toJson())), // Add carrier owner data
        "subDriverRoutes": subDriverRoutes == null
            ? []
            : List<dynamic>.from(subDriverRoutes!.map((x) => x.toJson())), // Add sub-driver routes
      };
}

/// Represents detailed data for a route.
class RouteDetailData {
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
  int? loadingUser; // ID of the user responsible for loading
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
  Truck? truck; // Truck details associated with the route
  Driver? driver; // Driver details associated with the route
  List<ShipmentDelivery>? shipmentDeliveries; // List of shipment deliveries associated with the route

  /// Constructor for initializing the RouteDetailData object.
  RouteDetailData({
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
    this.loadingUser,
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
    this.truck,
    this.driver,
    this.shipmentDeliveries,
  });

  /// Factory method to create a RouteDetailData object from a JSON map.
  factory RouteDetailData.fromJson(Map<String, dynamic> json) => RouteDetailData(
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
        recommendedPrice: json["recommended_price"]?.toDouble(), // Extract recommended price from the JSON map
        totalPrice: json["total_price"], // Extract total price from the JSON map
        loadingBy: json["loading_by"], // Extract loading person from the JSON map
        loadingUser: json["loading_user"], // Extract loading user ID from the JSON map
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
        truck: json["truck"] == null ? null : Truck.fromJson(json["truck"]), // Extract truck details
        driver: json["driver"] == null ? null : Driver.fromJson(json["driver"]), // Extract driver details
        shipmentDeliveries: json["shipment_deliveries"] == null
            ? []
            : List<ShipmentDelivery>.from(
                json["shipment_deliveries"]!.map((x) => ShipmentDelivery.fromJson(x))), // Extract shipment deliveries
      );

  /// Converts the RouteDetailData object into a JSON map.
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
        "loading_user": loadingUser, // Add loading user ID to the JSON map
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
        "truck": truck?.toJson(), // Add truck details to the JSON map
        "driver": driver?.toJson(), // Add driver details to the JSON map
        "shipment_deliveries": shipmentDeliveries == null
            ? []
            : List<dynamic>.from(shipmentDeliveries!.map((x) => x.toJson())), // Add shipment deliveries to the JSON map
      };
}
