/// `MyLoadPage` is a view class that represents the "My Load" page in the application.
/// It extends `BaseView` and utilizes `MyLoadDriverController` for managing state and logic.
/// This class includes UI components such as a tab bar for active and assigned routes,
/// route details, and functionalities like refreshing data and navigating to route details.
import 'package:bethel_farm/core/app_assets/app_assets.dart';
import 'package:bethel_farm/data/model/response/my_loads_response.dart';
import 'package:bethel_farm/modules/dashboard/route/route_detail_controller.dart';
import 'package:bethel_farm/modules/carrier_owner/load_board/load_board_ctrl.dart';
import 'package:bethel_farm/modules/carrier_owner/load_board/widget/assign_driver_list_dialog.dart';
import 'package:bethel_farm/modules/carrier_owner/load_board/widget/accept_loadboard_dialog.dart';
import 'package:bethel_farm/modules/carrier_owner/carrier_owner/view/carrier_owner.dart';
import 'package:bethel_farm/app/controllers/dashboard_module_controller/dashboard_controller.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/route_details_ctrl.dart';
import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:bethel_farm/core/app_string/app_strings.dart';
import 'package:bethel_farm/core/app_dimens/app_dimens.dart';
import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/route_status_enum.dart';
import '../../../../core/utils/utils.dart';
import '../../../../data/enums/user_role.dart';
import '../../../../modules/dashboard/route/route_details_view.dart';
import '../../../../utils/constants.dart';
import 'package:bethel_farm/base/base_view.dart';
import 'package:bethel_farm/utils/utils.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../utils/route_status_enum.dart';
import '../../../controllers/dashboard_module_controller/route_detail_controller.dart';
import '../../../controllers/my_load_module_controller/my_load_driver_ctrl.dart';
import 'package:get/get.dart';
import 'package:bethel_farm/utils/exports.dart';

import '../dashboard_page_module/route/route_details_view.dart';

class MyLoadPage extends BaseView<MyLoadDriverController> {
  final bool loading = true;
  final double progressValue = 0;
  final myLoadController = Get.put(MyLoadDriverController());

