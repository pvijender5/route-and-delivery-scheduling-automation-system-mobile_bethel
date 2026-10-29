/// \[RemoteDataSourceImpl\]
///
/// This class implements the `RemoteDataSource` interface and provides concrete methods
/// for interacting with remote APIs using the Dio HTTP client. It handles various
/// operations such as user authentication, fetching dashboard data, managing routes,
/// shipments, and notifications.
///
/// Key Features:
/// - Implements API calls for login, logout, password management, and OTP verification.
/// - Provides methods for fetching dashboard data for different user roles (e.g., driver, merchandiser).
/// - Handles shipment-related operations such as loading, unloading, and inventory management.
/// - Supports route-related operations including start, pause, and completion.
/// - Utilizes `PreferenceManager` for token management.
/// - Parses API responses into corresponding model classes.
///
/// Dependencies:
/// - `Dio` for HTTP requests.
/// - `PreferenceManager` for local storage.
/// - Various query parameter and response model classes.
///
/// Usage:
/// Instantiate this class and use its methods to interact with the backend APIs.

import 'dart:convert';

import 'package:bethel_farm/base/base_remote_source.dart';
import 'package:bethel_farm/data/model/common/common_response.dart';
import 'package:bethel_farm/data/model/request/update_lat_long_request.dart';
import 'package:bethel_farm/data/model/response/accept_loadnoard_routes_response.dart';
import 'package:bethel_farm/data/model/response/assign_subdrivers_route_response.dart';
import 'package:bethel_farm/data/model/response/bubble_count_response.dart';
import 'package:bethel_farm/data/model/response/cancel_shipment_response.dart';
import 'package:bethel_farm/data/model/response/carrier_owner_subdrivers_response.dart';
import 'package:bethel_farm/data/model/response/carrier_owner_work_dairy_res.dart';
import 'package:bethel_farm/data/model/response/complete_inventory_loading_res.dart';
import 'package:bethel_farm/data/model/response/complete_route_loading.dart';
import 'package:bethel_farm/data/model/response/driver_dashboard_response.dart';
import 'package:bethel_farm/data/model/response/driver_work_dairy_res.dart';
import 'package:bethel_farm/data/model/response/login_response.dart';
import 'package:bethel_farm/data/model/response/pickup_order_detail_response.dart';
import 'package:bethel_farm/data/model/response/pickup_orders_response.dart';
import 'package:bethel_farm/data/model/response/pinpoint_and_fhf_response.dart';
import 'package:bethel_farm/data/model/response/re_sequence_res.dart';
import 'package:bethel_farm/data/model/response/resequence_req.dart';
import 'package:bethel_farm/data/model/response/route_pause_log_response.dart';
import 'package:bethel_farm/data/model/response/route_start_response.dart';
import 'package:bethel_farm/data/model/response/shiplement_uload_res.dart';
import 'package:bethel_farm/data/model/response/shipment_inventory_response.dart';
import 'package:bethel_farm/data/model/response/shipmentunload.dart';
import 'package:bethel_farm/data/model/response/stop_loading_res.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/accept_loadboard_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/assign_driver_route_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/change_pass_query_param.dart';
import 'package:bethel_farm/data/model/response/stop_details_response.dart';
import 'package:bethel_farm/data/model/response/verify_otp_res.dart';
import 'package:bethel_farm/data/network/dio_provider.dart';
import 'package:bethel_farm/data/remote/remote_data_source.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/co_work_dairy_req.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/complete_inventory_query_params.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/complete_shipment_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/common_dashboard_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/forgot_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/get_driver_work_dairy.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/loadboardAssignedRouteByCO.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/loader_dashboard_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/login_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/mark_all_loaded_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/merchandiser_dashboard_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/my_load_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/route_search_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/send_email_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/verify_otp_query_param.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/route_pause_log_query_params.dart';
import 'package:bethel_farm/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import '../../modules/dashboard/route/complete_route_query_param.dart';
import '../../modules/dashboard/route/route_start_query_param.dart';
import '../../modules/dashboard/stop_details/pinpoint_query_param.dart';
import '../model/response/email_response.dart';
import '../model/response/get_eta_res.dart';
import '../model/response/my_loads_response.dart';
import '../model/response/notification_list_response.dart';
import '../local/preference_manager.dart';
import '../model/response/admin_detail_response.dart';
import '../model/response/carrierowner_dashboard_response.dart';
import '../model/response/change_password_res.dart';
import '../model/response/complete_shipment_delivery.dart';
import '../model/response/complete_shipment_loading_response.dart';
import '../model/response/forgot_pwd_res.dart';
import '../model/response/getLoadboardData.dart';
import '../model/response/loader_dashboard_response.dart';
import '../model/response/logout_response.dart';
import '../model/response/merchandiser_cities.dart';
import '../model/response/merchandiser_dashboard_response.dart';
import '../model/response/route_complete_response.dart';
import '../model/response/route_details_response.dart';
import '../model/response/shipment_inventory_response.dart';
import '../model/response/subdriver_dashboard_response.dart';
import '../model/response/routes_response.dart';
import '../model/response/user_detail.dart';

