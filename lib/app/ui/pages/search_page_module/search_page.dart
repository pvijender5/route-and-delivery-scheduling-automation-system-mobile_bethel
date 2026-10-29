/// \[SearchPage\] is a view class that extends \[BaseView\] and provides the UI for the search functionality.
/// It uses \[SearchViewController\] to manage the state and logic.
/// The class includes methods for rendering the app bar, body, and various UI components related to search operations.

import 'package:bethel_farm/base/base_view.dart';
import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/core/app_dimens/app_dimens.dart';
import 'package:bethel_farm/core/app_string/app_strings.dart';
import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:bethel_farm/data/enums/user_role.dart';
import 'package:bethel_farm/data/model/common/stepperShipment.dart';
import 'package:bethel_farm/data/model/response/pickup_orders_response.dart';
import 'package:bethel_farm/data/model/response/routes_response.dart';
import 'package:bethel_farm/modules/dashboard/route/route_detail_controller.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/shipment_loading_details/stop_loading_ctrl.dart';
import 'package:bethel_farm/modules/loader/pickup_order_detail/view/quantity_dialog.dart';
import 'package:bethel_farm/app/controllers/search_module_controller/search_ctrl.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/app_assets/app_assets.dart';
import '../../../../utils/constants.dart';
import '../../../../modules/dashboard/route/route_details_view.dart';
import '../../../../utils/route_status_enum.dart';
import '../../../../utils/utils.dart';
import '../../../../modules/merchandiser/ctrl/home_merchandiser_ctrl.dart';
import '../../../../modules/merchandiser/view/merchandiser_route_detail.dart';