  // late int routeIndex = 0;

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    Get.lazyPut(() => MyLoadDriverController());
    return null;
  }

  final loadBoardController = Get.put(LoadBoardController());
  @override
  Widget body(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.white,
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02),
          child: Column(
            children: [
              Utils().commonAppBar(AppString.myLoadTxt, context),

              SizedBox(height: MediaQuery.of(context).size.height * 0.02),

              /// Active Routes & Assigned Routes with Tab bar
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.width * 0.12,
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 5.0, bottom: 5.0),
                decoration:
                    BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(AppDimen.circular25)),
                child: TabBar(
                  onTap: (index) {
                    if (index == 0) {
                      myLoadController.routeIndex = 0;
                      myLoadController.getOpenRouteList(ACTIVE);
                    } else {
                      myLoadController.routeIndex = 1;
                      myLoadController.getOpenRouteList(ALL);
                    }
                  },
                  controller: myLoadController.tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,

                  /// give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppDimen.circular25), color: AppColors.themeRed1),
                  labelColor: AppColors.fontTextWhiteColor,
                  labelStyle: AppTextStyles(context).tabBarTextStyle,
                  unselectedLabelColor: AppColors.fontTextBlackColor,
                  tabs: [
                    // first tab [you can add an icon using the icon property]
                    Obx(() => myLoadController.userRole.value == UserRole.CARRIER_OWNER.name
                        ? Tab(text: AppString.activeRoutes)
                        : Tab(text: "${AppString.activeRoutes}(${myLoadController.openRoutesList.length})")),

                    // second tab [you can add an icon using the icon property]
                    Obx(() => myLoadController.userRole.value == UserRole.CARRIER_OWNER.name
                        ? Tab(text: AppString.allRoutes)
                        : Tab(text: "${AppString.allRoutes}(${myLoadController.acceptedRoutesList.length})")),
                  ],
                ),
              ),

              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              ///  Tracker Details with tab details
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: myLoadController.tabController,
                  children: [
                    myLoadController.userRole.value == UserRole.CARRIER_OWNER.name
                        ? openCarrierOwnerRouteTabUI(context)
                        : openRouteTabUI(context),
                    myLoadController.userRole.value == UserRole.CARRIER_OWNER.name
                        ? allCarrierOwnerRouteTabUI(context)
                        : acceptedRouteTabUI(context),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  openRouteTabUI(BuildContext context) {
    /// first tab bar view widget
    return Column(
      children: [
        // ///   Thursday, June20, 2023
        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   alignment: Alignment.center,
        //   child: Text(
        //     AppString.homeThursdayJune20Date,
        //     style: TextStyle(
        //       fontWeight: FontWeight.w400,
        //       fontSize: MediaQuery.of(context).size.height * 0.018,
        //       color: Colors.grey,
        //     ),
        //   ),
        // ),
        // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

        Expanded(
            child: RefreshIndicator(
          displacement: 250,
          backgroundColor: AppColors.themeDarkGreen1,
          color: Colors.white,
          strokeWidth: 3,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            // await Future.delayed(const Duration(milliseconds: 1500));
            await controller.onRefresh();
          },
          child: Obx(
            () => (myLoadController.openRoutesList.isEmpty)
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                        child:
                            SizedBox(height: MediaQuery.of(context).size.height * 0.8, child: noDataFoundUI(context))))
                : ListView.builder(
                    itemCount: myLoadController.openRoutesList.length,
                    scrollDirection: Axis.vertical,
                    // shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return listItemRoute(context, index, () {
                        // Get.put(DashboardController()).readRouteByUser(route_id: myLoadController.openRoutesList[index].id ?? 0, userInterface: "myloads");
                        //
                        // final routeDetailController =
                        // Get.put(RouteDetailsController());
                        // routeDetailController.viewOnly.value = true;
                        // routeDetailController.routeId =
                        //     myLoadController.openRoutesList[index].id ?? 0;
                        // Get.toNamed(Routes.LOADER_ROUTE, arguments: {
                        //   'route_id': routeDetailController.routeId,
                        //   "fromScreen": "LoaderDetailScreen"
                        // });
                        // routeDetailController.getRouteDetails();

                        final routeDetailController = Get.put(RouteDetailController());
                        routeDetailController.routeId = myLoadController.openRoutesList[index].id ?? 0;
                        routeDetailController.subDriver = "no";
                        routeDetailController.update();
                        routeDetailController.getRouteDetails();
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                          return RouteDetailScreen();
                        }));
                        // Get.toNamed(Routes.MAP_ROUTE_UI, arguments: {
                        //    'route_id': routeDetailController.routeId,
                        //    "fromScreen": "LoaderDetailScreen"
                        //  });
                      }, myLoadController.openRoutesList[index]);
                    },
                  ),
          ),
        ))
      ],
    );
  }

  acceptedRouteTabUI(BuildContext context) {
    /// Second tab bar view widget
    return Column(
      children: [
        /*///   Thursday, June20, 2023
        Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            AppString.homeThursdayJune20Date,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.height * 0.018,
              color: Colors.grey,
            ),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),*/

        Expanded(
            child: RefreshIndicator(
          displacement: 250,
          backgroundColor: AppColors.themeDarkGreen1,
          color: Colors.white,
          strokeWidth: 3,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1500));
            await controller.onRefresh();
          },
          child: Obx(
            () => Column(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    // margin: EdgeInsets.only(bottom: 8),
                    // width: MediaQuery.of(context).size.width*0.4,
                    //   height: MediaQuery.of(context).size.height * 0.04,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular5)),
                        border: Border.all(width: AppDimen.width1, color: AppColors().gray)),
                    child: Row(children: [
                      SvgPicture.asset(
                        "assets/svgs/filter.svg",
                        height: MediaQuery.of(context).size.width * 0.05,
                        color: AppColors.black,
                      ),
                      Flexible(
                        child: DropdownButtonHideUnderline(
                            child: DropdownButton2<String>(
                                isExpanded: true,
                                items: myLoadController.items.map((String item) {
                                  return DropdownMenuItem<String>(
                                      value: item,
                                      child: item != ACTIVE
                                          ? Text(item.capitalize ?? "",
                                              style: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                                  color: AppColors.white_1))
                                          : SizedBox().marginZero);
                                }).toList(),
                                value: myLoadController.routeStatus?.value,
                                onChanged: (String? value) {
                                  myLoadController.routeStatus?.value = value ?? ALL;
                                  myLoadController.getOpenRouteList(controller.routeStatus?.value ?? ALL);
                                },
                                buttonStyleData: ButtonStyleData(
                                    padding: EdgeInsets.symmetric(horizontal: AppDimen.width18),
                                    height: MediaQuery.of(context).size.height * 0.06,
                                    width: MediaQuery.of(context).size.width),
                                menuItemStyleData:
                                    MenuItemStyleData(height: MediaQuery.of(context).size.height * 0.06))),
                      )
                    ])),
                (myLoadController.acceptedRoutesList.isEmpty)
                    ? SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Center(child: SizedBox(height: 300, child: noDataFoundUI(context))))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: myLoadController.acceptedRoutesList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            return listItemRoute(context, index, () {
                              // final routeDetailController = Get.put(RouteDetailsController());
                              // routeDetailController.routeId =
                              //     loadBoardController.acceptedRoutesList[index].routeId!;
                              // routeDetailController.update();
                              // final dashboardController = Get.find<DashboardController>();
                              // dashboardController.selectedPosition.value = 3; // for carrierOwner
                              // dashboardController.selectedIndex.value = 3; // for carrierOwner
                              // dashboardController.driver[dashboardController.selectedIndex.value];
                              // dashboardController.update();
                              // routeDetailController.getRouteDetails();
                              Get.put(DashboardController()).readRouteByUser(
                                  route_id: myLoadController.acceptedRoutesList[index].id ?? 0,
                                  userInterface: "myloads");

                              gotoViewRouteDetail(index, myLoadController, context);
                            }, myLoadController.acceptedRoutesList[index]);
                          },
                        ),
                      ),
              ],
            ),
          ),
        ))
        // listItemRoute(context),
        // listItemRoute(context),
      ],
    );
  }

  openCarrierOwnerRouteTabUI(BuildContext context) {
    /// first tab bar view widget
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: AppColors.themeDarkGreen1,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        // await Future.delayed(const Duration(milliseconds: 1500));
        await controller.onRefresh();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ///   Thursday, June20, 2023
            // Container(
            //   width: MediaQuery.of(context).size.width,
            //   alignment: Alignment.center,
            //   child: Text(
            //     AppString.homeThursdayJune20Date,
            //     style: TextStyle(
            //       fontWeight: FontWeight.w400,
            //       fontSize: MediaQuery.of(context).size.height * 0.018,
            //       color: Colors.grey,
            //     ),
            //   ),
            // ),
            // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

            Column(
              children: [
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimen.circular30),
                      topRight: Radius.circular(AppDimen.circular30),
                    )),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: AppDimen.width0_39, color: AppColors().green2),
                        borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular30)),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.white),
                        child: ExpansionTile(
                          title: Text(
                              "${AppString.carrierOwner}:(${myLoadController.openCarrierOwnerRoutesList.length})",
                              style: AppTextStyles(context).tabBarTextStyle),
                          backgroundColor: Colors.white,
                          collapsedBackgroundColor: Colors.white,
                          children: [
                            (myLoadController.openCarrierOwnerRoutesList.isEmpty)
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.09,
                                    child: Text(AppString.noDataFound,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.029,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey)),
                                  )
                                : ListView.builder(
                                    itemCount: myLoadController.openCarrierOwnerRoutesList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return listItemRoute(context, index, () async {
                                        Get.put(DashboardController()).readRouteByUser(
                                            route_id: myLoadController.openCarrierOwnerRoutesList[index].id ?? 0,
                                            userInterface: "myloads");
                                        final routeDetailController = Get.put(RouteDetailController());
                                        routeDetailController.routeId =
                                            myLoadController.openCarrierOwnerRoutesList[index].id ?? 0;
                                        routeDetailController.subDriver = "no";
                                        routeDetailController.update();
                                        routeDetailController.getRouteDetails();
                                        routeDetailController.fromScreen = "LoaderDetailScreen";
                                        final result =
                                            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return RouteDetailScreen();
                                        }));
                                        // Get.toNamed(Routes.MAP_ROUTE_UI, arguments: {
                                        //   'route_id': routeDetailController.routeId,
                                        //   "fromScreen": "LoaderDetailScreen"
                                        // });
                                      }, myLoadController.openCarrierOwnerRoutesList[index]);
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimen.circular30),
                      topRight: Radius.circular(AppDimen.circular30),
                    )),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: AppDimen.width0_39, color: AppColors().green2),
                        borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular30)),
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.white),
                        child: ExpansionTile(
                          title: Text("${AppString.subDriver}:(${myLoadController.openSubdriverRoutesList.length})",
                              style: AppTextStyles(context).tabBarTextStyle),
                          backgroundColor: Colors.white,
                          collapsedBackgroundColor: Colors.white,
                          children: [
                            (myLoadController.openSubdriverRoutesList.isEmpty)
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.09,
                                    child: Text(AppString.noDataFound,
                                        style: TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.029,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey)),
                                  )
                                : ListView.builder(
                                    itemCount: myLoadController.openSubdriverRoutesList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
                                      return listItemRoute(context, index, () async {
                                        Get.put(DashboardController()).readRouteByUser(
                                            route_id: myLoadController.openSubdriverRoutesList[index].id ?? 0,
                                            userInterface: "myloads");

                                        final routeDetailController = Get.put(RouteDetailController());
                                        routeDetailController.subDriver = "yes";
                                        routeDetailController.routeId =
                                            myLoadController.openSubdriverRoutesList[index].id ?? 0;
                                        routeDetailController.update();
                                        routeDetailController.getRouteDetails();
                                        routeDetailController.fromScreen = "LoaderDetailScreen";
                                        final result =
                                            await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                          return RouteDetailScreen();
                                        }));
                                        // Get.toNamed(Routes.MAP_ROUTE_UI, arguments: {
                                        //   'route_id': routeDetailController.routeId,
                                        //   "fromScreen": "LoaderDetailScreen"
                                        // });
                                      }, myLoadController.openSubdriverRoutesList[index]);
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  allCarrierOwnerRouteTabUI(BuildContext context) {
    /// first tab bar view widget
    return RefreshIndicator(
      displacement: 250,
      backgroundColor: AppColors.themeDarkGreen1,
      color: Colors.white,
      strokeWidth: 3,
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      onRefresh: () async {
        // await Future.delayed(const Duration(milliseconds: 1500));
        await controller.onRefresh();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(
              () => Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppDimen.circular30),
                  topRight: Radius.circular(AppDimen.circular30),
                )),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: AppDimen.width0_39, color: AppColors().green2),
                    borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular30)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.white),
                    child: ExpansionTile(
                      title: Text(
                          "${AppString.carrierOwner}:(${myLoadController.acceptedCarrierOwnerRoutesList.length})",
                          style: AppTextStyles(context).tabBarTextStyle),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      children: [
                        (myLoadController.acceptedCarrierOwnerRoutesList.isEmpty)
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * 0.09,
                                child: Text(AppString.noDataFound,
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.029,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                              )
                            : ListView.builder(
                                itemCount: myLoadController.acceptedCarrierOwnerRoutesList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return listItemRoute(context, index, () async {
                                    Get.put(DashboardController()).readRouteByUser(
                                        route_id: myLoadController.acceptedCarrierOwnerRoutesList[index].id ?? 0,
                                        userInterface: "myloads");

                                    if (statusToProceedInMyLoadPassed(
                                        myLoadController.acceptedCarrierOwnerRoutesList[index].status.toString())) {
                                      final routeDetailController = Get.put(RouteDetailController());
                                      routeDetailController.subDriver = "no";
                                      routeDetailController.routeId =
                                          myLoadController.acceptedCarrierOwnerRoutesList[index].id ?? 0;
                                      routeDetailController.update();
                                      routeDetailController.getRouteDetails();
                                      routeDetailController.fromScreen = "LoaderDetailScreen";
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return RouteDetailScreen();
                                      }));
                                      // Get.toNamed(Routes.MAP_ROUTE_UI, arguments: {
                                      //   'route_id': routeDetailController.routeId,
                                      //   "fromScreen": "LoaderDetailScreen"
                                      // });
                                    } else {
                                      loadBoardController.routeIndex = 1;
                                      final routeDetailController = Get.put(RouteDetailController());
                                      routeDetailController.viewOnly.value = true;
                                      routeDetailController.routeId =
                                          myLoadController.acceptedCarrierOwnerRoutesList[index].id ?? 0;
                                      Get.toNamed(Routes.LOADER_ROUTE, arguments: {
                                        'route_id': routeDetailController.routeId,
                                        "fromScreen": "LoaderDetailScreen"
                                      });
                                      routeDetailController.getRouteDetails();
                                    }
                                  }, myLoadController.acceptedCarrierOwnerRoutesList[index]);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDimen.circular50),
                  ),
                  // border: Border.all(color: AppColors.themeRed1),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: AppDimen.width0_39, color: AppColors().green2),
                    borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular30)),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.white),
                    child: ExpansionTile(
                      title: Text("${AppString.subDriver}:(${myLoadController.acceptedSubdriverRoutesList.length})",
                          style: AppTextStyles(context).tabBarTextStyle),
                      backgroundColor: Colors.white,
                      collapsedBackgroundColor: Colors.white,
                      children: [
                        (myLoadController.acceptedSubdriverRoutesList.isEmpty)
                            ? SizedBox(
                                height: MediaQuery.of(context).size.height * 0.09,
                                child: Text(AppString.noDataFound,
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.029,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey)),
                              )
                            : ListView.builder(
                                itemCount: myLoadController.acceptedSubdriverRoutesList.length,
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return listItemRoute(context, index, () async {
                                    Get.put(DashboardController()).readRouteByUser(
                                        route_id: myLoadController.acceptedSubdriverRoutesList[index].id ?? 0,
                                        userInterface: "myloads");

                                    if (statusToProceedInMyLoadPassed(
                                        myLoadController.acceptedSubdriverRoutesList[index].status.toString())) {
                                      final routeDetailController = Get.put(RouteDetailController());
                                      routeDetailController.routeId =
                                          myLoadController.acceptedSubdriverRoutesList[index].id ?? 0;
                                      routeDetailController.subDriver = "yes";
                                      routeDetailController.update();
                                      routeDetailController.getRouteDetails();
                                      routeDetailController.fromScreen = "LoaderDetailScreen";
                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                        return RouteDetailScreen();
                                      }));
                                      // Get.toNamed(Routes.MAP_ROUTE_UI, arguments: {
                                      //   'route_id': routeDetailController.routeId,
                                      //   "fromScreen": "LoaderDetailScreen"
                                      // });
                                    } else {
                                      loadBoardController.routeIndex = 1;
                                      final routeDetailController = Get.put(RouteDetailController());
                                      routeDetailController.viewOnly.value = true;
                                      routeDetailController.routeId =
                                          myLoadController.acceptedSubdriverRoutesList[index].id ?? 0;
                                      Get.toNamed(Routes.LOADER_ROUTE, arguments: {
                                        'route_id': routeDetailController.routeId,
                                        "fromScreen": "LoaderDetailScreen"
                                      });
                                      routeDetailController.getRouteDetails();
                                    }
                                  }, myLoadController.acceptedSubdriverRoutesList[index]);
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void gotoViewRouteDetail(int index, MyLoadDriverController loadBoardController, BuildContext context) async {
    if (statusToProceedInMyLoadPassed(loadBoardController.acceptedRoutesList[index].status.toString())) {
      final routeDetailController = Get.put(RouteDetailController());
      routeDetailController.routeId = loadBoardController.acceptedRoutesList[index].id ?? 0;
      routeDetailController.subDriver = "no";

      // routeDetailController.getRouteDetails();
      routeDetailController.fromScreen = "LoaderDetailScreen";
      routeDetailController.update();
      final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return RouteDetailScreen();
      }));
      // final result = await Get.toNamed(Routes.MAP_ROUTE_UI, arguments: {
      //   'route_id': routeDetailController.routeId,
      //   "fromScreen": "LoaderDetailScreen"
      // });
    } else {
      final routeDetailController = Get.put(RouteDetailController());
      routeDetailController.viewOnly.value = false;
      // routeDetailController.getRouteDetails();
      routeDetailController.routeId = loadBoardController.acceptedRoutesList[index].id! ?? 0;
      routeDetailController.update();
      Get.toNamed(Routes.LOADER_ROUTE,
          arguments: {'route_id': routeDetailController.routeId, "fromScreen": "LoaderDetailScreen"});
    }
  }

  Widget listItemRoute(BuildContext context, index, Function() onClick, RouteDetailData routeData) {
    //'planned',
    // 'posted-to-loadboard',
    // 'driver-assigned',
    // 'loaded',
    var canChangeDriver =
        routeData.status == PLANNED || routeData.status == POSTED_TO_LOADBOARD || routeData.status == DRIVER_ASSIGNED;

    return InkWell(
        onTap: onClick,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: const EdgeInsets.only(top: 15.0, bottom: 5),
              alignment: Alignment.center,
              child: Text(
                (routeData.deliveryDate != null)
                    ? DateFormat("EEEE, MMMM dd, yyyy")
                        .format(routeData.deliveryDate?.toLocal() ?? DateTime.now().toLocal())
                    : '',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.height * 0.015,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height * 0.3,
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
              margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),

              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                border: Border.all(color: AppColors().green2, width: AppDimen.width1_5),
                borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular15)),
              ),

              ///   ROOOOI & In Transit (On-Time)
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///   ROOOOI & In Transit (On-Time) text & Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///   ROOOOI Text
                      Text('R${routeData.id ?? ""}',
                          style: AppTextStyles(context).bold3TextStyle(
                              fontSize: MediaQuery.of(context).size.height * 0.025, textColor: AppColors().golden2)),

                      ///   In Transit (On-Time) text & Icon
                      Row(
                        children: [
                          ///   Forklift Icon
                          Visibility(
                            visible: routeData.forkLift == 1,
                            child: SvgPicture.asset(
                              AppAssets.forkliftIcon,
                              height: MediaQuery.of(context).size.width * 0.06,
                              color: AppColors.black,
                            ),
                          ),

                          ///   For Gap
                          SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                          ///   In Transit (On-Time)
                          Container(
                            height: MediaQuery.of(context).size.height * 0.045,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.width * 0.001,
                                bottom: MediaQuery.of(context).size.width * 0.001,
                                left: MediaQuery.of(context).size.width * 0.025,
                                right: MediaQuery.of(context).size.width * 0.025),
                            decoration: BoxDecoration(
                                color: Utils().bgForStatus(
                                    isPickUpOrder: false,
                                    (controller.userRole.value == UserRole.LOADER.name &&
                                            routeData.status.toString() == DRIVER_ASSIGNED)
                                        ? ASSIGNED
                                        : (routeData.loadingBy == DRIVER)
                                            ? (routeData.status.toString() == LOADING)
                                                ? LOADING
                                                : (routeData.status != null)
                                                    ? routeData.status.toString() ?? ""
                                                    : ASSIGNED_SELF_LOADING
                                            : (routeData.status != null)
                                                ? routeData.status.toString() ?? ""
                                                : 'N/A'), // AppColors().yellow1,
                                borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular8))),
                            child: Text(
                                (controller.userRole.value == UserRole.LOADER.name &&
                                        routeData.status.toString() == DRIVER_ASSIGNED)
                                    ? AppString.assigned
                                    : (routeData.loadingBy == DRIVER && routeData.status.toString() == DRIVER_ASSIGNED)
                                        ? AppString.assignedSelfLoading
                                        : routeData.status.toString().capitalize ?? "N/A",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Utils().bgIsYellow((controller.userRole.value == UserRole.LOADER.name &&
                                                routeData.status.toString() == DRIVER_ASSIGNED)
                                            ? ASSIGNED
                                            : (routeData.loadingBy == DRIVER)
                                                ? (routeData.status.toString() == LOADING)
                                                    ? LOADING
                                                    : (routeData.status != null)
                                                        ? routeData.status.toString() ?? ""
                                                        : ASSIGNED_SELF_LOADING
                                                : (routeData.status != null)
                                                    ? routeData.status.toString() ?? ""
                                                    : 'N/A')
                                        ? AppColors.fontTextBlackColor
                                        : AppColors.white,
                                    fontSize: MediaQuery.of(context).size.height * 0.015)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     ///   ROOOOI Text
                  //     Text("R${routeData.id}",
                  //         style: AppTextStyles(context).routeNoTextStyle),
                  //
                  //     ///   In Transit (On-Time) text & Icon
                  //     Row(
                  //       children: [
                  //         routeData.forkLift == 0
                  //             ? const SizedBox()
                  //             : SvgPicture.asset(
                  //                 "assets/svgs/forklift.svg",
                  //                 height:
                  //                     MediaQuery.of(context).size.width * 0.06,
                  //                 color: AppColors.black,
                  //               ),
                  //
                  //         SizedBox(
                  //           width: MediaQuery.of(context).size.width * 0.02,
                  //         ),
                  //
                  //         ///   In Transit (On-Time)
                  //         Container(
                  //           height: MediaQuery.of(context).size.height * 0.05,
                  //           alignment: Alignment.center,
                  //           padding: EdgeInsets.all(
                  //               MediaQuery.of(context).size.height * 0.01),
                  //           decoration: BoxDecoration(
                  //               color: Utils().bgForStatus(
                  //                   isPickUpOrder: false,
                  //                   (controller.userRole.value ==
                  //                               UserRole.LOADER.name &&
                  //                           routeData.status.toString() ==
                  //                               "driver-assigned")
                  //                       ? "assigned"
                  //                       : (routeData.loadingBy == "driver")
                  //                           ? (routeData.status.toString() ==
                  //                                   "loading")
                  //                               ? "loading"
                  //                               : (routeData.status != null)
                  //                                   ? routeData.status
                  //                                           .toString() ??
                  //                                       ""
                  //                                   : "Assigned-Self Loading"
                  //                           : (routeData.status != null)
                  //                               ? routeData.status.toString() ??
                  //                                   ""
                  //                               : 'N/A'),
                  //               borderRadius: BorderRadius.all(
                  //                   Radius.circular(AppDimen.circular13))),
                  //           child: Text(
                  //               (controller.userRole.value ==
                  //                           UserRole.LOADER.name &&
                  //                       routeData.status.toString() ==
                  //                           "driver-assigned")
                  //                   ? "Assigned"
                  //                   : (routeData.loadingBy == "driver")
                  //                       ? (routeData.status.toString() ==
                  //                               "loading")
                  //                           ? "Loading"
                  //                           : (routeData.status != null)
                  //                               ? routeData.status
                  //                                       .toString()
                  //                                       .capitalize ??
                  //                                   ""
                  //                               : "Assigned-Self Loading "
                  //                       : (routeData.status != null)
                  //                           ? routeData.status
                  //                                   .toString()
                  //                                   .capitalize ??
                  //                               ""
                  //                           : 'N/A',
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.w500,
                  //                   color: Utils().bgIsYellow((controller.userRole.value ==
                  //                       UserRole.LOADER.name &&
                  //                       routeData.status.toString() ==
                  //                           "driver-assigned")
                  //                       ? "assigned"
                  //                       : (routeData.loadingBy == "driver")
                  //                       ? (routeData.status.toString() ==
                  //                       "loading")
                  //                       ? "loading"
                  //                       : (routeData.status != null)
                  //                       ? routeData.status
                  //                       .toString() ??
                  //                       ""
                  //                       : "Assigned-Self Loading"
                  //                       : (routeData.status != null)
                  //                       ? routeData.status.toString() ??
                  //                       ""
                  //                       : 'N/A') ? AppColors.fontTextBlackColor : AppColors.white,
                  //                   fontSize: MediaQuery.of(context).size.height * 0.015)),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),

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
                              "${Utils.metersToMiles(routeData.loadedDistance?.toDouble() ?? 0.0).toStringAsFixed(2)} ${AppString.miles}",
                              style: AppTextStyles(context).routeDetailsTransitTextStyle)
                        ],
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
                          Text((Utils.formatMinutes(routeData.loadedDuration ?? 0)),
                              style: AppTextStyles(context).routeDetailsTransitTextStyle)
                        ],
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
                          Text(("PDT ${DateFormat('hh:mma').format(routeData.plannedDepartureTime ?? DateTime.now())}"),
                              style: AppTextStyles(context).routeDetailsTransitTextStyle)
                        ],
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
                          Text(routeData.totalStops ?? "" "${AppString.stops}",
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
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svgs/location-3.svg",
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: AppColors.fontTextGreen1Color,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),
                          Text(AppString.origin, style: AppTextStyles(context).routeDetailsTransitTextStyle1),
                        ],
                      ),

                      ///   Last Drop-Off Location
                      Row(
                        children: [
                          Text(AppString.lastDropOffLocation,
                              style: AppTextStyles(context).routeDetailsTransitTextStyle1),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),
                          SvgPicture.asset(
                            "assets/svgs/location-3.svg",
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: AppColors.fontTextGreen1Color,
                          ),
                        ],
                      )
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.007,
                  ),

                  ///   Bethel WHS - Arcodxz,LA      & Home Depot 3, City, State
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///   Bethel WHS-Arcodxz,LA
                        Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(AppDimen.circular35),
                                      topRight: Radius.circular(AppDimen.circular35),
                                      bottomRight: Radius.circular(AppDimen.circular35)),
                                  color: Colors.grey[200]),
                              child: Text(routeData.originPoints ?? "",
                                  style: AppTextStyles(context).routesDropOffLocationTextStyle)),
                        ),
                        SizedBox(
                          width: 5,
                        ),

                        ///   Home Dept 3,City,State
                        Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(AppDimen.circular35),
                                      topRight: Radius.circular(AppDimen.circular35),
                                      bottomLeft: Radius.circular(AppDimen.circular35)),
                                  color: Colors.grey[200]),
                              child: Text(routeData.lastDropoffLocation ?? "",
                                  style: AppTextStyles(context).routesDropOffLocationTextStyle)),
                        )
                      ]),

                  // SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  /*  ///   Linear Progress Bar
              Container(
                // padding: EdgeInsets.all(1.0),
                child: loading
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          LinearProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.fontTextRed1),
                            value: progressValue,
                          ),
                        ],
                      )
                    : Text("Press button for downloading",
                        style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.005)),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),

              ///   01 of 03 & Last updated:- 4:30PM
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ///   01 of 03
                  Text(
                    AppString.home01Of03,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.033,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey),
                  ),

                  ///   Last Updated:- 4:30PM
                  Text(
                    AppString.homeLastUpdated430PM,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.033,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey),
                  ),
                ],
              ),
              */

                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  ///Call, View Details and Assign Driver
                  controller.userRole.value == UserRole.CARRIER_OWNER.name
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///   Icon and Call
                            myLoadController.routeIndex != 0
                                ? canChangeDriver
                                    ? InkWell(
                                        onTap: () {
                                          Utils().makePhoneCall(
                                              '$countryCode${routeData.shipmentDeliveries?[0].shipment?.warehouse?.primaryPhoneNo ?? ""}');
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: AppDimen.padding6,
                                            bottom: AppDimen.padding6,
                                            left: AppDimen.padding8,
                                            right: AppDimen.padding8,
                                          ),
                                          decoration: BoxDecoration(
                                              color: AppColors().green1,
                                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular7))),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svgs/call.svg",
                                                height: MediaQuery.of(context).size.width * 0.03,
                                                color: AppColors.whiteColor,
                                              ),
                                              SizedBox(width: MediaQuery.of(context).size.width * 0.008),
                                              Text(
                                                AppString.callBethel,
                                                style: AppTextStyles(context).bold4TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.017,
                                                    textColor: AppColors.white),
                                              )
                                            ],
                                          ),
                                        ))
                                    : SizedBox().marginZero
                                : SizedBox().marginZero,

                            /// For Gap
                            // SizedBox(width: MediaQuery.of(context).size.width * 0.015),

                            ///   Icon and View Details
                            // InkWell(
                            //     onTap: () {
                            //       // final routeDetailController = Get.put(RouteDetailsController());
                            //       // routeDetailController.routeId = openRoutesList.routeId!;
                            //       // routeDetailController.update();
                            //       // final dashboardController = Get.find<DashboardController>();
                            //       // dashboardController.selectedPosition.value = 3; // for carrierOwner
                            //       // dashboardController.selectedIndex.value = 3; // for carrierOwner
                            //       // dashboardController.driver[dashboardController.selectedIndex.value];
                            //       // dashboardController.update();
                            //       // routeDetailController.getRouteDetails();
                            //
                            //       final routeDetailController = Get.put(RouteDetailsController());
                            //       routeDetailController.viewOnly.value = false;
                            //       routeDetailController.routeId = routeData.id ?? 0;
                            //       Get.toNamed(Routes.LOADER_ROUTE, arguments: {
                            //         'route_id': routeDetailController.routeId,
                            //         "fromScreen": "LoaderDetailScreen"
                            //       });
                            //       routeDetailController.getRouteDetails();
                            //     },
                            //     child: Container(
                            //       padding: EdgeInsets.only(
                            //         top: AppDimen.padding6,
                            //         bottom: AppDimen.padding6,
                            //         left: AppDimen.padding8,
                            //         right: AppDimen.padding8,
                            //       ),
                            //       decoration: BoxDecoration(
                            //           color: AppColors().red1,
                            //           borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular7))),
                            //       child: Row(
                            //         children: [
                            //           SvgPicture.asset(
                            //             "assets/svgs/view-detail.svg",
                            //             height: MediaQuery.of(context).size.width * 0.03,
                            //             color: AppColors.whiteColor,
                            //           ),
                            //           SizedBox(width: MediaQuery.of(context).size.width * 0.008),
                            //           Text(
                            //             "View Details",
                            //             style: AppTextStyles(context).bold4TextStyle(
                            //                 fontSize: MediaQuery.of(context).size.height * 0.017, textColor: AppColors.white),
                            //           )
                            //         ],
                            //       ),
                            //     )),

                            /// For Gap
                            // SizedBox(width: MediaQuery.of(context).size.width * 0.015),

                            ///   Icon and Assign Driver
                            myLoadController.routeIndex != 0
                                ? canChangeDriver
                                    ? InkWell(
                                        onTap: () {
                                          if (myLoadController.routeIndex == 0) {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  return AcceptLoadBoardRouteDialog(loadBoardId: routeData.id ?? 0);
                                                });
                                          } else if (myLoadController.routeIndex == 1 && canChangeDriver) {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (context) {
                                                  Get.put(LoadBoardController()).assignedDriverId =
                                                      routeData.driver?.id;
                                                  return AssignDriverListDialog(
                                                    routeId: routeData.id ?? 0,
                                                  );
                                                });
                                          }
                                          // else {
                                          //   Utils.showErrorMessage(
                                          //       "You Can't Change Driver. Route is Started");
                                          // }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            top: AppDimen.padding6,
                                            bottom: AppDimen.padding6,
                                            left: AppDimen.padding6,
                                            right: AppDimen.padding6,
                                          ),
                                          decoration: BoxDecoration(
                                              color:
                                                  // (myLoadController.routeIndex == 1 &&
                                                  //         canChangeDriver == true)
                                                  //     ? AppColors().gray
                                                  //     :
                                                  AppColors().red1,
                                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular7))),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                "assets/svgs/assign-driver.svg",
                                                height: MediaQuery.of(context).size.width * 0.03,
                                                color: AppColors.whiteColor,
                                              ),
                                              SizedBox(width: MediaQuery.of(context).size.width * 0.008),
                                              Text(
                                                (myLoadController.routeIndex == 0)
                                                    ? AppString.acceptRoute
                                                    : AppString.changeDriver,
                                                style: AppTextStyles(context).bold4TextStyle(
                                                    fontSize: MediaQuery.of(context).size.height * 0.016,
                                                    textColor: AppColors.white),
                                              )
                                            ],
                                          ),
                                        ))
                                    : SizedBox().marginZero
                                : SizedBox().marginZero,
                          ],
                        )
                      : const SizedBox().marginZero,
                ],
              ),
            ),
          ],
        ));
  }
}
