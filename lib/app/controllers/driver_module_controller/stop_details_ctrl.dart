/// \[StopDetailsController\] is responsible for managing the state and logic related to stop details.
/// It handles API calls, data processing, and UI updates for stop details, including delivery actions,
/// location tracking, and timer management.


import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';


import 'package:bethel_farm/data/model/response/pinpoint_and_fhf_response.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/complete_shipment_query_param.dart';
import 'package:bethel_farm/modules/dashboard/stop_details/pinpoint_query_param.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:here_sdk/mapview.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:get/get.dart' as getx;

import '../../../../base/base_controller.dart';
import '../../../../core/app_string/app_strings.dart';
import '../../../../data/local/preference_manager.dart';
import '../../../../data/model/response/complete_shipment_delivery.dart';
import '../../../../data/model/response/loader_dashboard_response.dart';
import '../../../../data/model/response/stop_details_response.dart';
import '../../../data/enums/user_role.dart';
import '../../../data/model/common/common_user.dart';
import '../../../data/model/response/cancel_shipment_response.dart';
import '../../../data/model/response/directions_model.dart';
import '../../../data/remote/repositories/repository.dart';
import '../../../data/remote/repositories/repository_impl.dart';
import '../../../../utils/utils.dart';
import 'package:geocoding/geocoding.dart' hide Location;

import '../../../here_map_module/common/here_map_util.dart';
import '../../../modules/dashboard/route/route_detail_controller.dart';
import '../../../utils/constants.dart';
import '../../../modules/loader/loader_route_detail/route_details_ctrl.dart';

class StopDetailsController extends BaseController {
  final Repository _repository = getx.Get.isRegistered<Repository>()
      ? Get.find<Repository>()
      : Get.put(RepositoryImpl());

  final PreferenceManager _preferenceManager = getx.Get.find(tag: (PreferenceManager).toString());

  // int routeId = Get.arguments['route_id'] ?? 0;
  // Rx<StopDetailsData> routeDetail = StopDetailsData().obs;

  StreamController<ErrorAnimationType>? errorController;

  //late final TabController tabController  = TabController(length: 2, vsync: this);

  // var shipmentDeliveriesArr= <RouteItem>[].obs;

  ///Initializing model class object to save all data or response and access it in view class to represent
  Rx<StopDetailsResponse?> responseData = StopDetailsResponse().obs;

  ///Initializing model class object to save all data or response and access it in view class to represent
  Rx<PinPointAndFhfResponse?> pinpointResponse = PinPointAndFhfResponse().obs;

  int? stopId =0;
  // Rx<CompleteShipmentDeliveryRes?> completeShipmentResponseData = CompleteShipmentDeliveryRes().obs;
  RxString  userRole= "".obs;
  Rx<File>? image=File("").obs;
  Rx<ValueNotifier<String?>> svg = ValueNotifier<String?>(null).obs;
  Rx<ValueNotifier<ByteData?>> rawImage = ValueNotifier<ByteData?>(null).obs;
  Rx<ValueNotifier<ByteData?>> rawImageFit = ValueNotifier<ByteData?>(null).obs;
  RxString imageType="".obs;
  RxBool markCurrentPoint = false.obs;
  Rx<TextEditingController> notesTextEditingController=TextEditingController().obs;
  Rx<TextEditingController> cancelTextEditingController=TextEditingController().obs;
  // GoogleMapController? googleMapController;
  Rx<LocationData?> currentLocation = Rx<LocationData?>(null);
  Rx<Location>? location = Location().obs;
  // Rx<Completer<GoogleMapController>> controllerMap =
  //     Completer<GoogleMapController>().obs;
  /// Initializing User object to access data like id, name etc....
  Rx<User> user = User().obs;
  RxString address="".obs;
  // RxSet<Polyline> polyLines = <Polyline>{}.obs;
  // String? origin = 'Chicago, IL';
  // String? destination = 'Los Angeles, CA';
  // Rx<Directions?> directions = Directions().obs;
  String? deliveredAt;
  RxInt? count=0.obs;
  RxBool imageFound = false.obs;
  RxBool signatureFound = false.obs;
  Rx<CompleteShipmentDeliveryRes?> completeShipmentDeliveryResponse = CompleteShipmentDeliveryRes().obs;
  // RxSet<Marker> markersList = <Marker>{}.obs;
  RxBool isWithinWindow=false.obs;
  RxBool isWithinDeliveredWindow=false.obs;
  RxBool isWithinUndeliveredWindow=false.obs;
  Timer? _timer;
  Rx<HereMapController?> hereMapController = Rx(null);

