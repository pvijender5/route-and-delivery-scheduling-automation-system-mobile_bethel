/// A service class for managing Pusher client connections and events.
///
/// The `PusherService` class provides functionality to initialize, connect,
/// subscribe, trigger events, and disconnect from Pusher channels. It is
/// designed as a singleton to ensure a single instance is used throughout
/// the application.
///
/// Key Features:
/// - Initializes Pusher with authentication and configuration options.
/// - Subscribes to private channels and binds event listeners.
/// - Handles connection state changes and errors.
/// - Provides methods to trigger events, unsubscribe, and disconnect.
///
/// Example Usage:
/// ```dart
/// final pusherService = PusherService();
/// await pusherService.initPusher(accessToken);
/// pusherService.triggerEvent(latitude, longitude, routeId);
/// pusherService.disConnect();
/// ```

import 'dart:async';
import 'dart:convert';

import 'package:bethel_farm/data/network/dio_provider.dart';
import 'package:bethel_farm/modules/dashboard/route/route_detail_controller.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:here_sdk/core.dart';
import 'package:pusher_client/pusher_client.dart';

import '../data/enums/user_role.dart';

class PusherService {
  static final PusherService _instance = PusherService._();

  factory PusherService() => _instance;

  PusherService._();

  late PusherOptions options;
  PusherClient? pusher;
  Channel? channel;

  /// Initializes the Pusher client with the provided access token and optional user role.
  ///
  /// This method sets up the Pusher client with authentication, configuration options,
  /// and event bindings. It connects to the Pusher server, subscribes to the private
  /// channel, and binds event listeners for handling location updates and other events.
  ///
  /// Parameters:
  /// - `accessToken`: The access token used for authenticating the Pusher client.
  /// - `userRole`: (Optional) The role of the user, used for specific event handling.
  ///
  /// Throws:
  /// - Prints error messages if initialization or connection fails.
  Future initPusher(String accessToken, {String? userRole}) async {
    try {
      options = PusherOptions(
        host: DioProvider.socketUrl,
        wsPort: 6001,
        encrypted: true,
        cluster: "us2",
        auth: PusherAuth(
          'https://${DioProvider.socketUrl}/api/broadcasting/auth',
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      // pusher = PusherClient("a746ab2a299f06369ba1", options, autoConnect: true);
      pusher = PusherClient("23cf856c0cc3403e5574", options, autoConnect: true);

// connect at a later time than at instantiation.
      await pusher?.connect();

      pusher?.onConnectionStateChange((state) {
        print("previousState: ${state?.previousState}, currentState: ${state?.currentState}");
      });

      pusher?.onConnectionError((error) {
        print("error: ${error?.message}");
      });

// Subscribe to a private channel
      channel = pusher?.subscribe("private-location");

// Bind to listen for events called "order-status-updated" sent to "private-orders" channel
      channel?.bind("SendLocation", (PusherEvent? event) {});

      channel?.bind("App\\Events\\SendLocation", (PusherEvent? event) async {
        print(event?.data);
        print(event?.channelName);
        print(event?.eventName);
        if (userRole == UserRole.MERCHANDISER.name) {
          // Parse the JSON string
          Map<String, dynamic> data = jsonDecode(event?.data ?? "");
          final routeDetailController = Get.put(RouteDetailController());
          // final Uint8List? markerIcon = await routeDetailController.getBytesFromAsset(
          //     'assets/images/truck.png', 50);
          if (data['route_id'] == routeDetailController.routeDetail.value?.id) {
            routeDetailController.mapTruckMarker.value?.coordinates =
                GeoCoordinates(double.parse(data['lat']), double.parse(data['lng']));

            routeDetailController.routeDetail.value?.status = data['route_status'];

            // routeDetailController.markersList.refresh();
            routeDetailController.hereMapController.value?.camera.lookAtPoint(
              GeoCoordinates(double.parse(data['lat']), double.parse(data['lng'])),
            );
            routeDetailController.hereMapController.refresh();
            routeDetailController.mapTruckMarker.refresh();

            routeDetailController.update();
          }
        }
      });

      channel?.bind("pusher:subscription_succeeded", (PusherEvent? event) {
        // channel.trigger("SendLocation", {"lat":"29.339461","lng":"-81.499141","route_id":"2"});
      });
    } catch (e) {
      print("ERROR: $e");
    }
  }

  /// Triggers a "SendLocation" event on the Pusher channel.
  ///
  /// This method sends the latitude, longitude, and route ID as a JSON-encoded
  /// payload to the "SendLocation" event on the subscribed Pusher channel.
  ///
  /// Parameters:
  /// - `latitude`: The latitude of the location to send.
  /// - `longitude`: The longitude of the location to send.
  /// - `routeId`: The ID of the route associated with the location.
  ///
  /// Throws:
  /// - Prints an error message if the event triggering fails.
  void triggerEvent(double latitude, double longitude, int routeId) {
    try {
      Map<String, dynamic> locationData = {"lat": latitude, "lng": longitude, "route_id": routeId};
      channel?.trigger("SendLocation", jsonEncode(locationData));
    } catch (e) {
      print("Error triggering SendLocation event: $e");
    }
  }

  /// Unsubscribes from the "private-location" channel.
  ///
  /// This method attempts to unsubscribe the Pusher client from the specified
  /// channel. If an error occurs during the unsubscription process, it prints
  /// the error message to the console.
  ///
  /// Throws:
  /// - Prints an error message if the unsubscription fails.
  void unSubscribe() {
    try {
      pusher?.unsubscribe("private-location");
    } catch (e) {
      print("Error unsubscribe: $e");
    }
  }

  /// Disconnects the Pusher client from the server.
  void disConnect() {
    try {
      pusher?.disconnect();
    } catch (e) {
      print("Error disconnect: $e");
    }
  }
}
