import 'dart:convert';

/// Converts a JSON string into a DriverDashboardResponse object.
DriverDashboardResponse driverDashboardResponseFromJson(String str) =>
    DriverDashboardResponse.fromJson(json.decode(str));

/// Converts a DriverDashboardResponse object into a JSON string.
String driverDashboardResponseToJson(DriverDashboardResponse data) => json.encode(data.toJson());

/// Represents the response for the driver's dashboard data.
class DriverDashboardResponse {
  String? status; // Status of the response (e.g., success, failure)
  String? message; // Message associated with the response
  String? routeStatus; // Current status of the route
  int? totalShipments; // Total number of shipments handled
  int? totalRoutes; // Total number of routes assigned
  String? onTimeDeliveries; // Percentage of on-time deliveries
  double? otherDriverOnTimeDeliveries; // On-time delivery percentage of other drivers
  dynamic totalEarning; // Total earnings of the driver
  int? totalDistance; // Total distance covered by the driver
  int? totaLoadedDistance; // Total loaded distance covered
  List<RouteDetail>? routeDetails; // List of route details

  /// Constructor for initializing the DriverDashboardResponse object.
  DriverDashboardResponse({
    this.status,
    this.message,
    this.routeStatus,
    this.totalShipments,
    this.totalRoutes,
    this.onTimeDeliveries,
    this.otherDriverOnTimeDeliveries,
    this.totalEarning,
    this.totalDistance,
    this.totaLoadedDistance,
    this.routeDetails,
  });

  /// Factory method to create a DriverDashboardResponse object from a JSON map.
  factory DriverDashboardResponse.fromJson(Map<String, dynamic> json) => DriverDashboardResponse(
        status: json["status"], // Extract status from the JSON map
        message: json["message"], // Extract message from the JSON map
        routeStatus: json["routeStatus"], // Extract route status from the JSON map
        totalShipments: json["total_shipments"], // Extract total shipments from the JSON map
        totalRoutes: json["totalRoutes"], // Extract total routes from the JSON map
        onTimeDeliveries: json["onTimeDeliveries"], // Extract on-time deliveries percentage from the JSON map
        otherDriverOnTimeDeliveries: json["otherDriverOnTimeDeliveries"]?.toDouble(), // Extract other drivers' on-time deliveries
        totalEarning: json["totalEarning"], // Extract total earnings from the JSON map
        totalDistance: json["totalDistance"], // Extract total distance from the JSON map
        totaLoadedDistance: json["totaLoadedDistance"], // Extract total loaded distance from the JSON map
        routeDetails: json["route_details"] == null
            ? []
            : List<RouteDetail>.from(json["route_details"]!.map((x) => RouteDetail.fromJson(x))), // Extract route details
      );

  /// Converts the DriverDashboardResponse object into a JSON map.
  Map<String, dynamic> toJson() => {
        "status": status, // Add status to the JSON map
        "message": message, // Add message to the JSON map
        "routeStatus": routeStatus, // Add route status to the JSON map
        "total_shipments": totalShipments, // Add total shipments to the JSON map
        "totalRoutes": totalRoutes, // Add total routes to the JSON map
        "onTimeDeliveries": onTimeDeliveries, // Add on-time deliveries percentage to the JSON map
        "otherDriverOnTimeDeliveries": otherDriverOnTimeDeliveries, // Add other drivers' on-time deliveries to the JSON map
        "totalEarning": totalEarning, // Add total earnings to the JSON map
        "totalDistance": totalDistance, // Add total distance to the JSON map
        "totaLoadedDistance": totaLoadedDistance, // Add total loaded distance to the JSON map
        "route_details": routeDetails == null ? [] : List<dynamic>.from(routeDetails!.map((x) => x.toJson())), // Add route details to the JSON map
      };
}

/// Represents detailed information about a route assigned to the driver.
class RouteDetail {
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
  dynamic assignedLoader; // ID of the assigned loader
  int? loadingComplete; // Indicates if loading is complete
  String? status; // Status of the route (e.g., active, completed)
  int? pQuantity; // Quantity of products delivered
  int? rQuantity; // Quantity of products returned
  int? tQuantity; // Total quantity handled
  DateTime? createdAt; // Timestamp of creation
  DateTime? updatedAt; // Timestamp of last update
  TruckDetails? truckDetails; // Details of the truck assigned to the route
  DriverDetails? driverDetails; // Details of the driver assigned to the route
  int? deliveredCount; // Number of deliveries completed
  Warehouse? warehouse; // Details of the warehouse associated with the route
  int? deliveredShipmentCount; // Number of shipments delivered