// ignore: use_key_in_widget_constructors
class SearchPage extends BaseView<SearchViewController> {
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    Get.lazyPut(() => SearchViewController());
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02),
        child: Obx(
          () => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///   Search, Bell icon and Profile icon
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
                  child: Column(
                    children: [
                      // SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                      ///   Search text, Bell icon and Profile icon
                      Utils().commonAppBar(AppString.searchSearchText, context),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                      ///Search icon and text field
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                // width: MediaQuery.of(context).size.width * 0.8,
                                height: MediaQuery.of(context).size.height * 0.07,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width * 0.02,
                                    right: MediaQuery.of(context).size.width * 0.02),
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ///   Search icon
                                      Container(
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.003),
                                          child: Icon(Icons.search,
                                              size: MediaQuery.of(context).size.width * 0.06, color: Colors.black)),

                                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),

                                      ///   Input search text
                                      Container(
                                        alignment: Alignment.center,
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        height: MediaQuery.of(context).size.height,
                                        child: TextField(
                                          controller: controller.searchTextController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: (AppString.searchByRouteOrShipmentNo),
                                              hintStyle: TextStyle(
                                                  fontSize: MediaQuery.of(context).size.width * 0.032,
                                                  color: AppColors.textColorBlack)),
                                          textInputAction: TextInputAction.done,
                                          onChanged: (value) {
                                            if (value.trim().isEmpty) {
                                              controller.search.value = 0;
                                              controller.searchTextController?.text = "";
                                              controller.clearList();
                                            } else /*if (value.trim().length >= 3)*/ {
                                              controller.search.value++;
                                              controller.getRouteDetails();
                                            }
                                            controller.refresh();
                                            controller.update();
                                          },
                                          onSubmitted: (value) {
                                            if (value.trim().isEmpty) {
                                              controller.search.value = 0;
                                              // controller.searchTextController?0.text = "";
                                            } else {
                                              controller.search.value++;
                                              controller.getRouteDetails();
                                            }
                                            FocusScope.of(context).unfocus();
                                          },
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context).size.width * 0.04,
                                              color: AppColors.textColorBlack),
                                        ),
                                      )
                                    ]))
                          ]),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.012),

                      // (controller.userRole.value.toLowerCase() == "loader")
                      //(controller.userRole.value.toLowerCase() == "merchandiser") routeDetail.shipmentDeliveries?

                      ///   Routes '3 Found'
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Visibility(
                              visible: true,
                              //!(controller.userRole.value.toLowerCase() == "loader") ? {controller.routeDetail.length + controller.dataPickUp.length}!=0 : (controller.userRole.value.toLowerCase() == "merchandiser") ? {controller.routeDetail.length}!=0 : {controller.routeDetail.length}!=0,
                              child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      (controller.resultCount.value == "0")
                                          ? AppString.noDataFound
                                          : controller.search.value == 0
                                              ? AppString.noDataFound
                                              : "${controller.resultCount.value} ${(controller.resultCount.value == '1') ? AppString.result : AppString.results} ${AppString.found}",
                                      style: AppTextStyles(context).routes3Found))),

                          ///   Filter icon
                          Visibility(
                            visible: false,
                            replacement: Container(
                                // width: MediaQuery.of(context).size.width*0.4,
                                height: MediaQuery.of(context).size.height * 0.04,
                                decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular5)),
                                    border: Border.all(width: AppDimen.width1, color: AppColors().gray)),
                                child: Row(children: [
                                  const SizedBox(width: 10.0),
                                  Obx(() => Image.asset(
                                      (controller.selectedValue?.value == "Newest")
                                          ? AppAssets.ascSort
                                          : AppAssets.desSort,
                                      height: 30,
                                      color: AppColors.black)),
                                  DropdownButtonHideUnderline(
                                      child: Obx(() => DropdownButton2<String>(
                                          isExpanded: true,
                                          items: controller.items.map((String item) {
                                            return DropdownMenuItem<String>(
                                                value: item,
                                                child: Text(item,
                                                    style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.width * 0.035,
                                                        color: AppColors.white_1)));
                                          }).toList(),
                                          value: controller.selectedValue?.value,
                                          onChanged: (String? value) {
                                            controller.selectedValue?.value = value ?? "Newest";
                                            controller.getRouteDetails();
                                          },
                                          buttonStyleData: ButtonStyleData(
                                              padding: EdgeInsets.symmetric(horizontal: AppDimen.width18),
                                              height: MediaQuery.of(context).size.height * 0.06,
                                              width: MediaQuery.of(context).size.width * 0.32),
                                          menuItemStyleData:
                                              MenuItemStyleData(height: MediaQuery.of(context).size.height * 0.06))))
                                ])),
                            child: GestureDetector(
                              onTap: () {
                                _displayTextInputDialog(context, controller);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.14,
                                // height: MediaQuery.of(context).size.height * 0.065,
                                padding: EdgeInsets.all(15),
                                alignment: Alignment.center,
                                // padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                                decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                                child: SvgPicture.asset("assets/svgs/adjust.svg",
                                    height: MediaQuery.of(context).size.height * 0.03),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),

              /// For Gap
              SizedBox(height: MediaQuery.of(context).size.height * 0.015),

              ///   Active Routes & Assigned Routes with Tab bar
              Visibility(
                  visible: controller.userRole.value == UserRole.LOADER.name,
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.height * 0.46,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(AppDimen.circular25),
                    ),
                    child: TabBar(
                      onTap: (index) {
                        controller.activeSearchTabIndex.value = index;
                        // Should not used it as it only called when tab options are clicked,
                        // not when user swapped
                        // if (index == 0) {
                        //   routeIndex = 0;
                        //   carrierOwnerController.getDashboardDetailsByCO("active");
                        // } else {
                        //   routeIndex = 1;
                        //   carrierOwnerController.getDashboardDetailsByCO("assigned");
                        // }
                      },
                      controller: controller.tabController,
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
                        Obx(() => Tab(text: "${AppString.routes} (${controller.routeDetail.length})")),
                        // second tab [you can add an icon using the icon property]
                        Obx(() => Tab(text: "${AppString.pUOrders} (${controller.dataPickUp.length})")),
                      ],
                    ),
                  )),

              Visibility(
                  visible: controller.userRole.value == UserRole.LOADER.name,
                  child: SizedBox(height: MediaQuery.of(context).size.height * 0.01)),

              /// Tracker details with tab details
              Expanded(
                // height: (controller.userRole.value == UserRole.LOADER.name)
                //     ? GetPlatform.isAndroid
                //         ? MediaQuery.of(context).size.height * 0.59
                //         : MediaQuery.of(context).size.height * 0.54
                //     : GetPlatform.isAndroid
                //         ? MediaQuery.of(context).size.height * 0.67
                //         : MediaQuery.of(context).size.height * 0.6,
                // width: MediaQuery.of(context).size.width,
                child: Visibility(
                  visible: controller.userRole.value == UserRole.LOADER.name,

                  /// Other User Route List
                  replacement: Obx(() => controller.routeDetail.isEmpty
                      ? noDataFoundUI(context, isShipment: false)
                      : ListView.builder(
                          itemCount: controller.routeDetail.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return searchScreenItem(() async {
                              if (controller.userRole.value == UserRole.LOADER.name) {
                                final routeDetailController = Get.put(RouteDetailController());
                                routeDetailController.routeId = controller.routeDetail[index].id ?? 0;
                                print(">>> result : ${routeDetailController.routeId}");
                                routeDetailController.update();
                                routeDetailController.getRouteDetails();
                                final result = await Get.toNamed(Routes.LOADER_ROUTE,
                                    arguments: {'route_id': routeDetailController.routeId});
                                print(">>> result :   ${routeDetailController.routeId}");
                                if (result) {
                                  // controller.search.value++;
                                  controller.getRouteDetails();
                                } else {
                                  controller.search.value = 0;
                                  controller.searchTextController?.text = "";
                                  controller.clearList();
                                }
                                // stopLoadingController.update();
                                // routeDetailController.getRouteDetails();
                                // routeDetailController.update();
                              } else if (controller.userRole.value == UserRole.CARRIER_OWNER.name ||
                                  controller.userRole.value == UserRole.DRIVER.name ||
                                  controller.userRole.value == UserRole.SUB_DRIVER.name) {
                                if (statusToProceedInMyLoadPassed(controller.routeDetail[index].status.toString())
                                    // (controller.routeDetail[index].status.toString() ==
                                    //     "in-transit-on-time" || controller.routeDetail[index].status.toString() ==
                                    //     "in-transit-delay"|| controller.routeDetail[index].status.toString() ==
                                    //     "in-transit-arrived"||controller.routeDetail[index].status.toString() ==
                                    //     "completed" ||controller.routeDetail[index].status.toString() ==
                                    //     "delivered")
                                    ) {
                                  final routeDetailController = Get.put(RouteDetailController());
                                  routeDetailController.routeId = controller.routeDetail[index].id ?? 0;
                                  if ((controller.userRole.value == UserRole.CARRIER_OWNER.name)) {
                                    if (controller.routeDetail[index].driver?.role?.name == "carrier-owner") {
                                      routeDetailController.subDriver = "no";
                                    } else {
                                      routeDetailController.subDriver = "yes";
                                    }
                                  } else {
                                    routeDetailController.subDriver = "no";
                                  }

                                  routeDetailController.getRouteDetails();
                                  routeDetailController.routeId = controller.routeDetail[index].id ?? 0;
                                  routeDetailController.update();
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                    return RouteDetailScreen();
                                  }));
                                  // Get.toNamed(Routes.MAP_ROUTE_UI, arguments: {
                                  //   'route_id': routeDetailController.routeId,
                                  //   "fromScreen": "LoaderDetailScreen"
                                  // });
                                } else {
                                  final routeDetailController = Get.put(RouteDetailController());
                                  routeDetailController.routeId = controller.routeDetail[index].id ?? 0;
                                  print(">>> result : ${routeDetailController.routeId}");
                                  routeDetailController.update();
                                  routeDetailController.getRouteDetails();
                                  final result = await Get.toNamed(Routes.LOADER_ROUTE,
                                      arguments: {'route_id': routeDetailController.routeId});
                                  print(">>> result :   ${routeDetailController.routeId}");
                                  if (result) {
                                    // controller.search.value++;
                                    controller.getRouteDetails();
                                  } else {
                                    controller.search.value = 0;
                                    controller.searchTextController?.text = "";
                                    controller.clearList();
                                  }
                                  // stopLoadingController.update();
                                  // routeDetailController.getRouteDetails();
                                  // routeDetailController.update();
                                }
                              } else {
                                null;
                              }
                            }, context, controller.routeDetail[index], controller);
                          })),

                  /// Loader Route UI && Shipment UI..
                  child: TabBarView(
                    controller: controller.tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      /// first tab bar view widget
                      Obx(() => controller.routeDetail.isEmpty
                          ? noDataFoundUI(context, isShipment: false)
                          : ListView.builder(
                              itemCount: controller.routeDetail.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return searchScreenItem(() async {
                                  final routeDetailController = Get.put(RouteDetailController());
                                  routeDetailController.routeId = controller.routeDetail[index].id ?? 0;
                                  routeDetailController.getRouteDetails();
                                  print(">>> result : ${routeDetailController.routeId}");
                                  final result = await Get.toNamed(Routes.LOADER_ROUTE,
                                      arguments: {'route_id': routeDetailController.routeId});
                                  print(">>> result :   ${routeDetailController.routeId}");
                                  if (result != null && result == true) {
                                    // controller.search.value++;
                                    controller.getRouteDetails();
                                  } else {
                                    // controller.search.value = 0;
                                    // controller.searchTextController?.text = "";
                                    // controller.clearList();
                                    controller.getRouteDetails();
                                  }
                                  // stopLoadingController.update();
                                  routeDetailController.getRouteDetails();
                                  routeDetailController.update();
                                }, context, controller.routeDetail[index], controller);
                              })),

                      ///  second tab bar view widget
                      Obx(() => controller.dataPickUp.isEmpty
                          ? noDataFoundUI(context, isShipment: true)
                          : ListView.builder(
                              itemCount: controller.dataPickUp.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                // return Container(child: Text("sdfsd"));
                                return shipmentListItem(
                                    isPickUpOrder: true, context, controller.dataPickUp[index], controller);
                              })),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  noDataFoundUI(BuildContext context, {required bool isShipment}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.16,
      alignment: Alignment.center,
      child: Text("${AppString.no} ${isShipment ? AppString.shipments : AppString.routes} ${AppString.found}",
          style: AppTextStyles(context).routeNoTextStyle),
    );
  }
}