  /// Initializes the controller, sets up the error stream, retrieves the user role, and fetches stop details.
  @override
  void onInit() async{

    errorController = StreamController<ErrorAnimationType>();
    userRole.value = await _preferenceManager.getString(PreferenceManager.userRole);
    getStopDetails();
    super.onInit();
  }



  var sDuration = "".obs;

  /// Starts a timer to calculate the elapsed time since the `arrivedAt` timestamp.
  void _startTimer() {
    const duration = Duration(seconds: 1);
    _timer = Timer.periodic(duration, (Timer timer) {

      String arrivedAt = responseData.value?.data?.arrivedAt?.toIso8601String() ?? "";
      if(arrivedAt.isNotEmpty){
        // Parse the "arrived_at" time
        DateTime arrivedDateTime = DateTime.parse(arrivedAt);

        // Calculate the difference between arrived_at and current time
        Duration difference = DateTime.now().difference(arrivedDateTime);
        sDuration.value = "${(difference.inHours).toString().padLeft(2, '0')}:${(difference.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(difference.inSeconds.remainder(60)).toString().padLeft(2, '0')}";
        print("Timer completed!${sDuration}");
        sDuration.refresh();
        update();
      }
    });
  }

  /// Stops the timer and resets the elapsed duration.
  void stopTimer() {
    _timer?.cancel();
    sDuration.value = "";
    sDuration.refresh();
  }

  /// Checks if the `arrivedAt` time falls within the specified delivery window.
  bool isArrivedTimeWithinDeliveryWindow(String arrivedAt, DateTime start, DateTime end) {
    DateTime arrivedDateTime = DateTime.parse(arrivedAt);
    String startDateTime=Utils.formatUtcDateTimeSeconds(start.toIso8601String());
    String endDateTime=Utils.formatUtcDateTimeSeconds(end.toIso8601String());

    DateTime startDate = DateTime.parse(startDateTime);
    DateTime endDate = DateTime.parse(endDateTime);
    if (arrivedDateTime.isAfter(startDate) && arrivedDateTime.isBefore(endDate)) {
      return true;
    }

    return false;
  }

  /// Retrieves the current location and updates the UI.
  void getCurrentLocation({double zoomLevel=13}) async {
    location?.value.getLocation().then((location) {
      currentLocation.value = location;
    },
    );
    update();
  }

  /// Disposes resources such as the error controller and stops the timer.
  @override
  void dispose() {
    errorController!.close();
    stopTimer();
    super.dispose();
  }

  /// Fetches stop details based on the `stopId` and processes the response.
  void getStopDetails() {
    print(stopId);
    if(stopId==null || stopId==0){
      print("stop is null");
    }
    else {
      var stopDetailsService = _repository.getStopDetails(stopId??0);
      //   var stopDetailsService = _repository.getStopDetails(stopId);
      callDataService(
          stopDetailsService, onSuccess: _handleStopDetailsResponseSuccess);
    }


  }

