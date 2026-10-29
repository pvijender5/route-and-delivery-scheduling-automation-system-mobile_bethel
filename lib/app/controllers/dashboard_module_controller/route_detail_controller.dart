import 'dart:async';
import 'dart:convert';

import 'package:bethel_farm/here_map_module/common/here_map_util.dart' as Util;
import 'package:bethel_farm/modules/loader/loader_route_detail/route_pause_log_query_params.dart';
import 'package:bethel_farm/utils/constants.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/location.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/routing.dart' as HERE;
import 'package:here_sdk/routing.dart' as Routing;
import 'package:intl/intl.dart';
import 'package:stepper_list_view/stepper_list_view.dart';

import '../../base/base_controller.dart';
import '../../core/app_string/app_strings.dart';
import '../../data/enums/user_role.dart';
import '../../data/local/preference_manager.dart';
import '../../data/model/common/common_user.dart';
import '../../data/model/response/cancel_shipment_response.dart';
import '../../data/model/response/complete_shipment_delivery.dart';
import '../../data/model/response/resequence_req.dart';
import '../../data/model/response/route_complete_response.dart';
import '../../data/model/response/route_details_response.dart';
import '../../data/model/response/route_pause_log_response.dart';
import '../../data/model/response/route_start_response.dart';
import '../../data/remote/repositories/query_param/complete_shipment_query_param.dart';
import '../../data/remote/repositories/repository.dart';
import '../../data/remote/repositories/repository_impl.dart';
import '../../here_map_module/positioning/positioning.dart';
import '../../here_map_module/routing/waypoint_info.dart';
import '../../here_map_module/routing/waypoints_controller.dart';
import '../../utils/here_map_services/HereRouteCalculator.dart';
import '../../utils/location_service.dart';
import '../../utils/pusher_service.dart';
import '../../utils/utils.dart';
import '../../ui/data/model/common/common_response.dart';
import '../../ui/data/model/response/complete_route_loading.dart';
import '../../ui/data/model/response/re_sequence_res.dart';
import '../../ui/data/remote/repositories/query_param/mark_all_loaded_query_param.dart';
import '../../ui/here_map_module/common/here_map_util.dart';
import '../../ui/here_map_module/common/ui_style.dart';
import '../../ui/utils/exports.dart';
import '../../ui/utils/route_status_enum.dart';
import '../../ui/pages/dashboard_module/route/complete_route_query_param.dart';
import '../../ui/pages/dashboard_module/route/route_start_query_param.dart';

/// `RouteDetailController` is responsible for managing route details, shipment deliveries,
/// and related operations such as route sequencing, delivery completion, and route pause logging.
/// It interacts with APIs, handles user actions, and updates the UI accordingly.
class RouteDetailController extends BaseController{
  static get to => Get.isRegistered<RouteDetailController>()
      ? Get.find<RouteDetailController>()
      : Get.put(RouteDetailController());

  // StreamController<ErrorAnimationType>? errorController;
  final sheet1 = GlobalKey();

  final Rx<DraggableScrollableController> controller = DraggableScrollableController().obs;
  String? subDriver;
  String? fromScreen = "";
  RouteCalculator? _routeCalculator;
  ValueChanged<String>? _updateMessageState;
  Rx<TextEditingController>? reasonTextController = TextEditingController().obs;
  RxString routeStatus = "".obs;
  RxBool isRouteOpen = true.obs;
  RxBool isStopOpen = false.obs;
  var hightItemView = 0.0.obs;
  RxBool isWithinDeliveredWindow = false.obs;
  RxBool isWithinUndeliveredWindow = false.obs;
  RxBool isWithinArrivedWindow = false.obs;
  Rx<CompleteShipmentDeliveryRes?> completeShipmentDeliveryResponse = CompleteShipmentDeliveryRes().obs;
  Rx<RoutePauseLogResponse?> routePauseLogResponse = RoutePauseLogResponse().obs;

  final Rx<HERE.Waypoint?> _startWaypoint = Rx<HERE.Waypoint?>(null);
  final Rx<HERE.Waypoint?> _destinationWaypoint = Rx<HERE.Waypoint?>(null);
  final Repository _repository = Get.isRegistered<Repository>() ? Get.find<Repository>() : Get.put(RepositoryImpl());
  final PreferenceManager _preferenceManager = Get.find(tag: (PreferenceManager).toString());
  String merchandiserLocationName = (Get.arguments == null) ? "" : Get.arguments['mer_loc_name'] ?? "";

