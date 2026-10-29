/// An abstract class defining the contract for remote data operations.
///
/// This class serves as the blueprint for implementing various remote API calls
/// in the application. It includes method signatures for interacting with
/// different endpoints, such as user authentication, dashboard data retrieval,
/// shipment operations, and more.
///
/// Implementations of this class should provide the actual logic for making
/// HTTP requests using a networking library like `Dio`.
///
/// Key Features:
/// - Provides method signatures for API calls.
/// - Covers a wide range of operations, including login, shipment updates, and route management.
/// - Ensures consistent structure for remote data handling across the application.

import 'package:bethel_farm/data/model/request/update_lat_long_request.dart';
import 'package:bethel_farm/data/model/response/accept_loadnoard_routes_response.dart';
import 'package:bethel_farm/data/model/response/admin_detail_response.dart';
import 'package:bethel_farm/data/model/response/bubble_count_response.dart';
import 'package:bethel_farm/data/model/response/cancel_shipment_response.dart';
import 'package:bethel_farm/data/model/response/carrier_owner_work_dairy_res.dart';
import 'package:bethel_farm/data/model/response/change_password_res.dart';
import 'package:bethel_farm/data/model/response/complete_inventory_loading_res.dart';
import 'package:bethel_farm/data/model/response/complete_route_loading.dart';
import 'package:bethel_farm/data/model/response/complete_shipment_delivery.dart';
import 'package:bethel_farm/data/model/response/driver_dashboard_response.dart';
import 'package:bethel_farm/data/model/response/driver_work_dairy_res.dart';
import 'package:bethel_farm/data/model/response/forgot_pwd_res.dart';
import 'package:bethel_farm/data/model/response/get_eta_res.dart';
import 'package:bethel_farm/data/model/response/loader_dashboard_response.dart';
import 'package:bethel_farm/data/model/response/login_response.dart';
import 'package:bethel_farm/data/model/response/notification_list_response.dart';
import 'package:bethel_farm/data/model/response/pickup_orders_response.dart';
import 'package:bethel_farm/data/model/response/pinpoint_and_fhf_response.dart';
import 'package:bethel_farm/data/model/response/re_sequence_res.dart';
import 'package:bethel_farm/data/model/response/resequence_req.dart';
import 'package:bethel_farm/data/model/response/route_pause_log_response.dart';
import 'package:bethel_farm/data/model/response/route_start_response.dart';
import 'package:bethel_farm/data/model/response/shiplement_uload_res.dart';
import 'package:bethel_farm/data/model/response/shipmentunload.dart';
import 'package:bethel_farm/data/model/response/verify_otp_res.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/accept_loadboard_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/assign_driver_route_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/change_pass_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/co_work_dairy_req.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/common_dashboard_query_param.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/complete_inventory_query_params.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/complete_shipment_query_param.dart';
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
import 'package:bethel_farm/modules/dashboard/route/route_start_query_param.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/route_pause_log_query_params.dart';
import 'package:dio/dio.dart';

import '../../modules/dashboard/route/complete_route_query_param.dart';
import '../../modules/dashboard/stop_details/pinpoint_query_param.dart';
import '../model/common/common_response.dart';
import '../model/response/assign_subdrivers_route_response.dart';
import '../model/response/carrier_owner_subdrivers_response.dart';
import '../model/response/carrierowner_dashboard_response.dart';
import '../model/response/complete_shipment_loading_response.dart';
import '../model/response/email_response.dart';
import '../model/response/getLoadboardData.dart';
import '../model/response/logout_response.dart';
import '../model/response/merchandiser_cities.dart';
import '../model/response/merchandiser_dashboard_response.dart';
import '../model/response/my_loads_response.dart';
import '../model/response/pickup_order_detail_response.dart';
import '../model/response/route_complete_response.dart';
import '../model/response/route_details_response.dart';
import '../model/response/routes_response.dart';
import '../model/response/shipment_inventory_response.dart';
import '../model/response/stop_details_response.dart';
import '../model/response/subdriver_dashboard_response.dart';
import '../model/response/user_detail.dart';

