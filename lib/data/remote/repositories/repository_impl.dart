/// The `RepositoryImpl` class is a concrete implementation of the `Repository` interface.
/// It provides definitions for various methods to interact with the application's remote data source.
/// This class uses the `RemoteDataSource` to perform API calls and handle data operations.

import 'package:bethel_farm/data/model/common/common_response.dart';
import 'package:bethel_farm/data/model/request/update_lat_long_request.dart';

import 'package:bethel_farm/data/model/response/bubble_count_response.dart';

import 'package:bethel_farm/data/model/response/complete_route_loading.dart';
import 'package:bethel_farm/data/model/response/complete_shipment_loading_response.dart';

import 'package:bethel_farm/data/model/response/get_eta_res.dart';
import 'package:bethel_farm/data/model/response/loader_dashboard_response.dart';
import 'package:bethel_farm/data/model/response/route_pause_log_response.dart';

import 'package:bethel_farm/data/model/response/verify_otp_res.dart';
import 'package:bethel_farm/data/remote/remote_data_source_impl.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/accept_loadboard_query_param.dart';

import '../../model/response/email_response.dart';
import '../../model/response/get_eta_res.dart';
import '../../model/response/my_loads_response.dart';
import '../../model/response/notification_list_response.dart';
import '../../model/response/admin_detail_response.dart';
import '../../model/response/complete_shipment_delivery.dart';
import '../../model/response/driver_dashboard_response.dart';
import '../../model/response/getLoadboardData.dart';
import '../../model/response/logout_response.dart';
import 'package:bethel_farm/data/remote/remote_data_source.dart';

import '../../model/response/route_complete_response.dart';
import '../../model/response/route_details_response.dart';
import '../../model/response/route_start_response.dart';
import '../../model/response/routes_response.dart';
import '../../model/response/stop_details_response.dart';
import '../../model/response/user_detail.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dioRes;

class RepositoryImpl implements Repository {
  final RemoteDataSource _remoteSource =
      Get.isRegistered<RemoteDataSource>() ? Get.find<RemoteDataSource>() : Get.put(RemoteDataSourceImpl());

  @override
  Future<LoginRes> loginUser(LoginQueryParam queryParam) {
    return _remoteSource.loginUser(queryParam);
  }

  @override
  Future<ForgotPwdRes> forgotPwd(ForgotPwdQueryParam queryParam) {
    return _remoteSource.forgotPwd(queryParam);
  }

  @override
  Future<ChangePwdRes> changePwd(ChangePwdQueryParam queryParam) {
    return _remoteSource.changePwd(queryParam);
  }

  @override
  Future<VerifyOtpRes> verifyOtp(VerifyOtpQueryParam queryParam) {
    return _remoteSource.verifyOtp(queryParam);
  }

  @override
  Future<LogoutResponse> logoutUser() {
    return _remoteSource.logoutUser();
  }

  @override
  Future<LoaderDashboardResponse> loaderDashboardAPI(LoaderDashboardQueryParam queryParam) {
    return _remoteSource.loaderDashboardAPI(queryParam);
  }

  @override
  Future<LoaderDashboardResponse> myLoads(MyLoadQueryParam queryParam) {
    return _remoteSource.myLoadsAPI(queryParam);
  }

  @override
  Future<RouteDetailsResponse> getRouteDetails(int routeId) {
    return _remoteSource.getRouteDetails(routeId);
  }

  @override
  Future<CompleteShipmentDeliveryRes> completeShipmentAPI(CompleteShipmentQueryParam queryParam) {
    return _remoteSource.completeShipmentAPI(queryParam);
  }

  @override
  Future<StopDetailsResponse> getStopDetails(int stopId) {
    return _remoteSource.getStopDetails(stopId);
  }

  // @override
  // Future<GetStopLoadingRes> getStopLoadingDetails(int stopId) {
  //   return _remoteSource.getStopLoadingDetails(stopId);
  // }

  @override
  Future<PickupOrdersResponse> getPickUpOrders() {
    return _remoteSource.getPickUpOrders();
  }