  /// Initializing User object to access data like id, name etc....
  RxString userRole = "".obs;
  RxBool isLoading = false.obs;
  Rx<RouteStartResponse?> routeStart = RouteStartResponse().obs;
  Rx<RouteCompleteResponse?> completeRoute = RouteCompleteResponse().obs;
  /// Initializing User object to access data like id, name etc....
  Rx<User> user = User().obs;
  int? userId;
  Rx<bool> viewOnly = false.obs;
  Rx<RouteDetailData?> routeDetail = RouteDetailData().obs;
  RxList<StepperItemData> stepperData = <StepperItemData>[].obs;
  RxList<String> breakDown = [AppString.breakdown, AppString.pauseForABreak].obs;
  RxString selectedReason = "Breakdown".obs;
  RxString breakdownReason = "breakdown".obs;
  int routeId = (Get.arguments == null) ? 0 : Get.arguments['route_id'] ?? 0;
  String? accessToken;
  Rx<String> isCompleteRouteLoading = 'S_inCompleted_R_inComplete'.obs;
  Rx<bool> canChangeOrgList = true.obs;
  Rx<bool> isShipmentReOrdered = false.obs;
  Rx<TextEditingController> notesTextEditingController = TextEditingController().obs;
  int? stopId = 0;
  List<ShipmentDeliveries> orgShipmentListResequence = <ShipmentDeliveries>[].obs; //ReSequenceRequest
  List<ShipmentDeliveries> copyShipmentListResequence = <ShipmentDeliveries>[].obs; //ReSequenceRequest
  List<ReSequenceRequest> reSequenceRequest = <ReSequenceRequest>[].obs; //ReSequenceRequest
  List<DragAndDropList> contents = [];
  var startGeoCoordinates = GeoCoordinates(27.3108198, -81.9889776).obs;
  var lastGeoCoordinates = GeoCoordinates(27.3108198, -81.9889776).obs;
  Rx<HereMapController?> hereMapController = Rx(null);
  Rx<int>? remainingDurationInSeconds = 0.obs;
  var currentLocation;
  Rx<Position?>? currentPosition = Rx<Position?>(null);

// Rx<Location?>?currentLocationHeading=Rx<Location?>(null);
  RxList<Routing.Route> routesList = <Routing.Route>[].obs;

  /// Initial route for navigation.
  Rx<Routing.Route?> route = Rx(null);

  /// Waypoints lists of the route.
  Rx<WayPointsController?> wayPointsController = Rx(null);

  final LocationEngine? _locationEngine = LocationEngine();
  Rx<MapMarker?> mapTruckMarker = Rx(null);
  Location? get lastKnownLocation => _locationEngine?.lastKnownLocation;
  RxBool shouldProceedLocationService = false.obs;



  /// Initializes the controller by fetching user and route details.
  @override
  void onInit() {
    super.onInit();
    // errorController = StreamController<ErrorAnimationType>();
    getUserDetails();
    getRouteDetails();
  }

  /// Cleans up resources when the controller is no longer needed.
  @override
  void onClose() {

    // detach();
    super.onClose();
  }

  /// Updates the current position and refreshes the UI.
  updateCurrentPosition(Position position) {
    currentPosition?.value = position;
    currentPosition?.refresh();
    update();
  }

  /// Checks if the arrival time is within the specified delivery window.
  ///
  /// This method compares the arrival time (`arrivedAt`) with the start (`start`)
  /// and end (`end`) times of the delivery window. It returns `true` if the
  /// arrival time is after the start time and before the end time, otherwise
  /// returns `false`.
  ///
  /// Parameters:
  /// - `arrivedAt`: The arrival time in UTC format.
  /// - `start`: The start time of the delivery window in UTC format.
  /// - `end`: The end time of the delivery window in UTC format.
  ///
  /// Returns:
  /// - `true` if the arrival time is within the delivery window.
  /// - `false` otherwise.
  bool isArrivedTimeWithinDeliveryWindow(String arrivedAt, String start, String end) {
    String arrivedDateTime = Utils.formatUtcDateTimeSeconds(arrivedAt);
    String startDateTime = Utils.formatUtcDateTimeSeconds(start);
    String endDateTime = Utils.formatUtcDateTimeSeconds(end);

    DateTime arrivedDate = DateTime.parse(arrivedDateTime);
    DateTime startDate = DateTime.parse(startDateTime);
    DateTime endDate = DateTime.parse(endDateTime);
    if (arrivedDate.isAfter(startDate) && arrivedDate.isBefore(endDate)) {
      return true;
    }

    return false;
  }

  /// Checks if the given stop ID is currently in progress based on its delivery status.
  bool isInProgress({required int stopId}) {
    StepperItemData? stepperItemData;
    try {
      stepperItemData = stepperData.firstWhere((element) =>statusToProceedInTransitOnTimeDelayPassed(element.content['deliveryStatus']));
          // element.content['deliveryStatus'] == "in-transit-on-time" ||
          // element.content['deliveryStatus'] == "in-transit-delay");
    } catch (e) {}
    if (stepperItemData?.content['shipment']['id'] == stopId) {
      return true;
    }
    return false;
  }

  /// Logs the pause or resume state of a route with relevant details such as reason, note, and timestamps.
  void routePauseLog() {
    SmartDialog.showLoading();
    if (selectedReason.toLowerCase() == "pause for a break") {
      breakdownReason.value = "break";
    } else {
      breakdownReason.value = "breakdown";
    }
    print(reasonTextController?.value.text);
    if (routeDetail.value?.isPaused == 0) {
      var queryParam = RoutePauseLogQueryParam(
          routeId: routeDetail.value?.id.toString(),
          startTime: Utils.formatUtcDateTimeWithOutAm(DateTime.now().toLocal().toString()),
          endTime: "",
          breakReason: breakdownReason.value,
          note: reasonTextController?.value.text ?? "",
          routeStatus: "");
      var routeDetailsService = _repository.routePauseLog(queryParam);
      callDataService(routeDetailsService, onSuccess: _handleRoutePauseLogResponseSuccess);
    } else {
      var queryParam = RoutePauseLogQueryParam(
          routeId: routeDetail.value?.id.toString(),
          startTime: "",
          endTime: Utils.formatUtcDateTimeWithOutAm(DateTime.now().toLocal().toString()),
          breakReason: breakdownReason.value,
          note: reasonTextController?.value.text ?? "",
          routeStatus: routeStatus.value);
      var routeDetailsService = _repository.routePauseLog(queryParam);
      callDataService(routeDetailsService, onSuccess: _handleRoutePauseLogResponseSuccess);
    }
    hideLoading();
    update();
  }