  /// Processes the stop details response, updates the UI, and manages delivery status and timers.
  _handleStopDetailsResponseSuccess(StopDetailsResponse response) {
    print(_handleStopDetailsResponseSuccess);
    if (response.status == AppString.apiStatusError) {
      Utils.showErrorMessage(response.message.toString());
    } else {
      // Utils.showSuccessMessage(response.message.toString());
    }
    imageFound.value = false;
    signatureFound.value = false;
    responseData.value = StopDetailsResponse.fromJson(response.toJson());
    count?.value=0;
    if (responseData.value?.data?.noteByDriver?.isNotEmpty ?? false) {
      count?.value++;
    }
    if (responseData.value?.data?.deliveryProofs?.isNotEmpty ?? false) {
      for (int i = 0; i < (responseData.value?.data?.deliveryProofs?.length ?? 0); i++) {
        if (responseData.value?.data?.deliveryProofs?[i].type == "image") {
          imageFound.value = true;
        } else if (responseData.value?.data?.deliveryProofs?[i].type == "signature") {
          signatureFound.value = true;
        }

        // Break the loop if both "image" and "signature" are found
        if (imageFound.value && signatureFound.value) {
          break;
        }
      }

      // Increase count by 2 if both "image" and "signature" are found
      if (imageFound.value && signatureFound.value) {
        count?.value += 2;
      }else if((imageFound.value || signatureFound.value)){
        count?.value++;
      }
    }
    refresh();
    // getPolyPoints();
    update();
    if(responseData.value?.data?.deliveryStatus?.toLowerCase() == "delivered"){
      stopTimer();
      String delivered_at = responseData.value?.data?.delivered_at?.toIso8601String() ?? "";
      String arrived_at = responseData.value?.data?.arrivedAt?.toIso8601String() ?? "";
      print(delivered_at);
      print(arrived_at);
      if(delivered_at.isNotEmpty){
        // Parse the "arrived_at" time
        DateTime deliveredDateTime = DateTime.parse(delivered_at);
        DateTime arrivedDateTime = DateTime.parse(arrived_at);

        // Calculate the difference between arrived_at and current time
        Duration difference = deliveredDateTime.difference(arrivedDateTime);
        sDuration.value = "${(difference.inHours).toString().padLeft(2, '0')}:${(difference.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(difference.inSeconds.remainder(60)).toString().padLeft(2, '0')}";
        print("Timer completed!${sDuration}");
        sDuration.refresh();
        update();
      }
    }else if(responseData.value?.data?.deliveryStatus?.toLowerCase() == "undelivered"){
      stopTimer();
      String delivered_at = responseData.value?.data?.undelivered_at?.toIso8601String() ?? "";
      String arrived_at = responseData.value?.data?.arrivedAt?.toIso8601String() ?? "";
      print(delivered_at);
      print(arrived_at);
      if(delivered_at.isNotEmpty){
        // Parse the "arrived_at" time
        DateTime deliveredDateTime = DateTime.parse(delivered_at);
        DateTime arrivedDateTime = DateTime.parse(arrived_at);

        // Calculate the difference between arrived_at and current time
        Duration difference = deliveredDateTime.difference(arrivedDateTime);
        sDuration.value = "${(difference.inHours).toString().padLeft(2, '0')}:${(difference.inMinutes.remainder(60)).toString().padLeft(2, '0')}:${(difference.inSeconds.remainder(60)).toString().padLeft(2, '0')}";
        print("Timer completed!${sDuration}");
        sDuration.refresh();
        update();
      }
    }else{
      if(responseData.value?.data?.arrivedAt!=null){
        stopTimer();
        _startTimer();
      }
    }

  }

  /// Adds FHF notes for a stop, including location details and user information.
  void addPinFhFNotes(String stopId) async {
    // await fetchAddressFromCoordinates(currentLocation.value?.latitude ?? 27.3108198,
    //     currentLocation.value?.longitude ?? -81.9889776);
    address.value=await getCoordinatesPlace(currentLocation.value?.latitude ?? 27.3108198,currentLocation.value?.longitude ?? -81.9889776)??"";
    if(stopId.isEmpty){
      print("stop is null");
    }
    else {
      final rawJson = await _preferenceManager.getString(PreferenceManager.userData);
      Map<String, dynamic> map = jsonDecode(rawJson.toString());
      user.value = User.fromJson(map);
      var queryParam = PinPointQueryParam(shipmentId: stopId,
          fhfNotes: cancelTextEditingController.value.text??"",
          address: address.value, latitude: currentLocation.value?.latitude.toString(),
          longitude:currentLocation.value?.longitude.toString(),addedBy: user.value.id.toString());
      var stopDetailsService = _repository.addPinFhFNotes(queryParam);
      callDataService(
          stopDetailsService, onSuccess: _handlePinPointResponseSuccess);
    }


  }

