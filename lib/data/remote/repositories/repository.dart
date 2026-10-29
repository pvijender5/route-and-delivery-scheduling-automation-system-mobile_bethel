/// The `Repository` class serves as an abstract base class for defining
/// various API methods and operations related to the application's data layer.
/// It provides method signatures for handling user authentication,
/// dashboard data, shipment operations, route management, notifications,
/// and other functionalities.
///
/// Implementations of this class are expected to provide concrete
/// definitions for these methods, interacting with remote data sources
/// or APIs to fetch, update, or manipulate data as required.

import 'package:bethel_farm/data/model/request/update_lat_long_request.dart';
import 'package:bethel_farm/data/model/response/accept_loadnoard_routes_response.dart';
import 'package:bethel_farm/data/model/response/bubble_count_response.dart';
import 'package:bethel_farm/data/model/response/cancel_shipment_response.dart';
import 'package:bethel_farm/data/model/response/carrier_owner_work_dairy_res.dart';
import 'package:bethel_farm/data/model/response/complete_inventory_loading_res.dart';
import 'package:bethel_farm/data/model/response/complete_route_loading.dart';
import 'package:bethel_farm/data/model/response/complete_shipment_delivery.dart';
import 'package:bethel_farm/data/model/response/driver_work_dairy_res.dart';
import 'package:bethel_farm/data/model/response/get_eta_res.dart';
import 'package:bethel_farm/data/model/response/loader_dashboard_response.dart';
import 'package:bethel_farm/data/model/response/route_pause_log_response.dart';
import 'package:bethel_farm/data/model/response/verify_otp_res.dart';
import 'package:bethel_farm/data/model/response/login_response.dart';
import '../../model/common/common_response.dart';
import '../../model/response/email_response.dart';
import '../../model/response/get_eta_res.dart';
import '../../model/response/my_loads_response.dart';
import '../../model/response/notification_list_response.dart';
import '../../model/response/admin_detail_response.dart';
import '../../model/response/complete_shipment_loading_response.dart';
import '../../model/response/driver_dashboard_response.dart';
import '../../model/response/getLoadboardData.dart';
import '../../model/response/logout_response.dart';
import '../../model/response/route_complete_response.dart';
import '../../model/response/route_details_response.dart';
import '../../model/response/route_start_response.dart';
import '../../model/response/routes_response.dart';
import '../../model/response/stop_details_response.dart';
import '../../model/response/user_detail.dart';
import 'query_param/accept_loadboard_query_param.dart';
import 'package:dio/dio.dart';