  /// Handles the success response for route pause logging and updates route details.
  _handleRoutePauseLogResponseSuccess(RoutePauseLogResponse pauseLogResponse) {
    if (pauseLogResponse.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      Utils.showErrorMessage(pauseLogResponse.message.toString());
    } else {
      SmartDialog.dismiss();
      routePauseLogResponse.value = pauseLogResponse;

      var routeDetailsService = _repository.getRouteDetails(routeDetail.value?.id ?? 0);
      callDataService(routeDetailsService, onSuccess: _handleRouteDetailsResponseSuccess);
      print(routeDetail.value?.isPaused);
      update();
    }
  }

  /// Retrieves user details such as ID, access token, and role from preferences.
  Future<void> getUserDetails() async {
    final rawJson = await _preferenceManager.getString(PreferenceManager.userData);
    Map<String, dynamic> map = jsonDecode(rawJson.toString());
    user.value = User.fromJson(map);
    userId = user.value.id;
    accessToken = await _preferenceManager.getString(PreferenceManager.keyToken);
    userRole.value = await _preferenceManager.getString(PreferenceManager.userRole);
  }

  /// Fetches route details based on the `routeId` and updates the UI.
  getRouteDetails() async {
    // SmartDialog.showLoading();
    // routeDetail.value = RouteDetailData();
    if (routeId != 0) {
      var routeDetailsService = _repository.getRouteDetails(routeId);
      await callDataService(
        routeDetailsService,
        onSuccess: _handleRouteDetailsResponseSuccess,
      );
      // hideLoading();
    } else {
      print("routeId Null");
    }
  }

  /// Handles the success response for route details.
  ///
  /// This method processes the response received from the API for route details.
  /// It updates the `routeDetail`, initializes the stepper data, and sets up the
  /// waypoints and map controller for the route. Additionally, it starts location
  /// services or initializes Pusher services based on the user's role and route status.
  ///
  /// Parameters:
  /// - `response`: The `RouteDetailsResponse` object containing the API response data.
  ///
  /// This method also calculates the origin and destination coordinates, sets up
  /// the waypoints for the route, and initializes the truck route calculation.
  _handleRouteDetailsResponseSuccess(RouteDetailsResponse response) async {
    // SmartDialog.dismiss();
    if (response.status == AppString.apiStatusError) {
      Utils.showErrorMessage(response.message.toString());
    } else {
      route.value = null;
      wayPointsController.value = null;
      hereMapController.value = null;
      // routeId = 0;
      routeDetail.value = response.data;

      stepperData.clear();
      shouldProceedLocationService.value = shouldProceedBackgroundLocation(routeDetail.value?.status ?? "");
      LocationService locationService = LocationService();
      locationService.startListening();
      if (routeDetail.value?.isPaused == 0 && shouldProceedLocationService.value) {
        if (userRole.value != UserRole.MERCHANDISER.name) {

          locationService.initLocationController();
          locationService.route_id = routeDetail.value?.id;
          locationService.startLocationService();
        } else {

          PusherService pusherService = PusherService();
          pusherService.initPusher(accessToken ?? "", userRole: userRole.value);
        }
      }

      response.data?.shipmentDeliveries!.sort((a, b) => a.routeNo!.compareTo(b.routeNo!));
///This method will set the shipment deliveries data to stepper data and also after resequence it will update the stepper data from shipment deliveries data
      initializeAndUpdateStepperData(response);
      // refresh();
      // update();

      /// ////////////////////////////////////////////////////////////////////////////////////////////
      try {
        if (userRole.value != UserRole.MERCHANDISER.name && routeDetail.value?.status?.toLowerCase() != COMPLETED) {
          if ((Get.arguments['fromScreen'] ?? "") != "LoaderDetailScreen") {}

          ///set the marker on current location

          // hereMapController.value?.camera.lookAtPointWithMeasure(currentLocation!, MapMeasure(MapMeasureKind.distance, 10000));
        }
      } catch (e) {
        e.printError();
      }

      ///create routes here
      // var originCoordinates = await getCoordinatesFromAddress(routeDetail.value?.originPoints ?? "");
      // var lastCoordinates =
      // await getCoordinatesFromAddress(routeDetail.value?.lastDropoffLocation ?? "");
     int length = routeDetail.value?.shipmentDeliveries?.length ?? 0;
      var originCoordinates = await getCoordinatesFromAddress(
          "${routeDetail.value!.shipmentDeliveries?[0].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine1 ?? " "}, ${routeDetail.value!.shipmentDeliveries?[0].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCity ?? " "}, ${routeDetail.value!.shipmentDeliveries?[0].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationState ?? " "}, ${routeDetail.value!.shipmentDeliveries?[0].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationZipcode ?? " "}, ${routeDetail.value!.shipmentDeliveries?[0].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCountry ?? " "}");
      var lastCoordinates = await getCoordinatesFromAddress(
          "${routeDetail.value!.shipmentDeliveries?[length - 1].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine1 ?? " "}, ${routeDetail.value!.shipmentDeliveries?[length - 1].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCity ?? " "}, ${routeDetail.value!.shipmentDeliveries?[length - 1].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationState ?? " "}, ${routeDetail.value!.shipmentDeliveries?[length - 1].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationZipcode ?? " "}, ${routeDetail.value!.shipmentDeliveries?[length - 1].shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCountry ?? " "}");
      startGeoCoordinates.value = originCoordinates!;
      lastGeoCoordinates.value = lastCoordinates!;
      _startWaypoint.value = HERE.Waypoint(startGeoCoordinates.value);
      _destinationWaypoint.value = HERE.Waypoint(lastGeoCoordinates.value);
      startGeoCoordinates.refresh();
      lastGeoCoordinates.refresh();
      /// This method will set the here map data from route details like way point controller points, setting up the start geo coords and destination geo coords , it also sets the way controller points based on the condition of shipment deliveries status
      // currentLocation = lastKnownLocation != null ? lastKnownLocation!.coordinates :(shouldProceedLocationService.value)? Positioning.initPosition:originCoordinates;
      if(isCompletedPassed(routeDetail.value?.status)) {
        currentLocation = originCoordinates;
      }
      else {
        currentLocation =
            GeoCoordinates(currentPosition?.value?.latitude ?? 0.0, currentPosition?.value?.longitude ?? 0.0);
      }
print("Current location...${currentLocation.latitude}, ${currentLocation.longitude}");
      List<WayPointInfo> wayPointsInlistInfo = [];
      if (isLoadedPassed(routeDetail.value?.status) /*?.toLowerCase() == "loaded" || isCompletedPassed(routeDetail.value?.status) || routeDetail.value?.isPaused != 1*/) {
        wayPointsInlistInfo.add(WayPointInfo(coordinates: originCoordinates));
      } else {
        wayPointsInlistInfo.add(WayPointInfo(coordinates: currentLocation));
      }

      for (ShipmentDeliveries item in (routeDetail.value?.shipmentDeliveries ?? [])) {
        if (!(isAllDeliveredPassed(item.deliveryStatus)) &&
            !(isUnDeliveredPassed(item.deliveryStatus)) &&
            !(isCanceledPassed(item.deliveryStatus)) &&
            !(isCompletedPassed(item.deliveryStatus))
        // item.deliveryStatus!="canceled" &&
        //     item.deliveryStatus!="delivered"&&
        //     item.deliveryStatus!="undelivered"&&
        //     item.deliveryStatus!="completed"
        ) {
          var shipCoordinate = await getCoordinatesFromAddress(
              "${item.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine1 ?? " "}, ${item.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCity ?? " "}, ${item.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationState ?? " "}, ${item.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationZipcode ?? " "}, ${item.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCountry ?? " "}");
          if (shipCoordinate != null) {
            wayPointsInlistInfo.add(WayPointInfo(coordinates: shipCoordinate));
          }
        }
      }
      if(isCompletedPassed(routeDetail.value?.status)) {
        wayPointsInlistInfo.add(WayPointInfo(coordinates:lastCoordinates));
      }
      else{
        wayPointsInlistInfo.add(WayPointInfo(coordinates: originCoordinates));
      }


      wayPointsController.value = WayPointsController(
        wayPoints: wayPointsInlistInfo,
        currentLocation: currentLocation,
      );
      wayPointsController.refresh();

      hereMapController.value?.camera
          .lookAtPointWithMeasure(startGeoCoordinates.value, MapMeasure(MapMeasureKind.distance, 10000));
      hereMapController.refresh();
      // displayRoute();
      ///it creates the route based calculating truck route
      initializeRoute();
      refresh();
      update();
    }
  }