  /// Constructor for initializing the RouteDetail object.
  RouteDetail({
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
    this.assignedLoader,
    this.loadingComplete,
    this.status,
    this.pQuantity,
    this.rQuantity,
    this.tQuantity,
    this.createdAt,
    this.updatedAt,
    this.truckDetails,
    this.driverDetails,
    this.deliveredCount,
    this.warehouse,
    this.deliveredShipmentCount,
  });

  /// Factory method to create a RouteDetail object from a JSON map.
  factory RouteDetail.fromJson(Map<String, dynamic> json) => RouteDetail(
        id: json["id"], // Extract ID from the JSON map
        deliveryDate: json["delivery_date"] == null ? null : DateTime.parse(json["delivery_date"]), // Parse delivery date
        totalStops: json["total_stops"], // Extract total stops from the JSON map
        originPoints: json["origin_points"], // Extract origin points from the JSON map
        lastDropoffLocation: json["last_dropoff_location"], // Extract last drop-off location from the JSON map
        forkLift: json["fork_lift"], // Extract forklift usage from the JSON map
        totalQuantity: json["total_quantity"], // Extract total quantity from the JSON map
        plannedDepartureTime:
            json["planned_departure_time"] == null ? null : DateTime.parse(json["planned_departure_time"]), // Parse planned departure time
        loadedDuration: json["loaded_duration"], // Extract loaded duration from the JSON map
        totalDuration: json["total_duration"], // Extract total duration from the JSON map
        totalDistance: json["total_distance"], // Extract total distance from the JSON map
        loadedDistance: json["loaded_distance"], // Extract loaded distance from the JSON map
        totalLoad: json["total_load"], // Extract total load from the JSON map
        recommendedPrice: json["recommended_price"]?.toDouble(), // Extract recommended price from the JSON map
        totalPrice: json["total_price"], // Extract total price from the JSON map
        loadingBy: json["loading_by"], // Extract loading person from the JSON map
        assignedDriver: json["assigned_driver"], // Extract assigned driver ID from the JSON map
        assignedTruck: json["assigned_truck"], // Extract assigned truck ID from the JSON map
        assignedLoader: json["assigned_loader"], // Extract assigned loader ID from the JSON map
        loadingComplete: json["loading_complete"], // Extract loading complete status from the JSON map
        status: json["status"], // Extract route status from the JSON map
        pQuantity: json["P_quantity"], // Extract delivered quantity from the JSON map
        rQuantity: json["R_quantity"], // Extract returned quantity from the JSON map
        tQuantity: json["T_quantity"], // Extract total quantity from the JSON map
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]), // Parse creation timestamp
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]), // Parse update timestamp
        truckDetails: json["truck_details"] == null ? null : TruckDetails.fromJson(json["truck_details"]), // Extract truck details
        driverDetails: json["driver_details"] == null ? null : DriverDetails.fromJson(json["driver_details"]), // Extract driver details
        deliveredCount: json["deliveredCount"], // Extract delivered count from the JSON map
        warehouse: json["warehouse"] == null ? null : Warehouse.fromJson(json["warehouse"]), // Extract warehouse details
        deliveredShipmentCount: json['deliveredShipmentCount'], // Extract delivered shipment count from the JSON map
      );

  /// Converts the RouteDetail object into a JSON map.
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
        "assigned_loader": assignedLoader, // Add assigned loader ID to the JSON map
        "loading_complete": loadingComplete, // Add loading complete status to the JSON map
        "status": status, // Add route status to the JSON map
        "P_quantity": pQuantity, // Add delivered quantity to the JSON map
        "R_quantity": rQuantity, // Add returned quantity to the JSON map
        "T_quantity": tQuantity, // Add total quantity to the JSON map
        "created_at": createdAt?.toIso8601String(), // Add creation timestamp to the JSON map
        "updated_at": updatedAt?.toIso8601String(), // Add update timestamp to the JSON map
        "truck_details": truckDetails?.toJson(), // Add truck details to the JSON map
        "driver_details": driverDetails?.toJson(), // Add driver details to the JSON map
        "deliveredCount": deliveredCount, // Add delivered count to the JSON map
        "warehouse": warehouse?.toJson(), // Add warehouse details to the JSON map
        "deliveredShipmentCount": deliveredShipmentCount, // Add delivered shipment count to the JSON map
      };
}