abstract class RemoteDataSource {
  Future<LoginRes> loginUser(LoginQueryParam queryParam);
  Future<ForgotPwdRes> forgotPwd(ForgotPwdQueryParam queryParam);
  Future<ChangePwdRes> changePwd(ChangePwdQueryParam queryParam);
  Future<VerifyOtpRes> verifyOtp(VerifyOtpQueryParam queryParam);
  Future<LogoutResponse> logoutUser();
  Future<LoaderDashboardResponse> loaderDashboardAPI(LoaderDashboardQueryParam queryParam);
  Future<LoaderDashboardResponse> myLoadsAPI(MyLoadQueryParam queryParam);
  Future<RouteDetailsResponse> getRouteDetails(int routeId);
  Future<StopDetailsResponse> getStopDetails(int stopId);
  // Future<GetStopLoadingRes> getStopLoadingDetails(int stopId);
  Future<DriverDashboardResponse> driverDashboardAPI(int driverId, CommonDashboardQueryParam queryParam);
  Future<CarrierOwnerDashboardResponse> carrierOwnerDashboardAPI(
      int carrierownerId, CommonDashboardQueryParam queryParam);
  Future<SubdriverDashboardResponse> subDriverDashboardAPI(int subdriverId, CommonDashboardQueryParam queryParam);
  Future<MerchandiserDashboardResponse> merchandiserDashboardAPI(
      int merchandiserId, MerchandiserDashboardQueryParam queryParam);
  Future<MerchandiserDashboardResponse> merchandiserShipmentAPI(int merchandiserId);
  Future<CompleteShipmentDeliveryRes> completeShipmentAPI(CompleteShipmentQueryParam queryParam);
  Future<AcceptLoadboardRoutesResponse> acceptLoadBoardRoutesAPI(AcceptLoadboardQueryParam queryParam);
  Future<RoutesResponse> getSearchRouteList(RouteSearchQueryParam routeSearchQueryParam);
  Future<LoadBoardByCoRes> getLoadBoardRoutesListByCO(
      LoadBoardAssignedRouteByCoQueryParams loadBoardAssignedRouteByCoReq, bool isGettingOpenRoutes);
  // Future<RoutesResponse> getRouteDirection(RouteDirectionsQueryParam routeDirectionsQueryParam);
  Future<RoutePauseLogResponse> routePauseLog(RoutePauseLogQueryParam routePauseLogQueryParam);

  Future<CarrierOwnerSubdriversResponse> getCarrierOwnerSubdrivers(int routeItemId);
  Future<AssignSubdriversRouteResponse> assignDriverRoutes(AssignDriversRouteRequest assignDriversRouteRequest);

  Future<PickupOrdersResponse> getPickUpOrders();
  Future<BubbleCountResponse> getBubbleCount();
  Future<PickupOrderDetailResponse> getPickUpOrderDetails(int psId);
  Future<Response<dynamic>> readShipmentByUser({required int shipmentId, required int wereHouseId});
  Future<Response<dynamic>> readNotificationByUser({required var notificationId});
  Future<Response<dynamic>> readRouteByUser({required int route_id, required String userInterface});
  Future<CompleteShipmentLoadingResponse> completeShipmentLoading(int psId);
  Future<CompleteRouteLoadingRes> completeRouteLoading(int routeId);
  Future<MerchandiserCities> getMerchandiserCities(int userId);
  Future<UserDetails> getUserDetails(int userId);
  Future<WorkDairyDriverResponse> getDriverWorkDairyDetails(GetDriverWorkDairyQueryParam userId);
  Future<CarrierOwnerWorkDairyRes> getCoWorkDairyDetails(GetCoWorkDairyQueryParam userId);
  Future<PinPointAndFhfResponse> addPinFhFNotes(PinPointQueryParam pinPointQueryParam);
  Future<Response<dynamic>> updateLatLong(UpdateLatLongRequest updateLatLongRequest);
  Future<AdminResponse> getAdminDetail();
  Future<ShipmentInventoryResponse> getShipmentInventory(int shipmentId);
  Future<ShipmentInventoryResponse> getRouteShipmentInventory(int routeId);
  Future<RouteStartResponse> startRoute(RouteStartQueryParam routeStartQueryParam);
  Future<NotificationListResponse> notificationsApi();
  Future<CompleteInventoryLoadingRes> completeInventoryLoading(CompleteInventLoadQueryParam queryParam);

  Future<ReSequenceRes> reSequenceShipments(List<ReSequenceRequest> data);
  Future<GetEtaResponse> getEta(List<ReSequenceRequest> data);
  Future<EmailResponse> sendEmail(SendEmailQueryParam queryParam);

  Future<UnloadInventoryLoadingInventoryRes> unloadShipment(ShipmentUnloadQueryParam queryParam);
  Future<CancelShipmentResponse> cancelShipmentAPI(CompleteShipmentQueryParam queryParam);

  Future<MyLoadsResponse> myLoads(CommonDashboardQueryParam queryParam);
  Future<CarrierOwnerMyLoadResponse> carrierOwnerMyLoad(CommonDashboardQueryParam queryParam);
  Future<RouteCompleteResponse> routeComplete(CompleteRouteQueryParam queryParam);
  Future<CommonResponse> markAllLoaded(MarkAllLoadedQueryParam queryParam);
}