  /// Initializes and updates stepper data based on shipment deliveries from the route details response.
  initializeAndUpdateStepperData(RouteDetailsResponse response){
    int? stepperLength = (response.data?.shipmentDeliveries?.length ?? 0);
    stepperData.value = List.generate(
        stepperLength,
            (index) => /*(index==0)? StepperItemData(
            id: '${index + 1}',
            content: ({}),
              avatar: '') : */
        StepperItemData(
          id: '${index + 1}',
          content: ({
            "fork_lift": response.data?.shipmentDeliveries?[index].shipment?.forkLift,
            "loading_complete": response.data?.shipmentDeliveries?[index].loadingComplete,
            "loading_by": response.data?.loadingBy,
            "is_paused": response.data?.isPaused,
            "id": response.data?.shipmentDeliveries?[index].id,
            "name": response.data?.shipmentDeliveries?[index].shipment?.name,
            "costumer_name": response.data?.shipmentDeliveries?[index].shipment?.customer?.name,
            "delivery_date": response.data?.deliveryDate?.toLocal().toString(),
            "routeId": response.data?.shipmentDeliveries?[index].routeId,
            "shipmentId": response.data?.shipmentDeliveries?[index].shipmentId,
            "routeNo": response.data?.shipmentDeliveries?[index].routeNo,
            "deliveryStatus": response.data?.shipmentDeliveries?[index].deliveryStatus,
            "eta": response.data?.shipmentDeliveries?[index].eta,
            "load": response.data?.shipmentDeliveries?[index].load,
            "duration": response.data?.shipmentDeliveries?[index].duration,
            "distance": response.data?.shipmentDeliveries?[index].distance,
            "lat": response.data?.shipmentDeliveries?[index].lat,
            "lng": response.data?.shipmentDeliveries?[index].lng,
            "onTimeDelivery": response.data?.shipmentDeliveries?[index].onTimeDelivery,
            "arrivedAt": response.data?.shipmentDeliveries?[index].arrivedAt,
            "deliveredAt": response.data?.shipmentDeliveries?[index].deliveredAt,
            "undeliveredAt": response.data?.shipmentDeliveries?[index].undeliveredAt,
            "canceledAt": response.data?.shipmentDeliveries?[index].canceledAt,
            "noteByDriver": response.data?.shipmentDeliveries?[index].noteByDriver,
            "customerRating": response.data?.shipmentDeliveries?[index].customerRating,
            "customerFeedback": response.data?.shipmentDeliveries?[index].customerFeedback,
            // todo
            "shipmentProps": response.data?.shipmentDeliveries?[index].shipment!.shipmentProps,

            "pQuantity": response.data?.shipmentDeliveries?[index].pQuantity,
            "rQuantity": response.data?.shipmentDeliveries?[index].rQuantity,
            "tQuantity": response.data?.shipmentDeliveries?[index].tQuantity,
            "createdAt": response.data?.shipmentDeliveries?[index].createdAt?.toLocal().toString(),
            "updatedAt": response.data?.shipmentDeliveries?[index].updatedAt?.toLocal().toString(),
            "shipment": {
              "id": response.data?.shipmentDeliveries?[index].shipment?.id,
              "name": response.data?.shipmentDeliveries?[index].shipment?.name,
              "shipment_customer_delivery_locations": {
                "id": response.data?.shipmentDeliveries?[index].shipment?.shipmentCustomerDeliveryLocations?.id,
                "delivery_contact_name": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryContactName,
                "shipment_id": response
                    .data?.shipmentDeliveries?[index].shipment?.shipmentCustomerDeliveryLocations?.shipmentId,
                "delivery_location_name": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryLocationName,
                "delivery_contact_phone": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryContactPhone,
                "delivery_location_address_line_1": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine1,
                "delivery_location_address_line_2": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine2,
                "delivery_location_city": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryLocationCity,
                "delivery_location_state": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryLocationState,
                "delivery_location_zipcode": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryLocationZipcode,
                "delivery_location_country": response.data?.shipmentDeliveries?[index].shipment
                    ?.shipmentCustomerDeliveryLocations?.deliveryLocationCountry
              },
              "props_delivery_window": {
                "start": response.data?.shipmentDeliveries?[index].shipment?.propsDeliveryWindow?[0].start
                    ?.toLocal()
                    .toString(),
                "end": response.data?.shipmentDeliveries?[index].shipment?.propsDeliveryWindow?[0].end
                    ?.toLocal()
                    .toString(),
              },
              "customer": {
                "id": response.data?.shipmentDeliveries?[index].shipment?.customer?.id,
                "name": response.data?.shipmentDeliveries?[index].shipment?.customer?.name,
              }
            }
          }),
          avatar: '',
        )).toList();

    /// ////////////////////////////////////////////////////////////////////////////////////////////
    modifyingShipmentDeliveriesOnResequence(response);
  }

