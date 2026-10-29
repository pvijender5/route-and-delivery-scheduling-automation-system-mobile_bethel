import 'dart:async';
import 'dart:convert';

import 'package:bethel_farm/base/base_controller.dart';
import 'package:bethel_farm/data/enums/user_role.dart';
import 'package:bethel_farm/data/remote/repositories/query_param/common_dashboard_query_param.dart';
import 'package:bethel_farm/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:get/get.dart';

import '../../../../../core/app_string/app_strings.dart';
import '../../../../../data/local/preference_manager.dart';
import '../../../../../data/model/common/common_user.dart';
import '../../../../../data/model/response/driver_dashboard_response.dart';
import '../../../../../data/remote/repositories/repository.dart';
import '../../../../../data/remote/repositories/repository_impl.dart';
import '../../../../../utils/utils.dart';

class HomeDriverController extends BaseController
    with GetSingleTickerProviderStateMixin {
  final Repository _repository = Get.isRegistered<Repository>()
      ? Get.find<Repository>()
      : Get.put(RepositoryImpl());

  final PreferenceManager _preferenceManager =
      getx.Get.find(tag: (PreferenceManager).toString());

  // StreamController<ErrorAnimationType>? errorController;

  ///Initializing model class object to save all data or response and access it in view class to represent
  Rx<DriverDashboardResponse?> responseData = DriverDashboardResponse().obs;

  /// Total length of tabcontroller -  2 tabs Assigned and Active
  late final TabController tabController =
      TabController(length: 2, vsync: this);

  /// Initializing array for both assigned and active routes
  RxList<RouteDetail> assignedRoutesArr = <RouteDetail>[].obs;
  RxList<RouteDetail> activeRoutesArr = <RouteDetail>[].obs;

  /// Initializing User object to access data like id, name etc....
  Rx<User> user = User().obs;

  /// Initializing variable to set the state of route i.e assigned or active
  String? routeStatus;
  RxInt routeIndex = 0.obs;
  RxString userRole = "".obs;

  /// It is called once when the stateful widget is inserted in the widget tree i.e sort of initialisation
  /// like registering a listener
  @override
  void onInit() async {
    // errorController = StreamController<ErrorAnimationType>();
    routeStatus = ACTIVE;
    userRole.value =
        await _preferenceManager.getString(PreferenceManager.userRole);
    getDashboardDetailsByDR(ACTIVE);
    getDashboardDetailsByDR(ASSIGNED);
    tabController.addListener(() {
      if (tabController.index == 0) {
        getDashboardDetailsByDR(ACTIVE);
      } else {
        getDashboardDetailsByDR(ASSIGNED);
      }
    });
    super.onInit();
  }

  /// When a state object is no longer needed, the framework calls dispose() on the state object.
  @override
  void dispose() {
    // errorController!.close();
    super.dispose();
  }

  ///Fetching Driver Dashboard Details
  Future<void> getDashboardDetailsByDR(String routeState) async {
    final rawJson =
        await _preferenceManager.getString(PreferenceManager.userData);
    Map<String, dynamic> map = jsonDecode(rawJson.toString());
    user.value = User.fromJson(map);
    int? driverId = user.value.id;

    var roleId = await _preferenceManager.getString(PreferenceManager.userRole);
    if (roleId == UserRole.DRIVER.name) {
      var queryParam = CommonDashboardQueryParam(status: routeState);
      routeStatus = routeState;
      if (driverId != 0) {
        var driverDashboardService =
            _repository.driverDashboardAPI(driverId ?? 0, queryParam);
        if (routeState == ACTIVE) {
          callDataService(driverDashboardService,
              onSuccess: _handleDriverActiveDashboardResponseSuccess);
        } else if (routeState == ASSIGNED) {
          callDataService(driverDashboardService,
              onSuccess: _handleDriverAssignedDashboardResponseSuccess);
        }
      }
    }
  }

  /// Handles the response for active driver dashboard details.
  ///
  /// This method processes the response received from the API for active routes.
  /// It updates the `activeRoutesArr` with the route details and refreshes the UI.
  ///
  /// Parameters:
  /// - `response`: The `DriverDashboardResponse` object containing the API response data.

  _handleDriverActiveDashboardResponseSuccess(
      DriverDashboardResponse response) {
    if (response.status == AppString.apiStatusError) {
      Utils.showErrorMessage(response.message.toString());
    } else {
      // if(routeStatus == "active") {
      activeRoutesArr.clear();
      activeRoutesArr.addAll(response.routeDetails ?? []);
      // refresh();
      // update();
      //   }
      // else if(routeStatus == "assigned") {
      //     assignedRoutesArr.clear();
      //     assignedRoutesArr.addAll(response.routeDetails??[]);
      //     refresh();
      //     update();
      //   }
      responseData.value = DriverDashboardResponse.fromJson(response.toJson());
      refresh();
      update();
      // Utils.showSuccessMessage(response.message.toString());
    }
  }


  /// Handles the response for assigned driver dashboard details.
  ///
  /// This method processes the response received from the API for assigned routes.
  /// It updates the `assignedRoutesArr` with the route details and refreshes the UI.
  ///
  /// Parameters:
  /// - `response`: The `DriverDashboardResponse` object containing the API response data.
  _handleDriverAssignedDashboardResponseSuccess(
      DriverDashboardResponse response) {
    if (response.status == AppString.apiStatusError) {
      Utils.showErrorMessage(response.message.toString());
    } else {
      assignedRoutesArr.clear();
      assignedRoutesArr.addAll(response.routeDetails ?? []);
      responseData.value = DriverDashboardResponse.fromJson(response.toJson());
      refresh();
      update();
      // Utils.showSuccessMessage(response.message.toString());
    }
  }

  /// Refreshes the driver dashboard data.
  ///
  /// This method fetches the latest details for both active and assigned routes
  /// by calling the `getDashboardDetailsByDR` method for each route state.
  /// It is typically used to refresh the UI with updated data.
  Future<void> onRefresh() async {
    getDashboardDetailsByDR(ACTIVE);
    getDashboardDetailsByDR(ASSIGNED);
  }
}
