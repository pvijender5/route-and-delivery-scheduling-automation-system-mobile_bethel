// Enum representing various statuses of a route.
///
/// The `RouteStatus` enum defines different states that a route can have
/// during its lifecycle, such as `planned`, `loading`, `inTransit`, and more.
/// It is used to manage and track the progress of a route in the application.

import 'constants.dart';

enum RouteStatus {
  planned,
  postedToLoadboard,
  driverAssigned,
  loaded,
  loading,
  inTransitArrived,
  inTransitCancelled,
  inTransitDelay,
  inTransitOnTime,
  completed,
  delivered,
  canceled,
  undelivered,
  other;

  /// Converts a string representation of a route status to its corresponding `RouteStatus` enum value.
  ///
  /// This method takes a status string, compares it against predefined constants,
  /// and returns the matching `RouteStatus` enum value. If the status does not match
  /// any predefined constants, it defaults to `RouteStatus.other`.
  ///
  /// Parameters:
  /// - `status`: A nullable string representing the route status.
  ///
  /// Returns:
  /// - The corresponding `RouteStatus` enum value.
  static RouteStatus statusToProceed(String? status) {
    switch (status?.toLowerCase()) {
      case PLANNED:
        return RouteStatus.planned;
      case POSTED_TO_LOADBOARD:
        return RouteStatus.postedToLoadboard;
      case DRIVER_ASSIGNED:
        return RouteStatus.driverAssigned;
      case LOADED:
        return RouteStatus.loaded;
      case LOADING:
        return RouteStatus.loading;
      case IN_TRANSIT_ARRIVED:
        return RouteStatus.inTransitArrived;
      case IN_TRANSIT_DELAY:
        return RouteStatus.inTransitDelay;
      case IN_TRANSIT_ON_TIME:
        return RouteStatus.inTransitOnTime;
      case IN_TRANSIT_CANCELLED:
        return RouteStatus.inTransitCancelled;
      case DELIVERED:
        return RouteStatus.delivered;
      case COMPLETED:
        return RouteStatus.completed;
      case CANCELED:
        return RouteStatus.canceled;
      case UNDELIVERED:
        return RouteStatus.undelivered;
      default:
        return RouteStatus.other;
    }
  }
}

/// Determines if background location updates should proceed based on the route status.
bool shouldProceedBackgroundLocation(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return (routeStatus != RouteStatus.planned) &&
      (routeStatus != RouteStatus.postedToLoadboard) &&
      (routeStatus != RouteStatus.driverAssigned) &&
      (routeStatus != RouteStatus.loaded) &&
      (routeStatus != RouteStatus.loading) &&
      (routeStatus != RouteStatus.inTransitArrived) &&
      (routeStatus != RouteStatus.delivered) &&
      (routeStatus != RouteStatus.completed) &&
      (routeStatus != RouteStatus.inTransitCancelled);
}

/// Checks if the route status is `inTransitArrived`.
bool inTransitArrivedPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.inTransitArrived;
}

/// Checks if the route status is either `inTransitOnTime` or `inTransitDelay`.
bool statusToProceedInTransitOnTimeDelayPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);

  return (routeStatus == RouteStatus.inTransitOnTime) || (routeStatus == RouteStatus.inTransitDelay);
}

/// Checks if the route status is `inTransitOnTime`.
bool inTransitOnTimePassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.inTransitOnTime;
}

/// Checks if the route status is `delivered`.
///
/// This function determines whether the given route status matches the `delivered`
/// status, indicating that all deliveries have been completed.
///
/// Parameters:
/// - `status`: A nullable string representing the route status.
///
/// Returns:
/// - `true` if the route status is `delivered`, otherwise `false`.
bool isAllDeliveredPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.delivered;
}

/// Checks if the route status is `undelivered`.
/// Returns `true` if the status matches `RouteStatus.undelivered`, otherwise `false`.
bool isUnDeliveredPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.undelivered;
}

/// Checks if the route status is `canceled`.
/// Returns `true` if the status matches `RouteStatus.canceled`, otherwise `false`.
bool isCanceledPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.canceled;
}

/// Checks if the route status is `completed`.
/// Returns `true` if the status matches `RouteStatus.completed`, otherwise `false`.
bool isCompletedPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.completed;
}

/// Determines if the pause action should be disabled based on the route status.
///
/// Returns `true` if the route status does not allow pausing, otherwise `false`.
bool disablePauseActionPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return (routeStatus != RouteStatus.inTransitOnTime) &&
      (routeStatus != RouteStatus.inTransitDelay) &&
      (routeStatus != RouteStatus.inTransitArrived) &&
      (routeStatus != RouteStatus.delivered);
}

/// Checks if the route status is `loaded`.
bool isLoadedPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.loaded;
}

/// Checks if the route status is valid for "In My Load" operations.
/// Returns `true` for statuses like `inTransitOnTime`, `inTransitDelay`, `inTransitArrived`, `completed`, or `delivered`.
bool statusToProceedInMyLoadPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return (routeStatus == RouteStatus.inTransitOnTime) ||
      (routeStatus == RouteStatus.inTransitDelay) ||
      (routeStatus == RouteStatus.inTransitArrived) ||
      (routeStatus == RouteStatus.completed) ||
      (routeStatus == RouteStatus.delivered);
}

/// Checks if the route status is valid for assigning a driver.
///
/// Returns `true` if the status matches `planned`, `postedToLoadboard`, `driverAssigned`, or `loaded`.
bool statusToProceedAssignDriverPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return (routeStatus == RouteStatus.planned) &&
      (routeStatus == RouteStatus.postedToLoadboard) &&
      (routeStatus == RouteStatus.driverAssigned) &&
      (routeStatus == RouteStatus.loaded);
}

/// Checks if the route status is valid for calling and assigning a driver.
/// Returns `true` for statuses `postedToLoadboard` or `driverAssigned`.
bool statusToProceedCallAndAssignDriverPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return (routeStatus == RouteStatus.postedToLoadboard) || (routeStatus == RouteStatus.driverAssigned);
}

/// Checks if the route status is `driverAssigned`.
/// Returns `true` if the status matches `RouteStatus.driverAssigned`, otherwise `false`.
bool statusToProceedIsDriverAssignedPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.driverAssigned;
}

/// Checks if the route status is `loading`.
bool statusToProceedIsLoadingPassed(String? status) {
  RouteStatus routeStatus = RouteStatus.statusToProceed(status);
  return routeStatus == RouteStatus.loading;
}