  /// Modifies shipment deliveries for re-sequencing based on their status and updates related lists.
  modifyingShipmentDeliveriesOnResequence(RouteDetailsResponse response){
    isCompleteRouteLoading.value = "true";
    response.data?.shipmentDeliveries?.asMap().forEach((key, value) {
      if (value.loadingComplete == 0) {
        isCompleteRouteLoading.value = "S_inCompleted_R_inComplete";
      }
    });

    /// Assigned - Self Loading
    isCompleteRouteLoading.value = (response.data?.loadingComplete == 0 &&
        statusToProceedIsDriverAssignedPassed(
            response.data?.status) /* == "driver-assigned"*/) // Assigned-Self Loading
        ? "S_inCompleted_R_inComplete"
        : (response.data?.loadingComplete == 0 &&
        response.data?.status == LOADING &&
        isCompleteRouteLoading.value == "true")
        ? "S_Completed_R_inComplete"
        : (response.data?.loadingComplete == 1 && isLoadedPassed(response.data?.status) /* == "loaded"*/)
        ? "S_Completed_R_Complete"
        : (response.data?.loadingComplete == 1 &&
        isAllDeliveredPassed(response.data?.status) /* == "delivered"*/)
        ? "S_Completed_R_Complete"
        : "S_inCompleted_R_inComplete";
    debugPrint("isCompleteRouteLoading.value >>>  ${isCompleteRouteLoading.value}");

    /// todo Re-order
    /// If copy then don't change original list..
    if (canChangeOrgList.value == true) {
      // debugPrint(">>** orgShipmentListResequence is changed **<<");
      orgShipmentListResequence.clear();

      /// add data in copyShipmentListResequence
      response.data?.shipmentDeliveries?.forEach((element) {
        if (isAllDeliveredPassed(element.deliveryStatus) /* == "delivered"*/ ||
            isUnDeliveredPassed(element.deliveryStatus) /* == "undelivered"*/ ||
            isCanceledPassed(element.deliveryStatus) /* == "canceled"*/ ||
            isCompletedPassed(element.deliveryStatus) /* == "completed"*/) {
          // shipmentListResequence.insert(0, element);
        } else {
          orgShipmentListResequence.add(element);
        }
      });
    }

    /// Shipment List Re-sequence create clone of deliver so that we can change position according to
    /// re-order
    copyShipmentListResequence.clear();
    reSequenceRequest.clear();

    /// add data in copyShipmentListResequence
    response.data?.shipmentDeliveries?.forEach((element) {
      if (isAllDeliveredPassed(element.deliveryStatus) /* == "delivered"*/ ||
          isUnDeliveredPassed(element.deliveryStatus) /* == "undelivered"*/ ||
          isCanceledPassed(element.deliveryStatus) /* == "canceled"*/ ||
          isCompletedPassed(element.deliveryStatus) /* == "completed"*/) {
        // shipmentListResequence.insert(0, element);
      } else {
        copyShipmentListResequence.add(element);
      }
    });

    orgShipmentListResequence.sort((a, b) => a.routeNo!.compareTo(b.routeNo!));
    copyShipmentListResequence.sort((a, b) => a.routeNo!.compareTo(b.routeNo!));

    /// check both list is same or not ?
    int i = 0;
    orgShipmentListResequence.asMap().forEach((key, value) {
      if (copyShipmentListResequence[key].shipment?.name == value.shipment?.name) {
        i = i + 1;
      }
    });
    debugPrint(">> i >>  $i");
    if (i == copyShipmentListResequence.length) {
      isShipmentReOrdered.value = false; // Button gray or not?
    } else {
      isShipmentReOrdered.value = true; // Button gray or not?
    }
  }

