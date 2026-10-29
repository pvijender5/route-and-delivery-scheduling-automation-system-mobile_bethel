/// Represents the main view for the driver's home screen.
/// Displays performance summary, active and assigned routes, and other driver-related data.

import 'package:bethel_farm/base/base_view.dart';
import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/core/app_dimens/app_dimens.dart';
import 'package:bethel_farm/core/app_string/app_strings.dart';
import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:bethel_farm/data/model/response/driver_dashboard_response.dart';
import 'package:bethel_farm/app/controllers/dashboard_module_controller/home_driver_ctrl.dart';
import 'package:bethel_farm/utils/constants.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:bethel_farm/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../data/enums/user_role.dart';
import '../../../../modules/dashboard/route/route_detail_controller.dart';
import '../../../../modules/dashboard/route/route_details_view.dart';

class HomeDriverView extends BaseView<HomeDriverController> {
  // final bool _loading = true;
  // final double _progressValue = 0.0;
  /// Controller for managing driver dashboard data.
  final driverDashboardController = Get.put(HomeDriverController());

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    /// Lazily initializes the `HomeDriverController` when the app bar is created.
    Get.lazyPut(() => HomeDriverController());
    return null;
  }

  @override
  Widget body(BuildContext context) {
    /// Builds the main body of the driver's home screen.
    return Scaffold(
      backgroundColor: AppColors.themeWhiteColor,
      body: Obx(
        () => Container(
          /// Sets the height and width of the container to match the screen size.
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Displays a common app bar with a greeting message.
              Utils().commonAppBar(
                  "${AppString.hello}, ${controller.user.value.name.toString().capitalize ?? ""}!", context),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),

              /// Displays the "Here are your routes" text.
              Container(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height*0.13,
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01, bottom: MediaQuery.of(context).size.height * 0.01),
                child: Text(
                  AppString.homeHereAreYourRoutes,
                  style: AppTextStyles(context).hereAreYourRoutesTextStyle,
                ),
              ),

              /// Displays the "Performance Summary" text.
              Text(AppString.homePerformanceSummary, style: AppTextStyles(context).performanceSummaryTextStyle),

              /// Adds a gap between sections.
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              SizedBox(
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.height*0.345,

                child: Column(
                  children: [
                    /// Displays total shipment and on-time delivery performance.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///  Total shipment card
                        Container(
                          height: MediaQuery.of(context).size.height * 0.13,
                          width: MediaQuery.of(context).size.width * 0.33,
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.03,
                              top: MediaQuery.of(context).size.width * 0.05,
                              right: MediaQuery.of(context).size.width * 0.02),
                          decoration: BoxDecoration(
                              color: AppColors.themeRed1,
                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Displays the total shipment count.
                              Text(
                                driverDashboardController.responseData.value?.totalShipments == null
                                    ? "0"
                                    : driverDashboardController.responseData.value?.totalShipments.toString() ?? "0",
                                style: AppTextStyles(context).numberTextStyle,
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  AppString.homeTotalShipmentText,
                                  textAlign: TextAlign.left,
                                  style: AppTextStyles(context).totalShipmentTextStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.height * 0.02,
                        ),

                        ///  On-Time Delivery Performance card
                        Container(
                          width: MediaQuery.of(context).size.width * 0.53,
                          height: MediaQuery.of(context).size.height * 0.13,
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.themeDarkGreen1,
                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Displays on-time delivery performance and a progress circle.
                              Flexible(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.3,

                                      ///  On-Time Delivery Performance
                                      child: Text(AppString.homeOnTimeDeliveryPerformance,
                                          style: AppTextStyles(context).onTimeDeliveryPerformanceTextStyle),
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width * 0.012),

                                    /// Displays the percentage of on-time deliveries.
                                    Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.height * 0.05,
                                        height: MediaQuery.of(context).size.height * 0.05,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(AppDimen.circular100)),
                                        child: Text(
                                          "${(double.tryParse(driverDashboardController.responseData.value?.onTimeDeliveries ?? "0") ?? 0).toStringAsFixed(0)}%",
                                          style: AppTextStyles(context).performancePercentTextStyle,
                                        )),
                                  ],
                                ),
                              ),
                              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                              /// Displays the average success percentage of other drivers.
                              Text(
                                  driverDashboardController.responseData.value?.otherDriverOnTimeDeliveries == null
                                      ? "${AppString.homeOtherDriversAvgSuccessPercent}0.00 %"
                                      : "${AppString.homeOtherDriversAvgSuccessPercent}${driverDashboardController.responseData.value?.otherDriverOnTimeDeliveries ?? 0.0} %",
                                  style: AppTextStyles(context).totalShipmentTextStyle)
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                    /// Displays total earnings and total routes.
                    Row(
                      children: [
                        ///  Total Earning card
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.53,
                          padding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * 0.03,
                              top: MediaQuery.of(context).size.width * 0.02),
                          decoration: BoxDecoration(
                              color: AppColors.themeGreen2,
                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Displays loaded miles.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(AppString.homeLoadedMilesText,
                                        style: AppTextStyles(context).totalShipmentTextStyle),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.004,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        (((driverDashboardController.responseData.value?.totaLoadedDistance ?? 0) /
                                                1609.344)
                                            .toStringAsFixed(2)),
                                        style: AppTextStyles(context).totalShipmentTextStyle),
                                  ),
                                ],
                              ),

                              /// Displays unloaded miles.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(AppString.homeUnLoadedMilesText,
                                        style: AppTextStyles(context).totalShipmentTextStyle),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.width * 0.004,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        ((((driverDashboardController.responseData.value?.totalDistance ?? 0) -
                                                    (driverDashboardController.responseData.value?.totaLoadedDistance ??
                                                        0)) /
                                                1609.344)
                                            .toStringAsFixed(2)),
                                        style: AppTextStyles(context).totalShipmentTextStyle),
                                  ),
                                ],
                              ),

                              /// Displays total miles.
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(AppString.homeTotalMilesText,
                                        style: AppTextStyles(context).totalShipmentTextStyle),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.width * 0.004),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        (((driverDashboardController.responseData.value?.totalDistance ?? 0) / 1609.344)
                                            .toStringAsFixed(2)),
                                        style: AppTextStyles(context).totalShipmentTextStyle),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.height * 0.022),

                        /// Total Routes card
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width * 0.33,
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 0.04,
                            top: MediaQuery.of(context).size.width * 0.04,
                          ),
                          decoration: BoxDecoration(
                              color: AppColors.themeGreen1Color,
                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Displays the total route count.
                              Text(
                                  driverDashboardController.responseData.value?.totalRoutes == null
                                      ? "0"
                                      : driverDashboardController.responseData.value?.totalRoutes.toString() ?? "0",
                                  style: AppTextStyles(context).numberTextStyle),
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.009,
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                child: Text(AppString.homeTotalRouteText,
                                    textAlign: TextAlign.left, style: AppTextStyles(context).totalShipmentTextStyle),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Adds a gap between sections.
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),

              /// Displays active and assigned routes with a tab bar.
              Container(
                alignment: Alignment.center,
                // height: MediaQuery.of(context).size.width * 0.09,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(AppDimen.circular25),
                ),
                child: TabBar(
                  /// Updates the route index and fetches data based on the selected tab.
                  onTap: (index) {
                    // Should not used it as it only called when tab options are clicked,
                    // not when user swapped
                    if (index == 0) {
                      controller.routeIndex.value = 0;
                      driverDashboardController.getDashboardDetailsByDR(ACTIVE);
                    } else {
                      controller.routeIndex.value = 1;
                      driverDashboardController.getDashboardDetailsByDR(ASSIGNED);
                    }
                  },
                  controller: controller.tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,

                  /// give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimen.circular25),
                    color: AppColors.themeRed1,
                  ),
                  labelColor: AppColors.fontTextWhiteColor,
                  labelStyle: AppTextStyles(context).tabBarTextStyle,
                  unselectedLabelColor: AppColors.fontTextBlackColor,
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    /// Tab for active routes.
                    Tab(text: "${AppString.activeRoutes}(${driverDashboardController.activeRoutesArr.length})"),
                    // second tab [you can add an icon using the icon property]
                    /// Tab for assigned routes.
                    Tab(text: "${AppString.assignedRoutes}(${driverDashboardController.assignedRoutesArr.length})"),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              ///   Thursday, June20, 2023
              //   Container(
              //     width: MediaQuery.of(context).size.width,
              //     alignment: Alignment.center,
              //     child: Text(
              //       AppString.homeThursdayJune20Date,
              //       style: TextStyle(
              //         fontWeight: FontWeight.w600,
              //         fontSize: MediaQuery.of(context).size.height * 0.015,
              //         color: Colors.grey,
              //       ),
              //     ),
              //   ),
              // SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              /// Displays the tab bar views for active and assigned routes.
              Expanded(
                // height: GetPlatform.isAndroid
                //     ? MediaQuery.of(context).size.height * 0.35
                //     : MediaQuery.of(context).size.height * 0.31,
                // width: MediaQuery.of(context).size.width,
                child: TabBarView(
                  controller: controller.tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    /// Displays the active routes tab view.
                    Obx(
                      () => (driverDashboardController.activeRoutesArr.isEmpty)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text(AppString.noDataFound, style: AppTextStyles(context).routeNoTextStyle),
                            )
                          : RefreshIndicator(
                              displacement: 250,
                              backgroundColor: AppColors.themeDarkGreen1,
                              color: Colors.white,
                              strokeWidth: 3,
                              triggerMode: RefreshIndicatorTriggerMode.onEdge,
                              onRefresh: () async {
                                /// Refreshes the active routes data.
                                await driverDashboardController.onRefresh();
                              },
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: driverDashboardController.activeRoutesArr.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return assignedRouteListItem(isActiveRoute: true, context, index, () async {
                                      // final routeDetailController =
                                      // Get.put(RouteDetailsController());
                                      // routeDetailController.routeId =
                                      //     driverDashboardController
                                      //         .activeRoutesArr[index].id ??
                                      //         0;
                                      // routeDetailController.update();
                                      // routeDetailController.getRouteDetails();
                                      // final result = await Get.toNamed(
                                      //     Routes.MAP_ROUTE_UI,
                                      //     arguments: {
                                      //       'route_id':
                                      //       routeDetailController.routeId,
                                      //       "fromScreen": "LoaderDetailScreen"
                                      //     });
                                      // if (result) {
                                      //   routeDetailController.getRouteDetails();
                                      // }

                                      final routeDetailController = RouteDetailController.to;
                                      routeDetailController.routeId =
                                          driverDashboardController.activeRoutesArr[index].id ?? 0;
                                      // routeDetailController.getRouteDetails();
                                      await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return RouteDetailScreen();
                                      }));
                                    }, driverDashboardController.activeRoutesArr[index]);
                                  }),
                            ),
                    ),

                    ///  second tab bar view widget
                    Obx(
                      () => (driverDashboardController.assignedRoutesArr.isEmpty)
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              child: Text(AppString.noDataFound, style: AppTextStyles(context).routeNoTextStyle),
                            )
                          : RefreshIndicator(
                              displacement: 250,
                              backgroundColor: AppColors.themeDarkGreen1,
                              color: Colors.white,
                              strokeWidth: 3,
                              triggerMode: RefreshIndicatorTriggerMode.onEdge,
                              onRefresh: () async {
                                await driverDashboardController.onRefresh();
                              },
                              child: ListView.builder(
                                  itemCount: driverDashboardController.assignedRoutesArr.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return driverDashboardController.assignedRoutesArr.isEmpty
                                        ? const SizedBox()
                                        : assignedRouteListItem(isActiveRoute: false, context, index, () async {
                                            if (driverDashboardController.userRole.value !=
                                                UserRole.MERCHANDISER.name) {
                                              final routeDetailController = Get.put(RouteDetailController());
                                              routeDetailController.routeId =
                                                  driverDashboardController.assignedRoutesArr[index].id ?? 0;
                                              routeDetailController.getRouteDetails();
                                              routeDetailController.update();
                                              final result = await Get.toNamed(Routes.LOADER_ROUTE, arguments: {
                                                'route_id': driverDashboardController.assignedRoutesArr[index].id ?? 0,
                                                "fromScreen": "LoaderDetailScreen"
                                              });

                                              if (result) {
                                                driverDashboardController.getDashboardDetailsByDR(ASSIGNED);
                                              }
                                            }
                                          }, driverDashboardController.assignedRoutesArr[index]);
                                  }),
                            ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget assignedRouteListItem(BuildContext context, int index, Function() onClick, RouteDetail data,
      {required bool isActiveRoute}) {
    return InkWell(
      onTap: onClick,
      child: Column(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.01, bottom: MediaQuery.of(context).size.height * 0.005),
          child: Text(
            (data.deliveryDate != null)
                ? DateFormat("EEEE, MMMM dd, yyyy").format(data.deliveryDate ?? DateTime.now())
                : '',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.height * 0.015,
              color: Colors.grey,
            ),
          ),
        ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.005),
        Container(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: AppColors().green2, width: AppDimen.width2_5),
              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular15))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///   ROOOOI & In Transit (On-Time) text & Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///   ROOOOI Text
                  Text((data.id != null) ? "R${data.id}" : '', style: AppTextStyles(context).routeNoTextStyle),

                  ///   In Transit (On-Time) text & Icon
                  Row(
                    children: [
                      data.forkLift == 0
                          ? Container()
                          : SvgPicture.asset(
                              "assets/svgs/forklift.svg",
                              height: MediaQuery.of(context).size.width * 0.06,
                              color: AppColors.black,
                            ),

                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),

                      ///   In Transit (On-Time)
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
                        decoration: BoxDecoration(
                            color: Utils().bgForStatus(
                                isPickUpOrder: false,
                                (controller.userRole.value == UserRole.LOADER.name &&
                                        data.status.toString() == DRIVER_ASSIGNED)
                                    ? ASSIGNED
                                    : (data.loadingBy == DRIVER)
                                        ? (data.status.toString() == LOADING)
                                            ? LOADING
                                            : (data.status != null)
                                                ? data.status.toString() ?? ""
                                                : ASSIGNED_SELF_LOADING
                                        : (data.status != null)
                                            ? data.status.toString() ?? ""
                                            : 'N/A'),
                            borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular13))),
                        child: Text(
                            (controller.userRole.value == UserRole.LOADER.name &&
                                    data.status.toString() == DRIVER_ASSIGNED)
                                ? AppString.assigned
                                : (data.loadingBy == DRIVER && data.status.toString() == DRIVER_ASSIGNED)
                                    ? AppString.assignedSelfLoading
                                    : data.status.toString().capitalize ?? "N/A",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Utils().bgIsYellow((controller.userRole.value == UserRole.LOADER.name &&
                                            data.status.toString() == DRIVER_ASSIGNED)
                                        ? ASSIGNED
                                        : (data.loadingBy == DRIVER)
                                            ? (data.status.toString() == LOADING)
                                                ? LOADING
                                                : (data.status != null)
                                                    ? data.status.toString() ?? ""
                                                    : ASSIGNED_SELF_LOADING
                                            : (data.status != null)
                                                ? data.status.toString() ?? ""
                                                : '')
                                    ? AppColors.fontTextBlackColor
                                    : AppColors.white,
                                fontSize: MediaQuery.of(context).size.height * 0.015)),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.015),

              ///   Tracker Points
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///   211 miles & Icon
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/round-speed.svg",
                        height: MediaQuery.of(context).size.width * 0.04,
                        color: AppColors.black,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Text(
                          (data.loadedDistance != null)
                              ? ("${((data.loadedDistance ?? 0) / 1609.344).toStringAsFixed(2)} ${AppString.miles}")
                              : '',
                          style: AppTextStyles(context).routeDetailsTransitTextStyle),
                    ],
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.004,
                  ),

                  ///   22H 30M & Icon
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/stopwatch.svg",
                        height: MediaQuery.of(context).size.width * 0.04,
                        color: AppColors.black,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Text(
                          (data.loadedDuration != null)
                              ? ("${(data.loadedDuration ?? 0) ~/ 60}H ${((((data.loadedDuration ?? 0) / 60) - ((data.loadedDuration ?? 0) / 60).floor()) * 60).toInt()}M")
                              : '',
                          style: AppTextStyles(context).routeDetailsTransitTextStyle),
                    ],
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.005,
                  ),

                  ///   PDT & Icon
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/stopwatch.svg",
                        height: MediaQuery.of(context).size.width * 0.04,
                        color: AppColors.black,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Text(
                          (data.plannedDepartureTime != null)
                              ? ("PDT ${DateFormat('hh:mma').format(data.plannedDepartureTime ?? DateTime.now())}")
                              : '',
                          style: AppTextStyles(context).routeDetailsTransitTextStyle),
                    ],
                  ),

                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.005,
                  ),

                  ///   3 Stops & Icon
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/location-3.svg",
                        height: MediaQuery.of(context).size.width * 0.04,
                        color: AppColors.black,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Text((data.totalStops != null) ? ("${data.totalStops} ${AppString.stops}") : '',
                          style: AppTextStyles(context).routeDetailsTransitTextStyle)
                    ],
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.012),

              ///   Origin & Last Drop-off Location
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///   Origin
                  SizedBox(
                    child: Text(AppString.origin, style: AppTextStyles(context).routeDetailsTransitTextStyle1),
                  ),

                  ///   Last Drop-Off Location
                  Row(
                    children: [
                      SizedBox(
                        child: Text(AppString.lastDropOffLocation,
                            style: AppTextStyles(context).routeDetailsTransitTextStyle1),
                      ),
                    ],
                  )
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.012),

              ///   Bethel WHS - Arcodxz,LA & Home Depot 3, City, State
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ///   Bethel WHS-Arcodxz,LA
                  ///
                  ///
                  Container(
                      padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(AppDimen.circular35),
                              topRight: Radius.circular(AppDimen.circular35),
                              bottomRight: Radius.circular(AppDimen.circular35)),
                          color: Colors.grey[200]),
                      width: MediaQuery.of(context).size.width * 0.37,
                      child: Text((data.originPoints != null) ? data.originPoints ?? "N/A" : 'N/A',
                          style: AppTextStyles(context).routesDropOffLocationTextStyle)),

                  ///   Home Dept 3,City,State
                  Container(
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(AppDimen.circular35),
                            topRight: Radius.circular(AppDimen.circular35),
                            bottomLeft: Radius.circular(AppDimen.circular35)),
                        color: Colors.grey[200]),
                    width: MediaQuery.of(context).size.width * 0.37,
                    child: Text((data.lastDropoffLocation != null) ? data.lastDropoffLocation ?? "N/A" : 'N/A',
                        style: AppTextStyles(context).routesDropOffLocationTextStyle),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.005),

              ///   Linear Progress Bar
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 15,
                    width: MediaQuery.of(context).size.width,
                    child: SliderTheme(
                      data: const SliderThemeData(
                        trackHeight: 3,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                      ),
                      child: Slider(
                        value: data.deliveredCount?.toDouble() ?? 0.0,
                        max: double.parse(data.totalStops ?? ""),
                        onChanged: (double value) {},
                        activeColor: AppColors.fontTextRed1,
                        inactiveColor: Colors.grey,
                      ),
                    ),
                  ),
                  //LinearProgressIndicator(
                  //  backgroundColor: Colors.grey,
                  //  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.fontTextRed1),
                  //  value: _progressValue,
                  //),
                ],
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.005),

              ///01 of 03 & Last updated:- 4:30PM
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///   01 of 03
                  Text(
                    "${data.deliveredCount}/${data.totalStops ?? ""}",
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.029,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey),
                  ),

                  ///   Last Updated:- 4:30PM
                  Text(
                    '${AppString.homeLastUpdated430PM}${DateFormat('hh:mma').format(data.updatedAt ?? DateTime.now())}',
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.029,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        )
      ]),
    );
  }
}