class RemoteDataSourceImpl extends BaseRemoteSource implements RemoteDataSource {
  // final PreferenceManager _preferenceManager = getx.Get.find(tag: (PreferenceManager).toString());
  FormData? formData;

  RemoteDataSourceImpl() {
    getToken();
  }

  ///Login
  @override
  Future<LoginRes> loginUser(LoginQueryParam queryParam) {
    var endpoint = "${DioProvider.baseUrl}/login";
    var dioCall = dioClient.post(endpoint, queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseLoginResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  LoginRes _parseLoginResponse(Response<dynamic> response) {
    return LoginRes.fromJson(response.data);
  }

  ///Forgot Password
  @override
  Future<ForgotPwdRes> forgotPwd(ForgotPwdQueryParam queryParam) {
    var endpoint = "${DioProvider.baseUrl}/forgotPassword";
    var dioCall = dioClient.post(endpoint, queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseForgotResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  ForgotPwdRes _parseForgotResponse(Response<dynamic> response) {
    return ForgotPwdRes.fromJson(response.data);
  }

  /// Change Password
  @override
  Future<ChangePwdRes> changePwd(ChangePwdQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/changePassword";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseChangePwdResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  ///Fetching Stop Details
  @override
  Future<StopDetailsResponse> getStopDetails(int stopId) async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/getDeliveryDetails/$stopId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseStopDetails(response));
    } catch (e) {
      rethrow;
    }
  }

  StopDetailsResponse _parseStopDetails(Response<dynamic> response) {
    return StopDetailsResponse.fromJson(response.data);
  }

  ///Fetching PickUp Orders
  @override
  Future<BubbleCountResponse> getBubbleCount() async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/userbubblecount";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithWithoutErrorMessage(dioCall).then((response) => _parseGetBubbleCount(response));
    } catch (e) {
      rethrow;
    }
  }

  BubbleCountResponse _parseGetBubbleCount(Response<dynamic> response) {
    return BubbleCountResponse.fromJson(response.data);
  }