  /// Handles the response for adding PinPoint and FHF notes, updates the UI, and navigates back.
  _handlePinPointResponseSuccess(PinPointAndFhfResponse response) {
    if (response.status == AppString.apiStatusError) {
      Utils.showErrorMessage(response.message.toString());
    } else {
      // Utils.showSuccessMessage(response.message.toString());
    }
    pinpointResponse.value = PinPointAndFhfResponse.fromJson(response.toJson());
    Get.back(result: true);
    //print(responseData.value!.data!.routes.deliveryDate);
    refresh();
    update();

  }

  // void displayCurrentLocation(){
  //   markersList.clear();
  //   if (userRole.value != UserRole.MERCHANDISER.name) {
  //     markersList.add(Marker(
  //       markerId: const MarkerId('current_location'),
  //       position: LatLng(currentLocation.value?.latitude ?? 27.3108198,
  //           currentLocation.value?.longitude ?? -81.9889776),
  //       infoWindow: const InfoWindow(
  //         title: 'Current Location',
  //       ),
  //       icon: BitmapDescriptor.defaultMarkerWithHue(getRandomHue()),
  //     ));
  //   }
  //   update();
  // }







  // Future<Directions?> getPolyPoints() async {
  //   origin = responseData.value?.data?.routes?.originPoints ?? "";
  //   destination = responseData.value?.data?.routes?.lastDropoffLocation ?? "";
  //
  //   final dio = Dio();
  //   final response = await dio.get(
  //     'https://maps.googleapis.com/maps/api/directions/json',
  //     queryParameters: {
  //       'origin': origin ?? "",
  //       'destination': destination ?? "",
  //       'key': googleApiKey,
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     directions.value = Directions.fromMap(response.data);
  //     final data = Map<String, dynamic>.from(response.data['routes'][0]);
  //     return directions.value;
  //   }
  //   update();
  //   return null;
  // }

  // double getRandomHue() {
  //   // Generate a random hue value between 0 and 360
  //   return Random().nextDouble() * 360;
  // }