_displayTextInputDialog(BuildContext context, SearchViewController controller) async {
  return showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.03,
                    right: MediaQuery.of(context).size.height * 0.03,
                    top: MediaQuery.of(context).size.height * 0.025,
                    bottom: MediaQuery.of(context).size.height * 0.025,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.white, borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///   Sort By and cross icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///   Sort By
                          Text("${AppString.sortBy} :",
                              style: AppTextStyles(context).bold4TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.045, textColor: AppColors.black)),

                          ///   Icon
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.close, size: MediaQuery.of(context).size.width * 0.07),
                          )
                        ],
                      ),

                      ///   For Gap
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                      ///   Shipment / Delivery Date
                      Text(AppString.shipmentDate,
                          style: AppTextStyles(context).bold4TextStyle(
                              fontSize: MediaQuery.of(context).size.width * 0.045, textColor: AppColors.black)),

                      ///   For gap
                      SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                      ///   Date Picker
                      Obx(
                        () => InkWell(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1950),
                                lastDate: DateTime(2050));
                            if (pickedDate != null) {
                              controller.displayDate?.value = DateFormat('MM-dd-yyyy').format(pickedDate);
                              controller.formattedDate?.value = DateFormat('yyyy-MM-dd 00:00:00').format(pickedDate);
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            // height: MediaQuery.of(context).size.height * 0.06,
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(15),
                            // padding: EdgeInsets.only(
                            //   left: MediaQuery.of(context).size.width * 0.03,
                            //   right: MediaQuery.of(context).size.width * 0.03,
                            // ),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular5)),
                              border: Border.all(color: AppColors().gray, width: AppDimen.width1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  controller.displayDate?.value ?? "MM-DD-YYYY",
                                  style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.045, color: AppColors.white_1),
                                ),
                                Icon(
                                  Icons.calendar_month,
                                  size: MediaQuery.of(context).size.width * 0.055,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      ///   For gap
                      SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                      ///   Order By Time
                      Text(AppString.sortByTime,
                          style: AppTextStyles(context).bold4TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.045,
                            textColor: AppColors.black,
                          )),

                      ///   For Gap
                      SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                      /// Drop Down List
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular5)),
                            border: Border.all(width: AppDimen.width1, color: AppColors().gray)),
                        child: DropdownButtonHideUnderline(
                          child: Obx(
                            () => DropdownButton2<String>(
                              isExpanded: true,
                              items: controller.items.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.04, color: AppColors.white_1),
                                  ),
                                );
                              }).toList(),
                              value: controller.selectedValue?.value,
                              onChanged: (String? value) {
                                controller.selectedValue?.value = value ?? "Newest";
                              },
                              buttonStyleData: ButtonStyleData(
                                padding: EdgeInsets.symmetric(horizontal: AppDimen.width15),
                                height: MediaQuery.of(context).size.height * 0.06,
                                width: MediaQuery.of(context).size.width * 0.55,
                              ),
                              menuItemStyleData: MenuItemStyleData(
                                height: MediaQuery.of(context).size.height * 0.06,
                              ),
                            ),
                          ),
                        ),
                      ),

                      ///   For gap
                      SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                      ///   For Gap
                      SizedBox(height: MediaQuery.of(context).size.height * 0.035),

                      ///   Apply Button and Cancel Button
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ///   Apply Button
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.055,
                              decoration: BoxDecoration(
                                  color: AppColors().green1,
                                  borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                              child: MaterialButton(
                                child: Text(AppString.apply,
                                    style: AppTextStyles(context).bold4TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.045,
                                        textColor: AppColors.white)),
                                onPressed: () {
                                  Navigator.pop(context);
                                  if (controller.search.value != 0) {
                                    controller.search.value++;
                                  }
                                  controller.getRouteDetails();
                                },
                              ),
                            ),

                            ///   Clear Button
                            Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: MediaQuery.of(context).size.height * 0.055,
                              decoration: BoxDecoration(
                                  color: AppColors().red1,
                                  borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                              child: MaterialButton(
                                child: Text(AppString.clear,
                                    style: AppTextStyles(context).bold4TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.045,
                                        textColor: AppColors.white)),
                                onPressed: () {
                                  controller.displayDate?.value = "MM-DD-YYYY";
                                  controller.formattedDate?.value = "";
                                  controller.selectedValue?.value = "Newest";
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

Widget searchScreenItem(
    Function() onClick, BuildContext context, RoutesData routeDetail, SearchViewController controller) {
  return InkWell(
    onTap: onClick,
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height * 0.01, top: MediaQuery.of(context).size.height * 0.01),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: AppDimen.width1_5),
          borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ///   R OOOOI Text
                Text('R${routeDetail.id ?? ""}', style: AppTextStyles(context).routeNoTextStyle),

                ///   In Transit (On-Time) text & Icon
                Row(
                  children: [
                    routeDetail.forkLift == 0
                        ? Container()
                        : SvgPicture.asset("assets/svgs/forklift.svg",
                            height: MediaQuery.of(context).size.height * 0.03),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                    ///   In Transit (On-Time)
                    Obx(
                      () => Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
                        decoration: BoxDecoration(
                            color: Utils().bgForStatus(
                                isPickUpOrder: false,
                                (controller.userRole.value == UserRole.LOADER.name &&
                                        routeDetail.status.toString() == DRIVER_ASSIGNED)
                                    ? ASSIGNED
                                    : (routeDetail.loadingBy == DRIVER)
                                        ? (routeDetail.status.toString() == LOADING)
                                            ? LOADING
                                            : (routeDetail.status != null)
                                                ? routeDetail.status.toString() ?? ""
                                                : ASSIGNED_SELF_LOADING
                                        : (routeDetail.status != null)
                                            ? routeDetail.status.toString() ?? ""
                                            : 'N/A'),
                            borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular5))),
                        child: Text(
                            (controller.userRole.value == UserRole.LOADER.name &&
                                    routeDetail.status.toString() == DRIVER_ASSIGNED)
                                ? AppString.assigned
                                : (routeDetail.loadingBy == DRIVER && routeDetail.status.toString() == DRIVER_ASSIGNED)
                                    ? AppString.assignSelfLoading
                                    : routeDetail.status.toString().capitalize ?? "N/A",

                            // (controller.userRole.value == UserRole.LOADER.name &&
                            //         routeDetail.status.toString() == "driver-assigned")
                            //     ? "Assigned"
                            //     : (routeDetail.loadingBy == "driver")
                            //         ? (routeDetail.status.toString() == "loading")
                            //             ? "Loading"
                            //             : (routeDetail.status != null)
                            //                 ? routeDetail.status.toString().capitalize ?? ""
                            //                 : "Assigned-Self Loading"
                            //         : (routeDetail.status != null)
                            //             ? routeDetail.status.toString().capitalize ?? ""
                            //             : 'N/A',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Utils().bgIsYellow((controller.userRole.value == UserRole.LOADER.name &&
                                            routeDetail.status.toString() == DRIVER_ASSIGNED)
                                        ? ASSIGNED
                                        : (routeDetail.loadingBy == DRIVER)
                                            ? (routeDetail.status.toString() == LOADING)
                                                ? LOADING
                                                : (routeDetail.status != null)
                                                    ? routeDetail.status.toString() ?? ""
                                                    : ASSIGNED_SELF_LOADING
                                            : (routeDetail.status != null)
                                                ? routeDetail.status.toString() ?? ""
                                                : 'N/A')
                                    ? AppColors.fontTextBlackColor
                                    : AppColors.white,
                                fontSize: MediaQuery.of(context).size.height * 0.015)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: MediaQuery.of(context).size.height * 0.012),

          if (controller.userRole.value.toLowerCase() == DRIVER ||
              controller.userRole.value.toLowerCase() == SUB_DRIVER ||
              controller.userRole.value.toLowerCase() == CARRIER_OWNER) ...[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
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
                        SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                        Text(
                            (routeDetail.loadedDistance != null)
                                ? ("${((routeDetail.loadedDistance ?? 0) / 1609.344).toStringAsFixed(2)}${AppString.miles}")
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
                            (routeDetail.loadedDuration != null)
                                ? ("${(routeDetail.loadedDuration ?? 0) ~/ 60}H ${((((routeDetail.loadedDuration ?? 0) / 60) - ((routeDetail.loadedDuration ?? 0) / 60).floor()) * 60).toInt()}M")
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
                            (routeDetail.plannedDepartureTime != null)
                                ? ("PDT ${DateFormat('hh:mma').format(routeDetail.plannedDepartureTime ?? DateTime.now())}")
                                : '',
                            style: AppTextStyles(context).routeDetailsTransitTextStyle),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.012),

                ///   3 Stops & Icon
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/svgs/location-3.svg",
                      height: MediaQuery.of(context).size.width * 0.04,
                      color: AppColors.black,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                    Text(
                        (routeDetail.totalStops != null)
                            ? (routeDetail.totalStops == 1)
                                ? "1 ${AppString.stop}"
                                : ("${routeDetail.totalStops} ${AppString.stops}")
                            : '',
                        maxLines: 2,
                        style: AppTextStyles(context).routeDetailsTransitTextStyle),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.012),
                const SizedBox(height: 5),
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
                        Text(AppString.origin,
                            style: AppTextStyles(context).bold3TextStyle(
                                textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.03)),
                      ],
                    ),

                    ///   Last Drop-Off Location
                    Row(
                      children: [
                        Text(AppString.lastDropOffLocation,
                            style: AppTextStyles(context).bold3TextStyle(
                                textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.03)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   Bethel WHS-Arcodxz,LA
                    Flexible(
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppDimen.circular35),
                                topRight: Radius.circular(AppDimen.circular35),
                                bottomRight: Radius.circular(AppDimen.circular35)),
                            color: Colors.grey[200]),
                        child: Text((routeDetail.originPoints != null) ? routeDetail.originPoints ?? "N/A" : '',
                            style: AppTextStyles(context).routesDropOffLocationTextStyle),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    ///   Home Dept 3,City,State
                    Flexible(
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.only(
                          top: 5,
                        ),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppDimen.circular35),
                                topRight: Radius.circular(AppDimen.circular35),
                                bottomLeft: Radius.circular(AppDimen.circular35)),
                            color: Colors.grey[200]),
                        child: Text(
                            (routeDetail.lastDropoffLocation != null) ? routeDetail.lastDropoffLocation ?? "N/A" : '',
                            style: AppTextStyles(context).routesDropOffLocationTextStyle),
                      ),
                    ),
                  ],
                ),

                ///   Origin & Last Drop-off Location
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     ///   Origin
                //     Row(
                //       children: [
                //         SvgPicture.asset(
                //           "assets/svgs/location-3.svg",
                //           height: MediaQuery.of(context).size.width * 0.04,
                //           color: AppColors.fontTextGreen1Color,
                //         ),
                //         SizedBox(
                //           width: MediaQuery.of(context).size.width * 0.005,
                //         ),
                //         SizedBox(
                //           width: MediaQuery.of(context).size.width * 0.3,
                //           child: Text(
                //               (routeDetail.originPoints != null)
                //                   ? routeDetail.originPoints ?? "N/A"
                //                   : '',
                //               maxLines: 2,
                //               style: AppTextStyles(context)
                //                   .routeDetailsTransitTextStyle1),
                //         ),
                //       ],
                //     ),
                //
                //     ///   Last Drop-Off Location
                //     Row(
                //       children: [
                //         SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.35,
                //             child: Text(
                //                 (routeDetail.lastDropoffLocation != null)
                //                     ? routeDetail.lastDropoffLocation ?? "N/A"
                //                     : '',
                //                 maxLines: 2,
                //                 style: AppTextStyles(context)
                //                     .routeDetailsTransitTextStyle1)),
                //         SizedBox(
                //             width: MediaQuery.of(context).size.width * 0.005),
                //         SvgPicture.asset(
                //           "assets/svgs/location-3.svg",
                //           height: MediaQuery.of(context).size.width * 0.04,
                //           color: AppColors.fontTextGreen1Color,
                //         ),
                //       ],
                //     )
                //   ],
                // ),
              ],
            ),
          ],

          if (controller.userRole.value.toLowerCase() == "loader") ...[
            Column(children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),

              ///   Driver name, Customer name & id and Total stops
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///   Driver Name & Icon
                  Row(
                    children: [
                      SvgPicture.asset("assets/svgs/user.svg", height: MediaQuery.of(context).size.height * 0.025),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Text(routeDetail.driver?.name ?? "N/A", style: AppTextStyles(context).driverToVinTextStyle)
                    ],
                  ),

                  ///   Total Stops & Icon
                  Row(
                    children: [
                      SvgPicture.asset("assets/svgs/location-3.svg",
                          height: MediaQuery.of(context).size.height * 0.025),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      if (routeDetail.totalStops == "1") ...[
                        Text("${routeDetail.totalStops} ${AppString.stop}",
                            style: AppTextStyles(context).driverToVinTextStyle)
                      ] else ...[
                        Text("${routeDetail.totalStops} ${AppString.stops}",
                            style: AppTextStyles(context).driverToVinTextStyle)
                      ],
                    ],
                  ),

                  ///   PDT 09:30AM & Icon
                  Row(
                    children: [
                      SvgPicture.asset("assets/svgs/stopwatch.svg", height: MediaQuery.of(context).size.height * 0.025),
                      Text("PDT ${DateFormat("h:mma").format(routeDetail.plannedDepartureTime ?? DateTime.now())}",
                          style: AppTextStyles(context).driverToVinTextStyle),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 5),

              ///   PDT 09:30AM, P:30 R:50 t:30 and VIN icon
              Row(children: [
                ///   VN & Icon
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svgs/VIN.svg", height: MediaQuery.of(context).size.height * 0.03),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Text(
                        routeDetail.truck?.vin ?? "N/A",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        softWrap: false, // Add this line to prevent wrapping to the next line
                        style: AppTextStyles(context).driverToVinTextStyle,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Row(children: [
                  ///   P:30 R:50 t:30 & Icon
                  SvgPicture.asset("assets/svgs/scale.svg", height: MediaQuery.of(context).size.height * 0.025),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                  Text("P:${routeDetail.pQuantity} R:${routeDetail.rQuantity} T:${routeDetail.tQuantity}",
                      style: AppTextStyles(context).driverToVinTextStyle)
                ])
              ])
            ])
          ],

          // (controller.userRole.value.toLowerCase() == "loader")
          //(controller.userRole.value.toLowerCase() == "merchandiser") routeDetail.shipmentDeliveries?

          if (controller.userRole.value.toLowerCase() == "merchandiser") ...[
            ListView.builder(
                itemCount: routeDetail.shipmentDeliveries?.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return searchScreenMerchandiserItem(
                      context, routeDetail.shipmentDeliveries?[index], routeDetail, controller);
                })
          ],

          // controller.userRole.value.toLowerCase()=="loader"?
          // Container()
          //     :SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
          //
          // ///   Bethel WHS - Arcadia, LA and Origin and Icon
          // controller.userRole.value.toLowerCase()=="loader"?
          // Container()
          //     :Row(
          //   children: [
          //     ///   Icon
          //     SvgPicture.asset(
          //       "assets/svgs/location-3.svg",
          //       height: MediaQuery.of(context).size.width * 0.04,
          //       color: AppColors.black,
          //     ),
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.005,
          //     ),
          //
          //     ///   Bethel WHS - Acardia, LA text
          //     Text(routeDetail.originPoints??"",
          //         style: AppTextStyles(context).routeDetailsTransitTextStyle),
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.005,
          //     ),
          //
          //     ///   Origin Point text
          //     Text(AppString.routeDetailOriginPoint,
          //         style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle),
          //   ],
          // ),
          // controller.userRole.value.toLowerCase()=="loader"?
          // Container()
          //     :SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.01,
          // ),
          //
          // ///  Home Depot 4, City, State and Last Drop-off Location
          // controller.userRole.value.toLowerCase()=="loader"?
          // Container()
          //     :Row(
          //   children: [
          //     ///   Icon
          //     SvgPicture.asset(
          //       "assets/svgs/location-3.svg",
          //       height: MediaQuery.of(context).size.width * 0.04,
          //       color: AppColors.black,
          //     ),
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.005,
          //     ),
          //
          //     ///   Home Depot 4, City, State text
          //     SizedBox(
          //       width: 150,
          //       child: Text(routeDetail.lastDropoffLocation??"N/A",
          //           maxLines: 2,
          //           style: AppTextStyles(context).routeDetailsTransitTextStyle),
          //     ),
          //     SizedBox(
          //       width: MediaQuery.of(context).size.width * 0.005,
          //     ),
          //
          //     ///   Last Drop-off Location text
          //     Text(AppString.routeDetailLastDropOffLocation,
          //         style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle),
          //   ],
          // ),
        ],
      ),
    ),
  );
}

