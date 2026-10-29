/// \[LocationService\] is a singleton class responsible for managing location-related services.
///
/// This class handles:
/// - Permission checks for location services.
/// - Real-time location updates using `Geolocator`.
/// - Integration with external services like Pusher for location-based events.
/// - Updating driver latitude and longitude to the server.
/// - Managing delivery status based on location and ETA.
///
/// It provides methods to start and stop location tracking, handle permissions, and update location data dynamically.

import 'dart:async';

import 'package:bethel_farm/data/model/request/update_lat_long_request.dart';
import 'package:bethel_farm/data/remote/repositories/repository.dart';
import 'package:bethel_farm/data/remote/repositories/repository_impl.dart';
import 'package:bethel_farm/utils/constants.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:bethel_farm/utils/route_status_enum.dart';
import 'package:bethel_farm/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import '../data/local/preference_manager.dart';
import '../modules/dashboard/route/route_detail_controller.dart';
import 'pusher_service.dart';

class LocationService {
  int? route_id;
  static final LocationService _instance = LocationService._();

  factory LocationService() => _instance;

  LocationService._();

  StreamController<Position> _locationController = StreamController<Position>();

  Stream<Position> get locationStream => _locationController.stream;

  final PreferenceManager _preferenceManager = Get.find(tag: (PreferenceManager).toString());
  String? accessToken;
  PusherService pusherService = PusherService();
  String? routeStatus;
  late LocationSettings locationSettings;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  /// Handles location permission checks.
  ///
  /// This method verifies if location services are enabled and checks the current
  /// permission status. If permissions are denied, it requests the user to grant
  /// location permissions. It also handles cases where permissions are permanently
  /// denied.
  ///
  /// - Returns: A `Future<bool>` indicating whether the necessary permissions are granted.
  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Starts listening for location updates using `Geolocator`.
  ///
  /// This method checks for location permissions and initializes the location settings
  /// based on the platform (Android, iOS, macOS, or others). It listens to the position
  /// stream and updates the driver's latitude and longitude dynamically. Additionally,
  /// it triggers events and updates the server with the driver's current location.
  ///
  /// - Returns: A `Future` that completes when the location listening starts.
  Future<void> startListening() async {
    await Utils.checkPermissionsLocation();

    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
          forceLocationManager: true,
          //(Optional) Set foreground notification config to keep the app alive
          //when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText: "Bethel Farm app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.high,
        activityType: ActivityType.fitness,
        distanceFilter: 0,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: true,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );
    }

    Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      var controller = Get.put(RouteDetailController());
      controller.updateCurrentPosition(position);
      if (!_locationController.isClosed) {
        _locationController.add(position);
        // pusherService.triggerEvent(position.latitude,position.longitude,route_id??0);
        updateLatLongOfDriver(position.latitude, position.longitude);
      } else {
        print("object");
      }
    });
  }

  /// Initializes the location controller if it is closed.
  initLocationController() {
    if (_locationController.isClosed) {
      _locationController = StreamController<Position>();
    }
  }

  bool isUpdatingLatLong = false;

  /// Updates the driver's latitude and longitude dynamically.
  ///
  /// This method checks the current route status and determines whether to proceed
  /// with updating the driver's location to the server. It calculates the ETA for
  /// ongoing deliveries and updates the route status based on the delivery window.
  /// The method also handles cases where all deliveries are completed or the route
  /// is marked as delivered.
  ///
  /// - Parameters:
  ///   - latitude: The current latitude of the driver.
  ///   - longitude: The current longitude of the driver.
  void updateLatLongOfDriver(double latitude, double longitude) async {
    if (!isUpdatingLatLong) {
      isUpdatingLatLong = true;
      try {
        final Repository repository =
            Get.isRegistered<Repository>() ? Get.find<Repository>() : Get.put(RepositoryImpl());

        {
          var routeDetailController = Get.put(RouteDetailController());

          var routeDetailResponse = routeDetailController.routeDetail;

          if (routeDetailResponse.value != null) {
            if (routeDetailResponse.value?.isPaused == 0 &&
                shouldProceedBackgroundLocation(routeDetailResponse.value?.status)) {
              var shipment = routeDetailController.getCurrentStopId();

              var currentDateTime = DateTime.now();

              DateTime arrivedAt =
                  currentDateTime.add(Duration(seconds: routeDetailController.remainingDurationInSeconds?.value ?? 0));
              var routeStatus = isArrivedTimeWithinDeliveryWindow(
                  arrivedAt.toIso8601String(),
                  shipment?.propsDeliveryWindow?[0].start ?? DateTime.now(),
                  shipment?.propsDeliveryWindow?[0].end ?? DateTime.now());
              if (routeStatus) {
                routeDetailController.routeDetail.value?.status = IN_TRANSIT_ON_TIME;
              } else {
                routeDetailController.routeDetail.value?.status = IN_TRANSIT_DELAY;
              }

              List<Eta> etas = [];
              var inProgressDeliveries = (routeDetailResponse.value?.shipmentDeliveries ?? [])
                  .where((element) => statusToProceedInTransitOnTimeDelayPassed(element.deliveryStatus));

              for (int i = 0; i < inProgressDeliveries.length; i++) {
                var shipmentDelivery = inProgressDeliveries.elementAt(i);

                var item = routeDetailController.remainingDurationInSeconds?.value;

                int? duration = 0;
                if ((item ?? 0) < 60) {
                  duration = 1;
                } else {
                  duration = (item ?? 0) ~/ 60;
                }

                etas.add(Eta(eta: duration.toString(), id: shipmentDelivery.id.toString()));
                var isContain = routeDetailController.routeDetail.value?.shipmentDeliveries
                    ?.any((element) => element.id == shipmentDelivery.id);
                if (isContain ?? false) {
                  routeDetailController.routeDetail.value?.shipmentDeliveries?[i].eta = duration;
                }
              }
              routeDetailController.update();

              print(etas);
              UpdateLatLongRequest queryParam;

              if (isAllDeliveredPassed(routeDetailResponse.value?.status) //?.toLowerCase() == "delivered"
                  ||
                  isCompletedPassed(routeDetailResponse.value?.status)) //?.toLowerCase() == "completed")
              {
                queryParam = UpdateLatLongRequest(
                    eta: etas,
                    lat: latitude.toString(),
                    lng: longitude.toString(),
                    routeId: routeDetailResponse.value?.id.toString(),
                    routeStatus: "",
                    heading: ((routeDetailController.currentPosition?.value?.heading ?? 0.0).toInt()).toString());
              } else {
                queryParam = UpdateLatLongRequest(
                    eta: etas,
                    lat: latitude.toString(),
                    lng: longitude.toString(),
                    routeId: routeDetailResponse.value?.id.toString(),
                    routeStatus: (routeStatus) ? IN_TRANSIT_ON_TIME : IN_TRANSIT_DELAY,
                    heading: ((routeDetailController.currentPosition?.value?.heading ?? 0.0).toInt()).toString());
              }
              print(routeStatus);

              var response = await repository.updateLatLong(queryParam);
              print(response);
            } else {
              if (isAllDeliveredPassed(routeDetailResponse.value?.status)) //?.toLowerCase() == "delivered")
              {
                List<Eta> etas = [];
                UpdateLatLongRequest queryParam;
                queryParam = UpdateLatLongRequest(
                    eta: etas,
                    lat: latitude.toString(),
                    lng: longitude.toString(),
                    routeId: routeDetailResponse.value?.id.toString(),
                    routeStatus: "",
                    heading: ((routeDetailController.currentPosition?.value?.heading ?? 0.0).toInt()).toString());
                var response = await repository.updateLatLong(queryParam);
                print(response);
              }
            }
          }
        }
        isUpdatingLatLong = false;
      } catch (e) {
        isUpdatingLatLong = false;
        print(e.toString());
      }
    }
  }

  /// Checks if the arrival time falls within the specified delivery window.
  bool isArrivedTimeWithinDeliveryWindow(String arrivedAt, DateTime start, DateTime end) {
    DateTime arrivedDateTime = DateTime.parse(arrivedAt);
    String startDateTime = Utils.formatUtcDateTimeSeconds(start.toIso8601String());
    String endDateTime = Utils.formatUtcDateTimeSeconds(end.toIso8601String());

    DateTime startDate = DateTime.parse(startDateTime);
    DateTime endDate = DateTime.parse(endDateTime);
    if (arrivedDateTime.isAfter(startDate) && arrivedDateTime.isBefore(endDate)) {
      return true;
    }
    return false;
  }

  /// Disposes resources such as the location stream and Pusher connection.
  void dispose() {
    _locationController.close();
    _locationController.onCancel;
    pusherService.disConnect();
  }

  /// Starts the location service by initializing Pusher and listening for location updates.
  Future<void> startLocationService() async {
    accessToken = await _preferenceManager.getString(PreferenceManager.keyToken);

// Initialize Pusher with your access token
    await pusherService.initPusher(accessToken ?? "");
    await _instance.startListening();
  }
}