/// Represents details of the driver assigned to the route.
class DriverDetails {
  int? id; // Unique identifier for the driver
  String? userId; // User ID of the driver
  String? name; // Full name of the driver
  String? firstname; // First name of the driver
  String? lastname; // Last name of the driver
  String? username; // Username of the driver

  /// Constructor for initializing the DriverDetails object.
  DriverDetails({
    this.id,
    this.userId,
    this.name,
    this.firstname,
    this.lastname,
    this.username,
  });

  /// Factory method to create a DriverDetails object from a JSON map.
  factory DriverDetails.fromJson(Map<String, dynamic> json) => DriverDetails(
        id: json["id"], // Extract ID from the JSON map
        userId: json["user_id"], // Extract user ID from the JSON map
        name: json["name"], // Extract name from the JSON map
        firstname: json["firstname"], // Extract first name from the JSON map
        lastname: json["lastname"], // Extract last name from the JSON map
        username: json["username"], // Extract username from the JSON map
      );

  /// Converts the DriverDetails object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "user_id": userId, // Add user ID to the JSON map
        "name": name, // Add name to the JSON map
        "firstname": firstname, // Add first name to the JSON map
        "lastname": lastname, // Add last name to the JSON map
        "username": username, // Add username to the JSON map
      };
}

/// Represents details of the truck assigned to the route.
class TruckDetails {
  int? id; // Unique identifier for the truck
  String? vin; // Vehicle Identification Number (VIN) of the truck

  /// Constructor for initializing the TruckDetails object.
  TruckDetails({
    this.id,
    this.vin,
  });

  /// Factory method to create a TruckDetails object from a JSON map.
  factory TruckDetails.fromJson(Map<String, dynamic> json) => TruckDetails(
        id: json["id"], // Extract ID from the JSON map
        vin: json["vin"], // Extract VIN from the JSON map
      );

  /// Converts the TruckDetails object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "vin": vin, // Add VIN to the JSON map
      };
}

/// Represents details of the warehouse associated with the route.
class Warehouse {
  int? id; // Unique identifier for the warehouse
  String? name; // Name of the warehouse
  String? email; // Email address of the warehouse
  String? primaryPhoneNo; // Primary phone number of the warehouse
  String? address; // Address of the warehouse
  String? latitude; // Latitude of the warehouse location
  String? longitude; // Longitude of the warehouse location
  String? state; // State where the warehouse is located
  String? city; // City where the warehouse is located
  String? zipcode; // Zip code of the warehouse location
  String? timezone; // Timezone of the warehouse location
  String? status; // Status of the warehouse (e.g., active, inactive)
  int? createdBy; // ID of the user who created the warehouse
  dynamic createdAt; // Timestamp of warehouse creation
  DateTime? updatedAt; // Timestamp of last update to the warehouse

  /// Constructor for initializing the Warehouse object.
  Warehouse({
    this.id,
    this.name,
    this.email,
    this.primaryPhoneNo,
    this.address,
    this.latitude,
    this.longitude,
    this.state,
    this.city,
    this.zipcode,
    this.timezone,
    this.status,
    this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory method to create a Warehouse object from a JSON map.
  factory Warehouse.fromJson(Map<String, dynamic> json) => Warehouse(
        id: json["id"], // Extract ID from the JSON map
        name: json["name"], // Extract name from the JSON map
        email: json["email"], // Extract email from the JSON map
        primaryPhoneNo: json["primary_phone_no"], // Extract primary phone number from the JSON map
        address: json["address"], // Extract address from the JSON map
        latitude: json["latitude"], // Extract latitude from the JSON map
        longitude: json["longitude"], // Extract longitude from the JSON map
        state: json["state"], // Extract state from the JSON map
        city: json["city"], // Extract city from the JSON map
        zipcode: json["zipcode"], // Extract zip code from the JSON map
        timezone: json["timezone"], // Extract timezone from the JSON map
        status: json["status"], // Extract status from the JSON map
        createdBy: json["created_by"], // Extract creator ID from the JSON map
        createdAt: json["created_at"], // Extract creation timestamp from the JSON map
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]), // Parse update timestamp
      );

  /// Converts the Warehouse object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "name": name, // Add name to the JSON map
        "email": email, // Add email to the JSON map
        "primary_phone_no": primaryPhoneNo, // Add primary phone number to the JSON map
        "address": address, // Add address to the JSON map
        "latitude": latitude, // Add latitude to the JSON map
        "longitude": longitude, // Add longitude to the JSON map
        "state": state, // Add state to the JSON map
        "city": city, // Add city to the JSON map
       

  }

        }
        