  @override
  Future<BubbleCountResponse> getBubbleCount() {
    return _remoteSource.getBubbleCount();
  }

  @override
  Future<DriverDashboardResponse> driverDashboardAPI(int driverID, CommonDashboardQueryParam queryParam) {
    return _remoteSource.driverDashboardAPI(driverID, queryParam);
  }

  @override
  Future<CarrierOwnerDashboardResponse> carrierownerDashboardAPI(
      int carrierownerID, CommonDashboardQueryParam queryParam) {
    return _remoteSource.carrierOwnerDashboardAPI(carrierownerID, queryParam);
  }

  @override
  Future<SubdriverDashboardResponse> subdriverDashboardAPI(int subdriverID, CommonDashboardQueryParam queryParam) {
    return _remoteSource.subDriverDashboardAPI(subdriverID, queryParam);
  }

  @override
  Future<MerchandiserDashboardResponse> merchandiserDashboardAPI(
      int merchandiserID, MerchandiserDashboardQueryParam queryParam) {
    return _remoteSource.merchandiserDashboardAPI(merchandiserID, queryParam);
  }

  @override
  Future<MerchandiserDashboardResponse> merchandiserShipmentAPI(int merchandiserID) {
    return _remoteSource.merchandiserShipmentAPI(merchandiserID);
  }

  @override
  Future<RoutesResponse> getSearchRouteList(RouteSearchQueryParam routeSearchQueryParam) {
    return _remoteSource.getSearchRouteList(routeSearchQueryParam);
  }

  @override
  Future<LoadBoardByCoRes> getLoadBoardRoutesListByCO(
      LoadBoardAssignedRouteByCoQueryParams loadBoardAssignedRouteByCoReq,
      {required isGettingOpenRoutes}) {
    return _remoteSource.getLoadBoardRoutesListByCO(loadBoardAssignedRouteByCoReq, isGettingOpenRoutes);
  }

  @override
  Future<AcceptLoadboardRoutesResponse> acceptLoadBoardRoutesAPI(AcceptLoadboardQueryParam queryParam) {
    return _remoteSource.acceptLoadBoardRoutesAPI(queryParam);
  }

  // @override
  // Future<RoutesResponse> getRouteDirection(RouteDirectionsQueryParam routeDirectionsQueryParam) {
  //   return _remoteSource.getRouteDirection(routeDirectionsQueryParam);
  // }

  @override
  Future<RoutePauseLogResponse> routePauseLog(RoutePauseLogQueryParam routePauseLogQueryParam) {
    return _remoteSource.routePauseLog(routePauseLogQueryParam);
  }

  @override
  Future<CarrierOwnerSubdriversResponse> getCarrierOwnerSubdrivers(int routeItemId) {
    return _remoteSource.getCarrierOwnerSubdrivers(routeItemId);
  }

  @override
  Future<AssignSubdriversRouteResponse> assignDriverRoutes(AssignDriversRouteRequest assignDriversRouteRequest) {
    return _remoteSource.assignDriverRoutes(assignDriversRouteRequest);
  }

  @override
  Future<PickupOrderDetailResponse> getPickUpOrderDetails(int psId) {
    return _remoteSource.getPickUpOrderDetails(psId);
  }

  @override
  Future<dioRes.Response> readShipmentByUser({required int shipmentId, required int wereHouseId}) {
    return _remoteSource.readShipmentByUser(shipmentId: shipmentId, wereHouseId: wereHouseId);
  }

  @override
  Future<dioRes.Response> readNotificationByUser({required var notification_id}) {
    return _remoteSource.readNotificationByUser(notificationId: notification_id);
  }

  Future<dioRes.Response> readRouteByUser({required int route_id, required String userInterface}) {
    return _remoteSource.readRouteByUser(route_id: route_id, userInterface: userInterface);
  }

  @override
  Future<CompleteShipmentLoadingResponse> completeShipmentLoading(int psId) {
    return _remoteSource.completeShipmentLoading(psId);
  }