Widget shipmentListItem(BuildContext context, PickUpItems pickUpItems, SearchViewController controller,
    {required bool isPickUpOrder}) {
  return InkWell(
    onTap: () async {
      var shipmentID = pickUpItems.shipmentDeliveries?.id;
      final stopLoadingController = Get.put(StopLoadingController());
      stopLoadingController.stopId = shipmentID!;
      stopLoadingController.getStopDetails();

      final result = await Get.toNamed(Routes.STOP_LOAD_DETAILS);
      if (result != null && result == true) {
        // pickupOrderListController.getAllPickUpOrders();
        // controller.search.value++;
        controller.getRouteDetails();
      }
      stopLoadingController.update();
    },
    child: Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.23,
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      margin: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.01,
          // bottom: MediaQuery.of(context).size.height * 0.01,
          left: MediaQuery.of(context).size.height * 0.01,
          right: MediaQuery.of(context).size.height * 0.01),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.lightGreyColor, width: AppDimen.width1_5),
          borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular15))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ///   PS0001, Icon and In transit time
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(pickUpItems.name.toString() ?? "", style: AppTextStyles(context).routeNoTextStyle),
            Row(children: [
              ///   Forklift Icon
              Visibility(
                  visible: pickUpItems.forkLift == 1,
                  child: SvgPicture.asset(AppAssets.forkliftIcon,
                      height: MediaQuery.of(context).size.width * 0.06, color: AppColors.black)),

              SizedBox(width: MediaQuery.of(context).size.width * 0.02),

              /// Delivery Status
              (pickUpItems.shipmentDeliveries?.deliveryStatus == null)
                  ? const SizedBox()
                  : Container(
                      // height: MediaQuery.of(context).size.height * 0.045,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                      decoration: BoxDecoration(
                          color: Utils().bgForStatus(
                              isPickUpOrder: isPickUpOrder,
                              pickUpItems.shipmentDeliveries!.deliveryStatus.toString() ?? ""),
                          borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular13))),
                      child: Text(
                          (pickUpItems.shipmentDeliveries?.deliveryStatus == "new")
                              ? AppString.assignedToWarehouse
                              : (pickUpItems.shipmentDeliveries?.deliveryStatus == LOADED)
                                  ? AppString.completed
                                  : pickUpItems.shipmentDeliveries?.deliveryStatus.toString().capitalize ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Utils().bgIsYellow(pickUpItems.shipmentDeliveries!.deliveryStatus ?? "")
                                  ? AppColors.fontTextBlackColor
                                  : AppColors.white,
                              fontSize: MediaQuery.of(context).size.height * 0.015)))
            ])
          ]),

          /// "BF - Arcadia, FL"
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SvgPicture.asset("assets/svgs/warehouse.svg", height: MediaQuery.of(context).size.height * 0.016),
            SizedBox(width: MediaQuery.of(context).size.width * 0.024),
            Text(pickUpItems.warehouse?.address ?? "", style: AppTextStyles(context).driverToVinTextStyle)
          ]),

          /// The Home Depot
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SvgPicture.asset("assets/svgs/user.svg", height: MediaQuery.of(context).size.height * 0.016),
            SizedBox(width: MediaQuery.of(context).size.width * 0.024),
            Text(pickUpItems.customer?.name ?? "N/A", style: AppTextStyles(context).driverToVinTextStyle)
          ]),

          /// Phone number
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SvgPicture.asset("assets/svgs/phone-filled.svg", height: MediaQuery.of(context).size.height * 0.016),
            SizedBox(width: MediaQuery.of(context).size.width * 0.024),
            Text((pickUpItems.customer?.phone == null) ? "N/A" : "+${pickUpItems.customer?.phone ?? ""}",
                style: AppTextStyles(context).driverToVinTextStyle)
          ]),

          /// Order date time
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            /// forklift : yes / No
            /*SvgPicture.asset("assets/svgs/forklift.svg",
                    height: MediaQuery.of(context).size.height * 0.016),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.024,
                ),
                (pickupOrderController.responseData.value?.pickUpOrderItem?[index].forkLift == null)
                    ? const SizedBox()
                    : Text(
                        (pickupOrderController.responseData.value?.pickUpOrderItem?[index].forkLift == 0)
                            ? "No"
                            : "Yes",
                        style: AppTextStyles(context).driverToVinTextStyle),

                  SizedBox(
                  width: MediaQuery.of(context).size.width * 0.024,
                  ),
                        */

            SvgPicture.asset("assets/svgs/sharp-calendar-month.svg",
                height: MediaQuery.of(context).size.height * 0.016),
            SizedBox(width: MediaQuery.of(context).size.width * 0.014),
            Text(
                ('${DateFormat('MM/dd/yyyy').format(DateTime.parse(pickUpItems.routeDate.toString() ?? ""))}'
                    '(${DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(pickUpItems.propsDeliveryWindow?[0].start.toString() ?? "")).split(' ')[1]}'
                    ' ${DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(pickUpItems.propsDeliveryWindow?[0].start.toString() ?? "")).split(' ')[2]}'
                    ' - ${DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(pickUpItems.propsDeliveryWindow?[0].end.toString() ?? "")).split(' ')[1]}'
                    ' ${DateFormat("yyyy-MM-dd hh:mm a").format(DateTime.parse(pickUpItems.propsDeliveryWindow?[0].start.toString() ?? "")).split(' ')[2]})'),
                style: AppTextStyles(context).driverToVinTextStyle)
          ]),

          /// P, R. T Values
          (pickUpItems.shipmentDeliveries == null)
              ? const SizedBox()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset("assets/svgs/scale.svg", height: MediaQuery.of(context).size.height * 0.016),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                    Text(
                        "P:${pickUpItems.shipmentDeliveries?.pQuantity} R:${pickUpItems.shipmentDeliveries?.rQuantity} T:${pickUpItems.shipmentDeliveries?.tQuantity}",
                        style: AppTextStyles(context).driverToVinTextStyle),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.017),
                    InkWell(
                      onTap: () {
                        controller.getShipmentInventory(pickUpItems.shipmentDeliveries?.shipmentId ?? 0).then((value) {
                          showDialog(
                              context: context,
                              builder: (context) =>
                                  QuantityPopUp(inventoryData: controller.inventoryList, isRoutePopUp: false));
                        });
                      },
                      child:
                          SvgPicture.asset("assets/svgs/info.svg", height: MediaQuery.of(context).size.height * 0.016),
                    ),
                  ],
                ),
        ],
      ),
    ),
  );
}