abstract class Repository {
  Future<LoginRes> loginUser(LoginQueryParam queryParam);
  Future<ForgotPwdRes> forgotPwd(ForgotPwdQueryParam queryParam);
  Future<ChangePwdRes> changePwd(ChangePwdQueryParam queryParam);
  Future<VerifyOtpRes> verifyOtp(VerifyOtpQueryParam queryParam);
  Future<LogoutResponse> logoutUser();
  Future<LoaderDashboardResponse> loaderDashboardAPI(LoaderDashboardQueryParam queryParam);
  Future<LoaderDashboardResponse> myLoads(MyLoadQueryParam queryParam);
  Future<RouteDetailsResponse> getRouteDetails(int routeId);
  Future<RoutesResponse> getSearchRouteList(RouteSearchQueryParam routeSearchQueryParam);
  Future<StopDetailsResponse> getStopDetails(int stopId);
  Future<PinPointAndFhfResponse> addPinFhFNotes(PinPointQueryParam pinPointQueryParam);
  Future<Response<dynamic>> updateLatLong(UpdateLatLongRequest updateLatLongRequest);
  // Future<GetStopLoadingRes> getStopLoadingDetails(int stopId);
  Future<DriverDashboardResponse> driverDashboardAPI(int diverId, CommonDashboardQueryParam queryParam);
  Future<CarrierOwnerDashboardResponse> carrierownerDashboardAPI(
      int carrierownerId, CommonDashboardQueryParam queryParam);
  Future<SubdriverDashboardResponse> subdriverDashboardAPI(int subdriverId, CommonDashboardQueryParam queryParam);
  Future<MerchandiserDashboardResponse> merchandiserDashboardAPI(
      int merchandiserId, MerchandiserDashboardQueryParam queryParam);
  Future<MerchandiserDashboardResponse> merchandiserShipmentAPI(int merchandiserId);
  Future<CompleteShipmentDeliveryRes> completeShipmentAPI(CompleteShipmentQueryParam queryParam);
  Future<CancelShipmentResponse> cancelShipmentAPI(CompleteShipmentQueryParam queryParam);
  Future<AcceptLoadboardRoutesResponse> acceptLoadBoardRoutesAPI(AcceptLoadboardQueryParam queryParam);
  Future<LoadBoardByCoRes> getLoadBoardRoutesListByCO(
      LoadBoardAssignedRouteByCoQueryParams loadBoardAssignedRouteByCoQueryParams,
      {required bool isGettingOpenRoutes});
  Future<RoutePauseLogResponse> routePauseLog(RoutePauseLogQueryParam routePauseLogQueryParam);
  Future<CarrierOwnerSubdriversResponse> getCarrierOwnerSubdrivers(int routeItemId);
  Future<AssignSubdriversRouteResponse> assignDriverRoutes(AssignDriversRouteRequest assignDriversRouteRequest);
  Future<PickupOrdersResponse> getPickUpOrders();
  Future<BubbleCountResponse> getBubbleCount();
  Future<PickupOrderDetailResponse> getPickUpOrderDetails(int psId);
  Future<Response<dynamic>> readShipmentByUser({required int shipmentId, required int wereHouseId});
  Future<Response<dynamic>> readNotificationByUser({required var notification_id});
  Future<Response<dynamic>> readRouteByUser({required int route_id, required String userInterface});

  Future<CompleteShipmentLoadingResponse> completeShipmentLoading(int psId);
  Future<CompleteRouteLoadingRes> completeRouteLoading(int routeId);
  Future<MerchandiserCities> getMerchandiserCities(int userId);
  Future<UserDetails> getUserDetails(int userId);
  Future<WorkDairyDriverResponse> getDriverWorkDairyDetails(GetDriverWorkDairyQueryParam userId);
  Future<CarrierOwnerWorkDairyRes> getCoWorkDairyDetails(GetCoWorkDairyQueryParam queryParam);
  Future<AdminResponse> getAdminDetail();
  Future<ShipmentInventoryResponse> getShipmentInventory(int shipmentId);
  Future<ShipmentInventoryResponse> getRouteShipmentInventory(int routeID);
  Future<RouteStartResponse> startRoute(RouteStartQueryParam routeStartQueryParam);
  Future<NotificationListResponse> notificationsApi();
  Future<CompleteInventoryLoadingRes> completeInventoryLoading(CompleteInventLoadQueryParam completeQueryParam);

  Future<ReSequenceRes> reSequenceShipments(List<ReSequenceRequest> data);
  Future<GetEtaResponse> getETA(List<ReSequenceRequest> data);
  Future<EmailResponse> sendEmail(SendEmailQueryParam queryParam);

  Future<UnloadInventoryLoadingInventoryRes> unloadInventoryLoading(ShipmentUnloadQueryParam shipmentUnloadQueryParam);
  Future<MyLoadsResponse> myLoadsApi(CommonDashboardQueryParam queryParam);
  Future<CarrierOwnerMyLoadResponse> carrierOwnerMyLoad(CommonDashboardQueryParam queryParam);
  Future<RouteCompleteResponse> routeComplete(CompleteRouteQueryParam queryParam);
  Future<CommonResponse> markAllLoaded(MarkAllLoadedQueryParam queryParam);
}