  /// Initializes the truck route calculation using the start and destination waypoints.
  /// Updates the `route` with the calculated route or logs an error if the calculation fails.
  initializeRoute() {
    _routeCalculator = RouteCalculator();
    _routeCalculator?.calculateTruckRoute(_startWaypoint.value!, _destinationWaypoint.value!,
        (HERE.RoutingError? routingError, List<HERE.Route>? routeList) async {
      if (routingError == null) {
        // When error is null, it is guaranteed that the routeList is not empty.

        route.value = routeList?.first;
        route.refresh();
        // _showRouteOnMap(_calculatedRoute);
        // _showRouteDetails(_calculatedRoute, false);
      } else {
        final error = routingError.toString();
        if (userRole.value != UserRole.MERCHANDISER.name || userRole.value!=UserRole.LOADER.name) {
          _updateMessageState!("Error while calculating a route: $error");
        }
      }
    });
    refresh();
    update();
  }

  /// Starts a route by initializing the route service, updating route details,
  /// and activating location or pusher services based on user role and route status.
  Future<RouteStartResponse?> startRoute(int routeId) async {
    isLoading.value = true;
    // Get.to(NavigationScreen());
    // routeStart.value = RouteStartResponse();
    var queryParam = RouteStartQueryParam(routeId: routeId.toString());
    if (routeId != 0) {
      var routeStartService =await  _repository.startRoute(queryParam);
      isLoading.value = false;
      if (routeStartService.status == AppString.apiStatusError) {
        Utils.showErrorMessage(routeStartService.message.toString());
      } else {
        routeStart.value = routeStartService;
        routeStart.refresh();
        routeId = routeStart.value?.data?.id ?? 0;
        if (routeDetail.value?.isPaused == 0 && shouldProceedLocationService.value) {
          if (userRole.value != UserRole.MERCHANDISER.name) {
            LocationService locationService = LocationService();
            locationService.initLocationController();
            locationService.route_id = routeDetail.value?.id;
            locationService.startLocationService();
            // Get.to(NavigationScreen());
          } else {
            PusherService pusherService = PusherService();
            pusherService.initPusher(accessToken ?? "", userRole: userRole.value);
          }
        }
        Utils.showSuccessMessage(routeStartService.message.toString());
        getRouteDetails();
        refresh();
        update();
        return routeStart.value;
      }
      // callDataService(routeStartService, onSuccess: _handleStartRouteResponseSuccess, onStart: onStart, onError: (e) {
      //   isLoading.value = false;
      // });
    }
  }



  // MapImage mapImage = MapImage.withFilePathAndWidthAndHeight("assets/images/truck.png", 60, 80);

  ///function to add truck marker
  void addMapMarker(GeoCoordinates geoCoordinates) {
    int markerSize = (UIStyle.locationMarkerSize * hereMapController.value!.pixelScale).truncate();
    mapTruckMarker.value = Util.createMarkerWithImagePath(
      geoCoordinates,
      "assets/images/truck.png",
      markerSize,
      markerSize,
      drawOrder: UIStyle.waypointsMarkerDrawOrder,
    );
    mapTruckMarker.refresh();
    if (mapTruckMarker.value != null) {
      hereMapController.value?.mapScene.addMapMarker(mapTruckMarker.value!);
    } else {
      print("Marker null");
    }

    hereMapController.refresh();
  }

  /// Completes the delivery action for a given stop ID by sending the required details to the API.
  void completeDeliveryAction(String stopId, [String? delivered]) {
    SmartDialog.showLoading();
    if (stopId.isEmpty) {
      // Utils.showErrorMessage("AppString.deliveryDateIdNotBeEmpty");
    } else {
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      var queryParam = CompleteShipmentQueryParam(
          delivery_detail_id: stopId,
          arrived_at: formattedTime,
          type: "",
          attachment: "",
          byteData: null,
          note: "",
          delivered_at: "",
          delivery_latitude: "",
          delivery_longitude: "");
      var completeDeliveryService = _repository.completeShipmentAPI(queryParam);
      callDataService(completeDeliveryService, onSuccess: _handleCompleteShipmentResponseSuccess);
      hideLoading();
    }
  }

  /// Handles the success response for completing a shipment delivery.
  _handleCompleteShipmentResponseSuccess(CompleteShipmentDeliveryRes response) {
    if (response.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      Utils.showErrorMessage(response.message.toString());
    } else {
      SmartDialog.dismiss();
      //print("else");
      Utils.showSuccessMessage(AppString.arrivedAtTheLocation);
    }
    completeShipmentDeliveryResponse.value = response;
    notesTextEditingController.value.text = "";
    // completeShipmentResponseData.value = CompleteShipmentDeliveryRes.fromJson(response.toJson());
    stopId = completeShipmentDeliveryResponse.value?.data?.id;
    selectedReason.value = "pause for a break";
    reasonTextController?.value.text = AppString.arrivedAtLocationForDelivery;
    routeStatus.value = "";
    routePauseLog();
    refresh();
    update();
  }