Widget searchScreenMerchandiserItem(
    BuildContext context, ShipmentDelivery? shipmentDelivery, RoutesData routeDetail, SearchViewController controller) {
  int eta = shipmentDelivery?.duration ?? 0;
  String pdt = DateFormat('hh:mm a').format((routeDetail.plannedDepartureTime) ?? DateTime.now());
  // Parse the start time
  DateTime parsedStartTime = DateFormat('h:mm a').parse(pdt);

  // Add 136 minutes
  DateTime updatedTime = parsedStartTime.add(Duration(minutes: eta));

  // Format the result with AM/PM
  String etaText = DateFormat('h:mm a').format(updatedTime);
  return (shipmentDelivery == null ||
          shipmentDelivery.shipment == null ||
          shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations == null)
      ? const SizedBox().marginZero
      : InkWell(
          onTap: () {
            if (controller.userRole.value == UserRole.MERCHANDISER.name) {
              final routeDetailController = Get.put(RouteDetailController());
              final merchandiserDashboardController = Get.put(HomeMerchandiserController());
              routeDetailController.routeId = routeDetail.id ?? 0;
              routeDetailController.merchandiserLocationName =
                  shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationName ?? "";
              routeDetailController.getRouteDetails();
              Get.to(MerchandiserRouteDetail());
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: Colors.grey[200], borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular15))),
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 8, left: 8),
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(shipmentDelivery.shipment?.name ?? "N/A", style: AppTextStyles(context).routeNoTextStyle),

                ///   Associated Route ID and ROOOOI
                controller.userRole.value == UserRole.MERCHANDISER.name
                    ? Text(
                        (shipmentDelivery != null)
                            ? '${AppString.associatedRouteId} : ${shipmentDelivery.routeId ?? "N/A".toString()}'
                            : '',
                        style: AppTextStyles(context).routesDropOffLocationTextStyle,
                      )
                    : Container(),
                const SizedBox(
                  height: 8,
                ),

                ///   Driver name, Customer name & id and Total stops
                Row(
                  children: [
                    SvgPicture.asset("assets/svgs/user.svg", height: MediaQuery.of(context).size.height * 0.015),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.005,
                    ),
                    Flexible(
                      child: Text(
                          shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationName ?? "N/A",
                          softWrap: true,
                          style: AppTextStyles(context).driverToVinTextStyle),
                    )
                  ],
                ),

                ///   Driver name, Customer name & id and Total stops
                Row(
                  children: [
                    ///   Location Icon
                    SvgPicture.asset(
                      AppAssets.locationIcon,
                      height: MediaQuery.of(context).size.width * 0.04,
                      color: AppColors.darkGreyIconColor,
                    ),

                    ///   For Gap
                    SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                    Flexible(
                      child: Text(
                          '${shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine1 ?? ""}'
                          '${shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine2 ?? ""}'
                          ', ${shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCity ?? ""}'
                          ', ${shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationState ?? ""} ${shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationZipcode} ${shipmentDelivery.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCountry}',
                          softWrap: true,
                          style: AppTextStyles(context).bold3TextStyle(
                              textColor: AppColors.fontTextDarkGreyColor,
                              fontSize: MediaQuery.of(context).size.width * 0.032)),
                    ),
                  ],
                ),

                ///   Driver name, Customer name & id and Total stops
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ///   ETA 5:20pm and Icon
                    Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.timeIcon,
                          height: MediaQuery.of(context).size.width * 0.037,
                          color: AppColors().gray2,
                        ),
                        Text(
                          " ETA :",
                          style: AppTextStyles(context).bold3TextStyle(
                              textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.028),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                        Text(
                          etaText,
                          style: AppTextStyles(context).bold3TextStyle(
                              textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.028),
                        ),
                      ],
                    ),

                    /// prop windows
                    Row(
                      children: [
                        ///   Icon
                        SvgPicture.asset(
                          AppAssets.calendarIcon,
                          height: MediaQuery.of(context).size.width * 0.05,
                          color: AppColors().gray2,
                        ),

                        ///   For Gap
                        SizedBox(width: MediaQuery.of(context).size.width * 0.005),

                        ///   22H 30M(Expected) text
                        (shipmentDelivery.shipment?.propsDeliveryWindow ?? []).isEmpty
                            ? Text("N/A",
                                style: AppTextStyles(context).bold3TextStyle(
                                    textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.03))
                            : Text(
                                '${Utils.convertDateFormatDDMMYYYY(routeDetail.deliveryDate?.toLocal().toString() ?? DateTime.now().toLocal().toString()).split(' ')[0]}'
                                '\n(${Utils.formatUtcDateTime((shipmentDelivery.shipment?.propsDeliveryWindow?[0].start ?? DateTime.now()).toString()).split(' ')[1]}'
                                ' ${Utils.formatUtcDateTime((shipmentDelivery.shipment?.propsDeliveryWindow?[0].start ?? DateTime.now()).toString()).split(' ')[2]}'
                                ' - ${Utils.formatUtcDateTime((shipmentDelivery.shipment?.propsDeliveryWindow?[0].end ?? DateTime.now()).toString()).split(' ')[1]}'
                                ' ${Utils.formatUtcDateTime((shipmentDelivery.shipment?.propsDeliveryWindow?[0].end ?? DateTime.now()).toString()).split(' ')[2]})',
                                style: AppTextStyles(context).bold3TextStyle(
                                    textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.03)),
                      ],
                    ),
                  ],
                ),

                ///   For Gap
                const SizedBox(height: 5),
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
                        Text(AppString.origin,
                            style: AppTextStyles(context).bold3TextStyle(
                                textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.03)),
                      ],
                    ),

                    ///   Last Drop-Off Location
                    Row(
                      children: [
                        Text(AppString.lastDropOffLocation,
                            style: AppTextStyles(context).bold3TextStyle(
                                textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.03)),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///   Bethel WHS-Arcodxz,LA
                    Flexible(
                      child: Container(
                        width: 150,
                        margin: EdgeInsets.only(top: 5),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppDimen.circular35),
                                topRight: Radius.circular(AppDimen.circular35),
                                bottomRight: Radius.circular(AppDimen.circular35)),
                            color: Colors.grey[50]),
                        child: Text((routeDetail.originPoints != null) ? routeDetail.originPoints ?? "N/A" : '',
                            style: AppTextStyles(context).routesDropOffLocationTextStyle),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    ///   Home Dept 3,City,State
                    Flexible(
                      child: Container(
                        width: 150,
                        margin: const EdgeInsets.only(
                          top: 5,
                        ),
                        padding: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppDimen.circular35),
                                topRight: Radius.circular(AppDimen.circular35),
                                bottomLeft: Radius.circular(AppDimen.circular35)),
                            color: Colors.grey[50]),
                        child: Text(
                            (routeDetail.lastDropoffLocation != null) ? routeDetail.lastDropoffLocation ?? "N/A" : '',
                            style: AppTextStyles(context).routesDropOffLocationTextStyle),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
}