  @override
  Future<CompleteRouteLoadingRes> completeRouteLoading(int routeId) {
    return _remoteSource.completeRouteLoading(routeId);
  }

  @override
  Future<MerchandiserCities> getMerchandiserCities(int userId) {
    return _remoteSource.getMerchandiserCities(userId);
  }

  @override
  Future<UserDetails> getUserDetails(int userId) {
    return _remoteSource.getUserDetails(userId);
  }

  @override
  Future<WorkDairyDriverResponse> getDriverWorkDairyDetails(GetDriverWorkDairyQueryParam userId) {
    return _remoteSource.getDriverWorkDairyDetails(userId);
  }

  @override
  Future<AdminResponse> getAdminDetail() {
    return _remoteSource.getAdminDetail();
  }

  @override
  Future<CarrierOwnerWorkDairyRes> getCoWorkDairyDetails(GetCoWorkDairyQueryParam carrierOwnerId) {
    return _remoteSource.getCoWorkDairyDetails(carrierOwnerId);
  }

  @override
  Future<ShipmentInventoryResponse> getShipmentInventory(int shipmentId) {
    return _remoteSource.getShipmentInventory(shipmentId);
  }

  @override
  Future<ShipmentInventoryResponse> getRouteShipmentInventory(int shipmentId) {
    return _remoteSource.getRouteShipmentInventory(shipmentId);
  }

  @override
  Future<PinPointAndFhfResponse> addPinFhFNotes(PinPointQueryParam pinPointQueryParam) {
    return _remoteSource.addPinFhFNotes(pinPointQueryParam);
  }

  @override
  Future<dioRes.Response<dynamic>> updateLatLong(UpdateLatLongRequest updateLatLongRequest) {
    return _remoteSource.updateLatLong(updateLatLongRequest);
  }

  @override
  Future<RouteStartResponse> startRoute(RouteStartQueryParam routeStartQueryParam) {
    return _remoteSource.startRoute(routeStartQueryParam);
  }

  @override
  Future<NotificationListResponse> notificationsApi() {
    return _remoteSource.notificationsApi();
  }

  @override
  Future<CompleteInventoryLoadingRes> completeInventoryLoading(CompleteInventLoadQueryParam queryParam) {
    return _remoteSource.completeInventoryLoading(queryParam);
  }

  @override
  Future<ReSequenceRes> reSequenceShipments(List<ReSequenceRequest> data) {
    return _remoteSource.reSequenceShipments(data);
  }

  @override
  Future<EmailResponse> sendEmail(SendEmailQueryParam queryParam) {
    return _remoteSource.sendEmail(queryParam);
  }

  @override
  Future<UnloadInventoryLoadingInventoryRes> unloadInventoryLoading(ShipmentUnloadQueryParam shipmentUnloadQueryParam) {
    return _remoteSource.unloadShipment(shipmentUnloadQueryParam);
  }

  @override
  Future<CancelShipmentResponse> cancelShipmentAPI(CompleteShipmentQueryParam completeShipmentQueryParam) {
    return _remoteSource.cancelShipmentAPI(completeShipmentQueryParam);
  }

  @override
  Future<MyLoadsResponse> myLoadsApi(CommonDashboardQueryParam queryParam) {
    return _remoteSource.myLoads(queryParam);
  }

  @override
  Future<CarrierOwnerMyLoadResponse> carrierOwnerMyLoad(CommonDashboardQueryParam queryParam) {
    return _remoteSource.carrierOwnerMyLoad(queryParam);
  }

  @override
  Future<RouteCompleteResponse> routeComplete(CompleteRouteQueryParam queryParam) {
    return _remoteSource.routeComplete(queryParam);
  }

  @override
  Future<GetEtaResponse> getETA(List<ReSequenceRequest> data) {
    return _remoteSource.getEta(data);
  }

  @override
  Future<CommonResponse> markAllLoaded(MarkAllLoadedQueryParam queryParam) async {
    return _remoteSource.markAllLoaded(queryParam);
  }
}