  Future<void> completeDeliveryAction(String stopId, [String? delivered]) async {
    SmartDialog.showLoading();
    if (stopId.isEmpty) {
      // Utils.showErrorMessage("AppString.deliveryDateIdNotBeEmpty");
    }
    else
    {
      await location?.value.getLocation().then((location) {
        currentLocation.value = location;
        update();
      },
      );
      if(imageType.value=="" && notesTextEditingController.value.text=="" && delivered=="delivered_at"){
        deliveredAt=delivered;
        DateTime now = DateTime.now();
        String formattedTimeDeliveredAt = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        print(currentLocation.value?.latitude.toString());
        print(formattedTimeDeliveredAt);
        var queryParam = CompleteShipmentQueryParam(delivery_detail_id: stopId, arrived_at: "",type: "",attachment: "",byteData: null,note: "",delivered_at: formattedTimeDeliveredAt,delivery_latitude: currentLocation.value?.latitude.toString(),delivery_longitude:currentLocation.value?.longitude.toString());
        var completeDeliveryService = _repository.completeShipmentAPI(queryParam);
        callDataService(completeDeliveryService, onSuccess: _handleCompleteShipmentResponseSuccess);
      }else if(imageType.value=="" && notesTextEditingController.value.text=="" && delivered!="delivered_at"){
        DateTime now = DateTime.now();
        String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
        var queryParam = CompleteShipmentQueryParam(delivery_detail_id: stopId, arrived_at: formattedTime,type: "",attachment: "",byteData: null,note: "",delivered_at: "",delivery_latitude: "",delivery_longitude:"");
        var completeDeliveryService = _repository.completeShipmentAPI(queryParam);
        callDataService(completeDeliveryService, onSuccess: _handleCompleteShipmentResponseSuccess);
      }
      else{
        if(imageType.value=="image") {
          var queryParam = CompleteShipmentQueryParam(delivery_detail_id: stopId, arrived_at: "",type: imageType.value,attachment: image?.value.path,byteData: null,note: "",delivered_at: "",delivery_latitude: "",delivery_longitude:"");
          var completeDeliveryService = _repository.completeShipmentAPI(
              queryParam);
          callDataService(completeDeliveryService,
              onSuccess: _handleCompleteShipmentResponseSuccess);
        }else if(imageType.value=="signature") {
          var queryParam = CompleteShipmentQueryParam(delivery_detail_id: stopId, arrived_at: "",type: imageType.value,attachment: "",byteData: rawImage.value.value,note: "",delivered_at: "",delivery_latitude: "",delivery_longitude:"");
          var completeDeliveryService = _repository.completeShipmentAPI(
              queryParam);
          callDataService(completeDeliveryService,
              onSuccess: _handleCompleteShipmentResponseSuccess);
        }else if(notesTextEditingController.value.text!="") {
          var queryParam = CompleteShipmentQueryParam(delivery_detail_id: stopId, arrived_at: "",type: "",attachment: "",byteData: null,note: notesTextEditingController.value.text,delivered_at: "",delivery_latitude: "",delivery_longitude:"");
          var completeDeliveryService = _repository.completeShipmentAPI(
              queryParam);
          callDataService(completeDeliveryService,
              onSuccess: _handleCompleteShipmentResponseSuccess);
          hideLoading();
        }
      }
    }

  }

  _handleCompleteShipmentResponseSuccess(CompleteShipmentDeliveryRes response) {
    if (response.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      // Utils.showErrorMessage(response.message.toString());
    } else {
      SmartDialog.dismiss();
      //print("else");
      // Utils.showSuccessMessage(response.message.toString());

    }
    completeShipmentDeliveryResponse.value=response;
    if(deliveredAt=="delivered_at"){
      Get.back(result: true);
    }
    // stopId="";
    imageType.value = "";
    image?.value=File("");
    rawImage.value.value = null;
    svg.value.value = null;
    rawImageFit.value.value = null;
    notesTextEditingController.value.text = "";
    cancelTextEditingController.value.text = "";
    // completeShipmentResponseData.value = CompleteShipmentDeliveryRes.fromJson(response.toJson());
    stopId=completeShipmentDeliveryResponse.value?.data?.id;
    deliveredAt="";
    getStopDetails();
    refresh();
    update();

  }

  void cancelDeliveryAction(String stopId,String notes) {
    if (stopId.isEmpty) {
      // Utils.showErrorMessage("AppString.deliveryDateIdNotBeEmpty");
    }
    else
    {
      var queryParam = CompleteShipmentQueryParam(delivery_detail_id: stopId, arrived_at: "",type: "",attachment: "",
          byteData: null,note: notes,delivered_at: "");
      var completeDeliveryService = _repository.cancelShipmentAPI(
          queryParam);
      callDataService(completeDeliveryService,
          onSuccess: _handleCancelShipmentResponseSuccess);
    }

  }

  _handleCancelShipmentResponseSuccess(CancelShipmentResponse response) {
    if (response.status == AppString.apiStatusError) {
      Utils.showErrorMessage(response.message.toString());
    } else {
      Utils.showSuccessMessage(response.message.toString());
    }

    notesTextEditingController.value.text="";
    cancelTextEditingController.value.text="";
    stopId=responseData.value?.data?.id;
    getStopDetails();
    Get.put(RouteDetailController()).getRouteDetails();
    refresh();
    update();

  }

}