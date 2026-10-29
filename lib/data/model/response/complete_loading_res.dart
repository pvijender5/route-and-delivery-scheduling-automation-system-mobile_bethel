/// Represents a request to update latitude and longitude along with additional route details.
class UpdateLatLongRequest {
  String? lat; // Latitude of the location
  String? lng; // Longitude of the location
  String? routeId; // Identifier for the route
  List<Eta>? eta; // List of estimated time of arrivals (ETA) for the route
  String? routeStatus; // Status of the route (e.g., active, completed)
  String? heading; // Heading direction of the route

  /// Constructor for initializing the UpdateLatLongRequest object.
  UpdateLatLongRequest({
    this.lat,
    this.lng,
    this.routeId,
    this.eta,
    this.routeStatus,
    this.heading,
  });

  /// Converts the UpdateLatLongRequest object into a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["lat"] = lat; // Add latitude to the JSON map
    data["lng"] = lng; // Add longitude to the JSON map
    data["route_id"] = routeId; // Add route ID to the JSON map
    // Convert ETA list to JSON if not null
    data["eta"] = (eta != null) ? List<dynamic>.from(eta!.map((x) => x.toJson())) : null;
    // Add route status to the JSON map if it's not an empty string
    if (routeStatus != "") data["route_status"] = routeStatus;
    // Add heading to the JSON map if it's not an empty string
    if (heading != "") data["heading"] = heading;
    return data;
  }
}

/// Represents an estimated time of arrival (ETA) for a route.
class Eta {
  String? id; // Identifier for the ETA
  String? eta; // Estimated time of arrival

  /// Constructor for initializing the Eta object.
  Eta({
    this.id,
    this.eta,
  });

  /// Factory method to create an Eta object from a JSON map.
  factory Eta.fromJson(Map<String, dynamic> json) => Eta(
        id: json["id"], // Extract ID from the JSON map
        eta: json["eta"], // Extract ETA from the JSON map
      );

  /// Converts the Eta object into a JSON map.
  Map<String, dynamic> toJson() => {
        "id": id, // Add ID to the JSON map
        "eta": eta, // Add ETA to the JSON map
      };
}