  /// Completes the delivery for the specified route ID by sending a request to the API and updating the route details.
 Future< RouteCompleteResponse?> completeDelivery(int routeId)async {
    SmartDialog.showLoading();

    var queryParam = CompleteRouteQueryParam(routeId: routeId);
    var completeDeliveryService =await _repository.routeComplete(queryParam);
    // callDataService(completeDeliveryService, onSuccess: _handleCompleteRouteResponseSuccess);
    if (completeDeliveryService.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      Utils.showErrorMessage(completeDeliveryService.message.toString());
    } else {
      completeRoute.value = completeDeliveryService;
      completeRoute.refresh();
      LocationService locationService = LocationService();
      locationService.dispose();
      SmartDialog.dismiss();

      Utils.showSuccessMessage(completeDeliveryService.message.toString());
      return completeRoute.value;
    }

    routeId = routeDetail.value?.id ?? 0;
    getRouteDetails();
    // stopId=completeShipmentDeliveryResponse.value?.data?.id;
    // getStopDetails();
    refresh();
    update();
    hideLoading();
  }

  /// Handles the success response for completing a route and updates route details.
  _handleCompleteRouteResponseSuccess(RouteCompleteResponse response) {

    if (response.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      Utils.showErrorMessage(response.message.toString());
    } else {
      LocationService locationService = LocationService();
      locationService.dispose();
      SmartDialog.dismiss();

      Utils.showSuccessMessage(response.message.toString());
    }

    routeId = routeDetail.value?.id ?? 0;
    getRouteDetails();
    // stopId=completeShipmentDeliveryResponse.value?.data?.id;
    // getStopDetails();
    refresh();
    update();
  }

  /// Cancels a delivery action for the specified stop ID.
  /// Sends cancellation details to the API and updates the route.
  void cancelDeliveryAction(String stopId, String notes, int route_id) {
    routeId = route_id;
    SmartDialog.showLoading();
    if (stopId.isEmpty) {
      // Utils.showErrorMessage("AppString.deliveryDateIdNotBeEmpty");
    } else {
      var queryParam = CompleteShipmentQueryParam(
          delivery_detail_id: stopId,
          arrived_at: "",
          type: "",
          attachment: "",
          byteData: null,
          note: notes,
          delivered_at: "",
          delivery_latitude: "",
          delivery_longitude: "");
      var completeDeliveryService = _repository.cancelShipmentAPI(queryParam);
      callDataService(completeDeliveryService, onSuccess: _handleCancelShipmentResponseSuccess);
      hideLoading();
    }
  }

  /// Handles the success response for canceling a shipment delivery.
  _handleCancelShipmentResponseSuccess(CancelShipmentResponse response) {
    if (response.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      Utils.showErrorMessage(response.message.toString());
    } else {
      SmartDialog.dismiss();
      Utils.showSuccessMessage(response.message.toString());
    }

    Get.back(result: true);
    print('objecthere');
    notesTextEditingController.value.text = "";
    getRouteDetails();
    // stopId=completeShipmentDeliveryResponse.value?.data?.id;
    // getStopDetails();
    refresh();
    update();
  }

  /// Retrieves the current stop ID based on the delivery status.
  Shipment? getCurrentStopId() {
    ShipmentDeliveries? stepperItemData;
    try {
      stepperItemData = routeDetail.value?.shipmentDeliveries?.firstWhere(
          (element) => element.deliveryStatus == IN_TRANSIT_ON_TIME || element.deliveryStatus == IN_TRANSIT_DELAY);
    } catch (e) {}
    return stepperItemData?.shipment;
  }

  /// Completes the route loading process by sending a request to the API.
  void completeRouteLoading() {
    if (routeId != 0) {
      var routeDetailsService = _repository.completeRouteLoading(routeId);
      callDataService(routeDetailsService, onSuccess: _handleCompleteRouteLoadingRes);
    }
  }

  /// Handles the response for completing route loading and updates the UI.
  _handleCompleteRouteLoadingRes(CompleteRouteLoadingRes data) {
    if (data.status == AppString.apiStatusError) {
      Utils.showErrorMessage(data.message.toString());
    } else {
      Get.back(result: true);
      // Utils.showSuccessMessage(data.message.toString());
      // getRouteDetails();
      refresh();
      update();
      // socketService?.onTriggerEventPressed();
    }
  }

  /// Marks all shipments as loaded for a given route and updates the loading status.
  void markAllLoaded(
      {required int routeId, required int loadingComplete}) {
    SmartDialog.showLoading();
    // if (routeId != 0) {
    var markAllLoadedParams = MarkAllLoadedQueryParam(
        routeId: routeId, loadingComplete: loadingComplete);
    var routeDetailsService =
    _repository.markAllLoaded(markAllLoadedParams);
    callDataService(routeDetailsService,
        onSuccess: _handleMarkAllLoaded);
    // }else{
    //   print("routeId is null");
    // }
  }

  /// Handles the response for marking all shipments as loaded.
  /// Updates the route details and refreshes the UI.
  _handleMarkAllLoaded(CommonResponse data) {
    if (data.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      Utils.showErrorMessage(data.message.toString());
    } else {
      SmartDialog.dismiss();
      Utils.showSuccessMessage(data.message.toString());
      getRouteDetails();

      refresh();
      update();
    }
  }