  ///Fetching PickUp Orders
  @override
  Future<PickupOrdersResponse> getPickUpOrders() async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/pickupShipments";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parsePickUpOrders(response));
    } catch (e) {
      rethrow;
    }
  }

  PickupOrdersResponse _parsePickUpOrders(Response<dynamic> response) {
    return PickupOrdersResponse.fromJson(response.data);
  }

  ///Fetching Route Details
  @override
  Future<RouteDetailsResponse> getRouteDetails(int routeId) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};
    var endpoint = "${DioProvider.baseUrl}/getRoutes/$routeId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseRouteDetails(response));
    } catch (e) {
      rethrow;
    }
  }

  RouteDetailsResponse _parseRouteDetails(Response<dynamic> response) {
    return RouteDetailsResponse.fromJson(response.data);
  }

  ///Complete Shipment
  @override
  Future<CompleteShipmentDeliveryRes> completeShipmentAPI(CompleteShipmentQueryParam queryParam) async {
    String? accessToken = await getToken();
    var endpoint = "${DioProvider.baseUrl}/completeShipmentDelivery";
    // Create a FormData object to include both JSON data and the image file
    if (queryParam.type == "image") {
      formData = FormData.fromMap({
        "delivery_detail_id": queryParam.delivery_detail_id,
        // Add your JSON data here
        "type": queryParam.type,
        // Add your JSON data here
        "attachment": await MultipartFile.fromFile(
          queryParam.attachment ?? "",
          // Replace with the path to your image file
          filename: "image.jpg", // Replace with the desired filename
        ),
      });
    } else if (queryParam.type == "signature") {
      List<int> byteList = queryParam.byteData?.buffer.asUint8List() ?? [];
      formData = FormData.fromMap({
        "delivery_detail_id": queryParam.delivery_detail_id,
        // Add your JSON data here
        "type": queryParam.type,
        // Add your JSON data here
        "attachment": await MultipartFile.fromBytes(
          byteList,
          // Replace with the path to your image file
          filename: "image.jpg", // Replace with the desired filename
        ),
      });
    } else if (queryParam.note != "") {
      formData = FormData.fromMap({
        "delivery_detail_id": queryParam.delivery_detail_id,
        // Add your JSON data here
        "note_by_driver": queryParam.note,
      });
    } else if (queryParam.arrived_at != "") {
      formData = FormData.fromMap({
        "delivery_detail_id": queryParam.delivery_detail_id,
        // Add your JSON data here
        "arrived_at": queryParam.arrived_at,
      });
    } else if (queryParam.delivered_at != "") {
      print('hereitcomes');
      formData = FormData.fromMap({
        "delivery_detail_id": queryParam.delivery_detail_id,
        // Add your JSON data here
        "delivered_at": queryParam.delivered_at,
        "delivery_latitude": queryParam.delivery_latitude,
        "delivery_longitude": queryParam.delivery_longitude,
      });
    }
    var dioCall = dioClient.post(endpoint,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $accessToken",
        }),
        data: formData);
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseCompleteShipment(response));
    } catch (e) {
      rethrow;
    }
  }

  CompleteShipmentDeliveryRes _parseCompleteShipment(Response<dynamic> response) {
    return CompleteShipmentDeliveryRes.fromJson(response.data);
  }

  ///Complete Shipment
  @override
  Future<CancelShipmentResponse> cancelShipmentAPI(CompleteShipmentQueryParam queryParam) async {
    String? accessToken = await getToken();
    var shipmentId = queryParam.delivery_detail_id;
    var endpoint = "${DioProvider.baseUrl}/cancelShipmentFromRoute/$shipmentId";
    // Create a FormData object to include both JSON data and the image file

    var dioCall = dioClient.put(endpoint,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $accessToken",
        }),
        queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseCancelShipment(response));
    } catch (e) {
      rethrow;
    }
  }

  CancelShipmentResponse _parseCancelShipment(Response<dynamic> response) {
    return CancelShipmentResponse.fromJson(response.data);
  }

  ///Logout
  @override
  Future<LogoutResponse> logoutUser() async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/logout";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseLogoutResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  LogoutResponse _parseLogoutResponse(Response<dynamic> response) {
    return LogoutResponse.fromJson(response.data);
  }

  _parseChangePwdResponse(Response<dynamic> response) {
    return ChangePwdRes.fromJson(response.data);
  }

  ///Verify OTP
  @override
  Future<VerifyOtpRes> verifyOtp(VerifyOtpQueryParam queryParam) {
    var endpoint = "${DioProvider.baseUrl}/otpVerification";
    var dioCall = dioClient.post(endpoint, queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseVerifyOtpResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseVerifyOtpResponse(Response<dynamic> response) {
    return VerifyOtpRes.fromJson(response.data);
  }

  ///Fetching Loader Dashboard Details
  @override
  Future<LoaderDashboardResponse> loaderDashboardAPI(LoaderDashboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/getRoutes";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());

    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseloaderDashboardResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseloaderDashboardResponse(Response<dynamic> response) {
    return LoaderDashboardResponse.fromJson(response.data);
  }

  ///Fetching Driver Dashboard Details
  @override
  Future<DriverDashboardResponse> driverDashboardAPI(int driverId, CommonDashboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    //final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $token"};

    var endpoint = "${DioProvider.baseUrl}/getRoutesByDriverId/$driverId";
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseDriverDashboardResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  DriverDashboardResponse _parseDriverDashboardResponse(Response<dynamic> response) {
    return DriverDashboardResponse.fromJson(response.data);
  }

  ///Fetching Carrier Owner Dashboard Details
  @override
  Future<CarrierOwnerDashboardResponse> carrierOwnerDashboardAPI(
      int carrierownerId, CommonDashboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    var endpoint = "${DioProvider.baseUrl}/getRoutesByDriverId/$carrierownerId";
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseCarrierOwnerDashboardResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  CarrierOwnerDashboardResponse _parseCarrierOwnerDashboardResponse(Response<dynamic> response) {
    return CarrierOwnerDashboardResponse.fromJson(response.data);
  }

  ///Fetching Subdriver Dashboard Details
  @override
  Future<SubdriverDashboardResponse> subDriverDashboardAPI(
      int subdriverId, CommonDashboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/getRoutesByDriverId/$subdriverId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseSubdriverDashboardResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  SubdriverDashboardResponse _parseSubdriverDashboardResponse(Response<dynamic> response) {
    return SubdriverDashboardResponse.fromJson(response.data);
  }

  ///Fetching Merchandiser Dashboard Details
  @override
  Future<MerchandiserDashboardResponse> merchandiserDashboardAPI(
      int merchandiserId, MerchandiserDashboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/merchandiserAssignedShipments/$merchandiserId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());

    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseMerchandiserDashboardResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<MerchandiserDashboardResponse> merchandiserShipmentAPI(int merchandiserId) async {
    String? accessToken = await getToken();
    var endpoint = "${DioProvider.baseUrl}/merchandiserAssignedShipments/$merchandiserId";
    var dioCall = dioClient.get(
      endpoint,
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      }),
    );
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseMerchandiserDashboardResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  MerchandiserDashboardResponse _parseMerchandiserDashboardResponse(Response<dynamic> response) {
    return MerchandiserDashboardResponse.fromJson(response.data);
  }

  ///Fetching Token
  Future<String?> getToken() async {
    PreferenceManager _preferenceManager = getx.Get.find(tag: (PreferenceManager).toString());
    String access_token = await _preferenceManager.getString(PreferenceManager.keyToken);
    debugPrint("get Token >> $access_token");
    if (access_token == "") {
      print(access_token);
    }
    return access_token;
  }

  @override
  Future<RoutesResponse> getSearchRouteList(RouteSearchQueryParam routeSearchQueryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/routes";
    var dioCall =
        dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: routeSearchQueryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseRoutes(response));
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  RoutesResponse _parseRoutes(Response<dynamic> response) {
    return RoutesResponse.fromJson(response.data);
  }

  @override
  Future<LoadBoardByCoRes> getLoadBoardRoutesListByCO(
      LoadBoardAssignedRouteByCoQueryParams loadBoardAssignedRouteByCoReq, bool isGettingOpenRoutes) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/loadboardRoutes"; // ?carrier_owner_id=9
    var dioCall = dioClient.get(endpoint,
        options: Options(headers: reqHeader),
        queryParameters: (isGettingOpenRoutes == true) ? null : loadBoardAssignedRouteByCoReq.toJson());

    return callApiWithErrorParser(dioCall).then((response) => _parseLoadBoardRoutes(response));
  }

  // @override
  // Future<RoutesResponse> getRouteDirection(RouteDirectionsQueryParam routeDirectionsQueryParam) async {
  //   final dio = Dio(); // Create a Dio instance
  //   const baseUrl = 'https://maps.googleapis.com/maps/api/directions/json';
  //
  //   // Construct query parameters
  //   final queryParameters = {
  //     'origin': routeDirectionsQueryParam.origin,
  //     'destination': routeDirectionsQueryParam.destination,
  //     'waypoints': routeDirectionsQueryParam.waypoints != null
  //         ? routeDirectionsQueryParam.waypoints!
  //             .map((waypoint) => '${waypoint?.location}|${waypoint?.stopover ?? false ? 'stopover' : 'via'}')
  //             .join('|')
  //         : null,
  //     'provideRouteAlternatives': routeDirectionsQueryParam.provideRouteAlternatives,
  //     'travelMode': routeDirectionsQueryParam.travelMode,
  //     'key': googleApiKey, // Replace with your API key
  //     'departureTime': routeDirectionsQueryParam.departureTime,
  //     'trafficModel': routeDirectionsQueryParam.trafficModel,
  //     'unitSystem': routeDirectionsQueryParam.unitSystem,
  //   };
  //
  //   try {
  //     final dioCall = await dioClient.get(
  //       baseUrl,
  //       queryParameters: queryParameters,
  //     );
  //
  //     return _parseRouteDirection(dioCall.data);
  //   } catch (e) {
  //     print(e.toString());
  //     rethrow;
  //   }
  // }

  LoadBoardByCoRes _parseLoadBoardRoutes(Response<dynamic> response) {
    return LoadBoardByCoRes.fromJson(response.data);
  }

  ///Accept LoadBoard Routes APT
  @override
  Future<AcceptLoadboardRoutesResponse> acceptLoadBoardRoutesAPI(AcceptLoadboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/accepetLoadboardRoutes";
    var dioCall = dioClient.put(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseacceptLoadBoardRoutes(response));
    } catch (e) {
      rethrow;
    }
  }

  AcceptLoadboardRoutesResponse _parseacceptLoadBoardRoutes(Response<dynamic> response) {
    return AcceptLoadboardRoutesResponse.fromJson(response.data);
  }

  @override
  Future<RoutePauseLogResponse> routePauseLog(RoutePauseLogQueryParam routePauseLogQueryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/saveRoutePauseLog";
    print(routePauseLogQueryParam.routeId);
    print(routePauseLogQueryParam.routeStatus);
    print(routePauseLogQueryParam.breakReason);
    print(routePauseLogQueryParam.endTime);
    print(routePauseLogQueryParam.note);
    var dioCall = dioClient.post(endpoint,
        options: Options(headers: reqHeader), queryParameters: routePauseLogQueryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseRoutePauseLog(response));
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  RoutePauseLogResponse _parseRoutePauseLog(Response<dynamic> response) {
    return RoutePauseLogResponse.fromJson(response.data);
  }

  ///Function to get carrier owner and subdrivers list
  @override
  Future<CarrierOwnerSubdriversResponse> getCarrierOwnerSubdrivers(int routeItemId) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/carrierOwnerAndSubdrivers/$routeItemId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));

    return callApiWithErrorParser(dioCall).then((response) => _parseCarrierOwnerSubdrivers(response));
  }

  CarrierOwnerSubdriversResponse _parseCarrierOwnerSubdrivers(Response<dynamic> response) {
    return CarrierOwnerSubdriversResponse.fromJson(response.data);
  }

  ///Function to assign drivers to route
  @override
  Future<AssignSubdriversRouteResponse> assignDriverRoutes(AssignDriversRouteRequest assignDriversRouteRequest) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/assignedDriverToRoutes";
    var dioCall = dioClient.put(endpoint,
        options: Options(headers: reqHeader), queryParameters: assignDriversRouteRequest.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseAssignDriverRoutes(response));
    } catch (e) {
      rethrow;
    }
  }

  ///Function to parse assign driver to route's response
  AssignSubdriversRouteResponse _parseAssignDriverRoutes(Response<dynamic> response) {
    return AssignSubdriversRouteResponse.fromJson(response.data);
  }

  ///Function to get pickup order details
  @override
  Future<PickupOrderDetailResponse> getPickUpOrderDetails(int psId) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/pickupShipmentDetails/$psId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));

    return callApiWithErrorParser(dioCall).then((response) => _parsePickupOrderDetailResponse(response));
  }

  ///Function to parse pickup order details response
  PickupOrderDetailResponse _parsePickupOrderDetailResponse(Response<dynamic> response) {
    return PickupOrderDetailResponse.fromJson(response.data);
  }

  @override
  Future<Response<dynamic>> readShipmentByUser({required int shipmentId, required int wereHouseId}) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    Map<String, dynamic> mapbody = {
      "shipment_id": shipmentId,
      "werehouse_id": wereHouseId,
    };

    var endpoint = "${DioProvider.baseUrl}/readshipmentbyuser";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: mapbody);
    try {
      return callApiWithWithoutErrorMessage(dioCall).then((response) => response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> readNotificationByUser({required var notificationId}) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    Map<String, dynamic> mapbody = {
      "notification_id": notificationId,
    };
    var endpoint = "${DioProvider.baseUrl}/readnotification";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: mapbody);
    try {
      return callApiWithWithoutErrorMessage(dioCall).then((response) => response);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> readRouteByUser({required int route_id, required String userInterface}) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    Map<String, dynamic> mapbody = {"route_id": route_id, "user_interface": userInterface};
    var endpoint = "${DioProvider.baseUrl}/readroutebyuser";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: mapbody);
    try {
      return callApiWithWithoutErrorMessage(dioCall).then((response) => response);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<CompleteShipmentLoadingResponse> completeShipmentLoading(int psId) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/completeShipmentLoading/$psId";
    var dioCall = dioClient.put(endpoint, options: Options(headers: reqHeader));

    return callApiWithErrorParser(dioCall).then((response) => _parseCompleteShipmentLoading(response));
  }

  @override
  Future<WorkDairyDriverResponse> getDriverWorkDairyDetails(GetDriverWorkDairyQueryParam getDriversRouteRequest) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/usersWorkDiary";
    var dioCall =
        dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: getDriversRouteRequest.toJson());

    return callApiWithErrorParser(dioCall).then((response) => _parseDriverWorkDairy(response));
  }

  @override
  Future<CarrierOwnerWorkDairyRes> getCoWorkDairyDetails(GetCoWorkDairyQueryParam getDriversRouteRequest) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/carrierOwnerWorkDiary";
    var dioCall =
        dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: getDriversRouteRequest.toJson());

    return callApiWithErrorParser(dioCall).then((response) => _parseCoDriverWorkDairy(response));
  }

  @override
  Future<CompleteRouteLoadingRes> completeRouteLoading(int routeId) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};

    var endpoint = "${DioProvider.baseUrl}/completeRouteLoading/$routeId";
    var dioCall = dioClient.put(endpoint, options: Options(headers: reqHeader));

    return callApiWithErrorParser(dioCall).then((response) => _parseCompleteRouteLoading(response));
  }

  _parseCompleteRouteLoading(Response<dynamic> response) {
    return CompleteRouteLoadingRes.fromJson(response.data);
  }

  // @override
  // Future<GetStopLoadingRes> getStopLoadingDetails(int stopId) async {
  // await getToken();
  //   final reqHeader = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer $token",
  //   };
  //
  //   print("reqheader");
  //   print(reqHeader);
  //
  //   var endpoint = "${DioProvider.baseUrl}/getDeliveryDetails/$stopId";
  //   var dioCall = dioClient.get(endpoint,
  //       options: Options(headers: {
  //         "Content-Type": "application/json",
  //         "Authorization":
  //             "Bearer $token",
  //       }));
  //   try {
  //     return callApiWithErrorParser(dioCall)
  //         .then((response) => _parseStopLoading(response));
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  // GetStopLoadingRes _parseStopLoading(Response<dynamic> response) {
  //   return GetStopLoadingRes.fromJson(response.data);
  // }

  @override
  Future<MerchandiserCities> getMerchandiserCities(int userId) async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/merchandiserCities/?user_id=$userId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseCitiesResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseCitiesResponse(Response<dynamic> response) {
    return MerchandiserCities.fromJson(response.data);
  }

  @override
  Future<UserDetails> getUserDetails(int userId) async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/userDetails/?user_id=$userId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseUserDetailResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseUserDetailResponse(Response<dynamic> response) {
    return UserDetails.fromJson(response.data);
  }

  @override
  Future<AdminResponse> getAdminDetail() async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/getSuperAdminnDetails";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseAdminDetailResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseAdminDetailResponse(Response<dynamic> response) {
    return AdminResponse.fromJson(response.data);
  }

  @override
  Future<ShipmentInventoryResponse> getShipmentInventory(int shipmentId) async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/getShipmentInventory/$shipmentId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseShipmentInventoryResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseShipmentInventoryResponse(Response<dynamic> response) {
    return ShipmentInventoryResponse.fromJson(response.data);
  }

  @override
  Future<ShipmentInventoryResponse> getRouteShipmentInventory(int routeId) async {
    String? accessToken = await getToken();
    final reqHeader = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $accessToken",
    };

    print("reqheader");
    print(reqHeader);

    var endpoint = "${DioProvider.baseUrl}/getRouteShipmentInventory/$routeId";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader));
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseRouteShipmentInventoryResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseRouteShipmentInventoryResponse(Response<dynamic> response) {
    return ShipmentInventoryResponse.fromJson(response.data);
  }

  Future<PinPointAndFhfResponse> addPinFhFNotes(PinPointQueryParam pinPointQueryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/customerLocationsfhfNotes";
    var dioCall =
        dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: pinPointQueryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parsePinPoint(response));
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> updateLatLong(UpdateLatLongRequest updateLatLongRequest) async {
    String? accessToken = await getToken();
    var endpoint = "${DioProvider.baseUrl}/sendlocation";

    // Convert the request object to a raw string (e.g., using toString())

    var dioCall = dioClient.post(
      endpoint,
      options: Options(headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"}),
      data: updateLatLongRequest.toJson(),
    );

    try {
      return callApiWithWithoutErrorMessage(dioCall).then((response) => response);
    } catch (e) {
      rethrow;
    }
  }

  Future<RouteStartResponse> startRoute(RouteStartQueryParam routeStartQueryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/startRoute";
    var dioCall =
        dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: routeStartQueryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseStartRoute(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseCoDriverWorkDairy(Response<dynamic> response) {
    return CarrierOwnerWorkDairyRes.fromJson(response.data);
  }

  _parsePinPoint(Response<dynamic> response) {
    return PinPointAndFhfResponse.fromJson(response.data);
  }

  _parseStartRoute(Response<dynamic> response) {
    return RouteStartResponse.fromJson(response.data);
  }

  _parseCompleteInventory(Response<dynamic> response) {
    return CompleteInventoryLoadingRes.fromJson(response.data);
  }

  _parseDriverWorkDairy(Response<dynamic> response) {
    return WorkDairyDriverResponse.fromJson(response.data);
  }

  ///Function to parse complete shipment loading response
  CompleteShipmentLoadingResponse _parseCompleteShipmentLoading(Response<dynamic> response) {
    return CompleteShipmentLoadingResponse.fromJson(response.data);
  }

  RoutesResponse _parseRouteDirection(Map<String, dynamic> response) {
    // print(response);
    return RoutesResponse.fromJson(response);
  }

  @override
  Future<CompleteInventoryLoadingRes> completeInventoryLoading(CompleteInventLoadQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/completeInventoryLoading";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseCompleteInventory(response));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<LoaderDashboardResponse> myLoadsAPI(MyLoadQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/loaderWarehouseAssignRoutes";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());

    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseMyLoadResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseMyLoadResponse(Response<dynamic> response) {
    return LoaderDashboardResponse.fromJson(response.data);
  }

  @override
  Future<ReSequenceRes> reSequenceShipments(List<ReSequenceRequest> data) async {
    String? accessToken = await getToken();
    //  {"route_no": 2,"id": 1, "route_id":49}

    List<Map<String, dynamic>> map = [];

    data.asMap().forEach((key, value) {
      map.add(ReSequenceRequest(
        id: data[key].id,
        routeId: data[key].routeId,
        routeNo: data[key].routeNo,
        lat: data[key].lat,
        lng: data[key].lng,
      ).toJson());
    });

    var endpoint = "${DioProvider.baseUrl}/resequenceShipments";
    var dioCall = dioClient.put(
      endpoint,
      options: Options(headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"}),
      data: map,
    );

    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseReSeqResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseReSeqResponse(Response<dynamic> response) {
    return ReSequenceRes.fromJson(response.data);
  }

  @override
  Future<NotificationListResponse> notificationsApi() async {
    String? accessToken = await getToken();

    var endpoint = "${DioProvider.baseUrl}/usernotifications";
    var dioCall = dioClient.get(
      endpoint,
      options: Options(headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${accessToken}",
      }),
    );

    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseNotificationsResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseNotificationsResponse(Response<dynamic> response) {
    return NotificationListResponse.fromJson(response.data);
  }

  @override
  Future<EmailResponse> sendEmail(SendEmailQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/workDiarySendEmail";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseSendEmailResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseSendEmailResponse(Response<dynamic> response) {
    return EmailResponse.fromJson(response.data);
  }

  @override
  Future<UnloadInventoryLoadingInventoryRes> unloadShipment(ShipmentUnloadQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/cancelInventoryLoading";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseUnloadShipmentResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseUnloadShipmentResponse(Response<dynamic> response) {
    return UnloadInventoryLoadingInventoryRes.fromJson(response.data);
  }

  ///Fetching Route Details6
  @override
  Future<MyLoadsResponse> myLoads(CommonDashboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};
    var endpoint = "${DioProvider.baseUrl}/myloads";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseLoadsDetails(response));
    } catch (e) {
      rethrow;
    }
  }

  MyLoadsResponse _parseLoadsDetails(Response<dynamic> response) {
    return MyLoadsResponse.fromJson(response.data);
  }

  ///Fetching Route Details
  @override
  Future<CarrierOwnerMyLoadResponse> carrierOwnerMyLoad(CommonDashboardQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"};
    var endpoint = "${DioProvider.baseUrl}/myloads";
    var dioCall = dioClient.get(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseCarrierLoadsDetails(response));
    } catch (e) {
      rethrow;
    }
  }

  CarrierOwnerMyLoadResponse _parseCarrierLoadsDetails(Response<dynamic> response) {
    return CarrierOwnerMyLoadResponse.fromJson(response.data);
  }

  @override
  Future<RouteCompleteResponse> routeComplete(CompleteRouteQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/completeRoute";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseRouteCompleteResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseRouteCompleteResponse(Response<dynamic> response) {
    return RouteCompleteResponse.fromJson(response.data);
  }

  @override
  Future<GetEtaResponse> getEta(List<ReSequenceRequest> data) async {
    String? accessToken = await getToken();

    List<Map<String, dynamic>> map = [];

    data.asMap().forEach((key, value) {
      map.add(ReSequenceRequest(
        id: data[key].id,
        routeId: data[key].routeId,
        routeNo: data[key].routeNo,
        lat: data[key].lat.toString(),
        lng: data[key].lng.toString(),
      ).toJson());
    });

    print(" >>> Request >> ${jsonEncode(data)}");
    var endpoint = "${DioProvider.baseUrl}/getShipmentsEta";
    var dioCall = dioClient.post(
      endpoint,
      options: Options(headers: {"Content-Type": "application/json", "Authorization": "Bearer $accessToken"}),
      data: jsonEncode(data),
    );

    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseGetEtaResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseGetEtaResponse(Response<dynamic> response) {
    return GetEtaResponse.fromJson(response.data);
  }

  @override
  Future<CommonResponse> markAllLoaded(MarkAllLoadedQueryParam queryParam) async {
    String? accessToken = await getToken();
    final reqHeader = {'Accept': 'application/json', 'authorization': 'Bearer $accessToken'};
    var endpoint = "${DioProvider.baseUrl}/markallloaded";
    var dioCall = dioClient.post(endpoint, options: Options(headers: reqHeader), queryParameters: queryParam.toJson());
    try {
      return callApiWithErrorParser(dioCall).then((response) => _parseMarkAllLoadedResponse(response));
    } catch (e) {
      rethrow;
    }
  }

  _parseMarkAllLoadedResponse(Response<dynamic> response) {
    return CommonResponse.fromJson(response.data);
  }
}