  /// Re-sequences the shipment deliveries for a route based on their order and updates the API.
  Future<void> reSequenceShipments(List<ShipmentDeliveries> shipmentListReSequence, int? routeIds) async {
    reSequenceRequest.clear();
    // currentLocation?.value?.latitude ?? 27.3108198, currentLocation?.value?.longitude ?? -81.9889776

    // await location.value.getLocation().then((location) {
    currentLocation = lastKnownLocation != null ? lastKnownLocation!.coordinates : Positioning.initPosition;
    // });

    shipmentListReSequence.asMap().forEach((key, element) {
      reSequenceRequest.add(ReSequenceRequest(
          routeNo: key + 1,
          id: element.id,
          routeId: copyShipmentListResequence[key].routeId,
          lat: currentLocation?.latitude.toString() ?? "27.3108198",
          lng: currentLocation?.longitude.toString() ?? "-81.9889776"));
    });

    routeId = copyShipmentListResequence[0].routeId!;
    var resp = _repository.reSequenceShipments(reSequenceRequest);
    callDataService(resp, onSuccess: (ReSequenceRes response) {
      /// If error while fetching API
      routeId = routeDetail.value?.id ?? 0;
      if (response.status == AppString.apiStatusError) {
        // getRouteDetails();
        // Get.back(result: true);
      } else {
        debugPrint(">>* ReSequenceShipmentsResponse is Success *<<");
        debugPrint(">>* getRouteDetails is Success *<<");
        getRouteDetails();
        // Get.back(result: true);
      }
    });
  }

  /// Cancels the re-sequencing operation and restores the original shipment order.
  void onCancelClick() {
    SmartDialog.showLoading();
    reSequenceShipments(orgShipmentListResequence, routeId).then((value) {
      SmartDialog.dismiss();
      Get.back();
    });
  }

  /// Confirms the re-sequencing of shipments and updates the route details.
  void onConfirmClick() {
    SmartDialog.showLoading();
    reSequenceShipments(copyShipmentListResequence, routeId).then((value) {
      SmartDialog.dismiss();
      Get.back(result: true);
    });
  }

  /// Calculates the Estimated Time of Arrival (ETA) and distance for a list of shipments.
  /// Updates the shipment list with the calculated values and checks for reordering changes.
  Future<void> getETA(List<ShipmentDeliveries> shipmentListReSequence, int? routeIds) async {
    // await getETAResque(27.3333784,-83.1473704);
    reSequenceRequest.clear();
    // currentLocation?.value?.latitude ?? 27.3108198, currentLocation?.value?.longitude ?? -81.9889776
    // await location.value.getLocation().then((location) {
    currentLocation = lastKnownLocation != null ? lastKnownLocation!.coordinates : Positioning.initPosition;
    // });
    shipmentListReSequence.asMap().forEach((key, element) {
      reSequenceRequest.add(ReSequenceRequest(
          routeNo: key + 1,
          id: element.id,
          routeId: copyShipmentListResequence[key].routeId,
          lat: currentLocation?.latitude.toString() ?? "27.3108198",
          //"27.2636077", //
          lng: currentLocation?.longitude.toString() ?? "-81.9889776" //"-81.9911578", //
          ));
    });
    routeId = copyShipmentListResequence[0].routeId!;
    // var resp = _repository.getETA(reSequenceRequest);
    // callDataService(resp, onSuccess: (GetEtaResponse response) {
    /// If error while fetching API
    routeId = routeDetail.value?.id ?? 0;
    // if (response.status == AppString.apiStatusError) {
    //   // getRouteDetails();
    //   // Get.back(result: true);
    // } else {

    List<ShipmentDeliveries> tempShipmentListReSequences = [];
    tempShipmentListReSequences.addAll(copyShipmentListResequence);
    copyShipmentListResequence.clear();

    int totalEta = 0;
    int totalDistance = 0;

    tempShipmentListReSequences.asMap().forEach((key, value) {
      totalDistance = route.value?.lengthInMeters ?? 0;
      value.copyDistance = 0;
      value.copyDistance = totalDistance / 1000;
      //3 hours 48 mins
      //58 mins

      int? duration = 0;
      duration = route.value?.duration.inMinutes ?? 0;
      // if (response.data?[key].duration?.text!.split(" ").length == 2) {
      //   duration = int.parse(response.data?[key].duration?.text?.split(" ")[0] ?? "0");
      // } else {
      //   int hours = int.parse(response.data?[key].duration?.text?.split(" ")[0] ?? "0");
      //   int mints = int.parse(response.data?[key].duration?.text?.split(" ")[2] ?? "0");
      //   duration = (hours * 60) + mints;
      // }
      totalEta = (totalEta + duration);
      value.eta = 0;
      value.eta = totalEta;
      debugPrint(">>** ${value.eta} ${duration} **<<");
    });
    copyShipmentListResequence.addAll(tempShipmentListReSequences);
    refresh();
    update();

    // orgShipmentListResequence.sort((a, b) => a.routeNo!.compareTo(b.routeNo!));
    // copyShipmentListResequence.sort((a, b) => a.routeNo!.compareTo(b.routeNo!));

    /// check both list is same or not ?
    int i = 0;
    orgShipmentListResequence.asMap().forEach((key, value) {
      if (copyShipmentListResequence[key].shipment?.name == value.shipment?.name) {
        i = i + 1;
      }
    });
    debugPrint(">> i >>  $i");
    if (i == copyShipmentListResequence.length) {
      isShipmentReOrdered.value = false; // Button gray or not?
    } else {
      isShipmentReOrdered.value = true; // Button gray or not?
    }
    refresh();
    update();

    // debugPrint(">>** ReSequenceShipmentsResponse is Success **<<");
    // debugPrint(">>** getRouteDetails is Success **<<");
    // getRouteDetails();
    // Get.back(result: true);
    // }
    // });
  }

}
