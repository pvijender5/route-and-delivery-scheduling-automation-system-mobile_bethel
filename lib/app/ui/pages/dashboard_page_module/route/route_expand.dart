import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:stepper_list_view/stepper_list_view.dart';

import '../../../../core/app_assets/app_assets.dart';
import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_dimens/app_dimens.dart';
import '../../../../core/app_string/app_strings.dart';
import '../../../../utils/utils.dart';
import '../../../data/enums/user_role.dart';
import '../../../data/model/response/pickup_order_detail_response.dart';
import '../../../../controllers/dashboard_module_controller/route_detail_controller.dart';
import 'route_details_view.dart';
import '../../../utils/constants.dart';
import '../../loader/pickup_order_detail/view/notes_modal_bottom_sheet.dart';
import '../../loader/pickup_order_detail/view/quantity_dialog.dart';
import '../../../app/controllers/account_controller.dart';
import '../../../app/controllers/stop_details_ctrl.dart';

class RouteExpand extends StatelessWidget {
  /// Initial route for navigation.
  RouteExpand({
    Key? key,
  });

  RouteDetailController controller = RouteDetailController.to;

  ///   Route details UI
  Widget expandTileRoute(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimen.circular30),
          topRight: Radius.circular(AppDimen.circular30),
        )),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.white),
          child: Card(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: AppDimen.width0_39, color: AppColors().green2),
              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular30)),
            ),
            child: ExpansionTile(
              initiallyExpanded: true,
              onExpansionChanged: (bo) {
                if (bo) {
                  controller.isRouteOpen.value = true;
                  controller.isStopOpen.value = false;
                } else {
                  controller.isRouteOpen.value = false;
                  controller.isStopOpen.value = true;
                }
              },
              backgroundColor: Colors.white,
              collapsedBackgroundColor: Colors.white,
              title: Text(AppString.routeDetails,
                  textAlign: TextAlign.left, style: AppTextStyles(context).routeDetailsAndStopDetails),
              children: [
                Container(
                  padding: EdgeInsets.only(
                      // top: MediaQuery.of(context).size.width * 0.01,
                      bottom: MediaQuery.of(context).size.width * 0.02,
                      left: MediaQuery.of(context).size.width * 0.018,
                      right: MediaQuery.of(context).size.width * 0.018),

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///   ROOOOI & In Transit (On-Time) text & Icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///   ROOOOI Text
                          Text("R${controller.routeDetail.value?.id ?? ""}",
                              style: AppTextStyles(context).routeNoTextStyle),

                          ///   In Transit (On-Time) text & Icon
                          Row(
                            children: [
                              controller.routeDetail.value?.forkLift == 0
                                  ? Container()
                                  : SvgPicture.asset("assets/svgs/forklift.svg",
                                      height: MediaQuery.of(context).size.width * 0.06, color: AppColors.black),

                              SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                              ///   In Transit (On-Time)
                              Container(
                                height: MediaQuery.of(context).size.height * 0.042,
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.width * 0.001,
                                    bottom: MediaQuery.of(context).size.width * 0.001,
                                    left: MediaQuery.of(context).size.width * 0.025,
                                    right: MediaQuery.of(context).size.width * 0.025),
                                decoration: BoxDecoration(
                                    color: Utils()
                                        .bgForStatus(isPickUpOrder: false, controller.routeDetail.value?.status ?? ""),
                                    //AppColors().inTransitBackGroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular8))),
                                child: Text(controller.routeDetail.value?.status.toString().capitalize ?? "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Utils().bgIsYellow(controller.routeDetail.value?.status ?? "")
                                            ? AppColors.fontTextBlackColor
                                            : AppColors.white,
                                        fontSize: MediaQuery.of(context).size.height * 0.015)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                      ///   July 29,2023, 3 Stops, P:30 R:50 T:30 and Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///   July 20,2023 & Icon
                          Row(
                            children: [
                              SvgPicture.asset('assets/icons/sharp-calendar-month.svg',
                                  height: MediaQuery.of(context).size.width * 0.04, color: AppColors.black),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.005),
                              Text(
                                  Utils.formatDateString(DateTime.parse(
                                      controller.routeDetail.value?.plannedDepartureTime?.toLocal().toString() ??
                                          DateTime.now().toLocal().toString())),
                                  style: AppTextStyles(context).routeDetailsTransitTextStyle)
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04,
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
                              Text('${controller.routeDetail.value?.totalStops ?? "0"} ${AppString.stops}',
                                  style: AppTextStyles(context).routeDetailsTransitTextStyle)
                            ],
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.04,
                          ),

                          ///   P:30 R:50 T:30 & Icon
                          Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/scale.svg",
                                height: MediaQuery.of(context).size.width * 0.04,
                                color: AppColors.black,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.005,
                              ),
                              Text(
                                  'P: ${controller.routeDetail.value?.pQuantity ?? "0"} '
                                  'R:${controller.routeDetail.value?.rQuantity ?? "0"} '
                                  'T:${controller.routeDetail.value?.tQuantity ?? "0"} ',
                                  style: AppTextStyles(context).routeDetailsTransitTextStyle),
                              InkWell(
                                onTap: () {
                                  controller
                                      .getRouteShipmentInventory(controller.routeDetail.value?.id ?? 0)
                                      .then((value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            QuantityPopUp(inventoryData: controller.inventoryList, isRoutePopUp: true));
                                  });
                                },
                                child: Icon(
                                  Icons.info_outline,
                                  color: AppColors.black,
                                  size: MediaQuery.of(context).size.width * 0.04,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                      ///   PDT 09:30AM, 120 miles and icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///   PDT 09:30AM & Icon
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
                                  "PDT ${DateFormat('hh:mma').format(controller.routeDetail.value?.plannedDepartureTime ?? DateTime.now())}",
                                  style: AppTextStyles(context).routeDetailsTransitTextStyle)
                            ],
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.04),

                          ///   120 miles & Icon
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
                                  '${Utils.metersToMiles(controller.routeDetail.value?.loadedDistance?.toDouble() ?? 0.0).toStringAsFixed(2)} ${AppString.miles}(${AppString.expected})',
                                  style: AppTextStyles(context).routeDetailsTransitTextStyle)
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      controller.userRole.value == UserRole.MERCHANDISER.name
                          ? Container(
                              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgs/user.svg",
                                          height: MediaQuery.of(context).size.width * 0.04,
                                          color: AppColors.black,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.005,
                                        ),
                                        Text(controller.routeDetail.value?.driver?.name ?? "N/A",
                                            style: AppTextStyles(context).routeDetailsTransitTextStyle)
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.04,
                                  ),
                                  Flexible(
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/svgs/VIN.svg",
                                          height: MediaQuery.of(context).size.width * 0.04,
                                          color: AppColors.black,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.005,
                                        ),
                                        Text(controller.routeDetail.value?.truck?.vin ?? "N/A",
                                            style: AppTextStyles(context).routeDetailsTransitTextStyle)
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),

                      ///   22H 30M(Expected) and Icon
                      Row(children: [
                        Row(
                          children: [
                            ///   Icon
                            SvgPicture.asset(
                              "assets/svgs/time.svg",
                              height: MediaQuery.of(context).size.width * 0.04,
                              color: AppColors.black,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.005,
                            ),

                            ///   22H 30M(Expected) text
                            Text(
                                '${Utils.formatMinutes(controller.routeDetail.value?.loadedDuration ?? 0)} (${AppString.expected})',
                                style: AppTextStyles(context).routeDetailsTransitTextStyle)
                          ],
                        ),
                      ]),

                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                      ///   Bethel WHS - Arcadia, LA and Origin and Icon
                      Row(
                        children: [
                          ///   Icon
                          SvgPicture.asset(
                            "assets/svgs/location-3.svg",
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: AppColors.black,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),

                          ///   Bethel WHS - Acardia, LA text
                          Text("${AppString.routeDetailOriginPoint} :",
                              maxLines: 2, style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                          ///   Origin Point text
                          Flexible(
                            child: Text(controller.routeDetail.value?.originPoints ?? "",
                                style: AppTextStyles(context).routeDetailsTransitTextStyle),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                      ///  Home Depot 4, City, State and Last Drop-off Location
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///   Icon
                          SvgPicture.asset("assets/svgs/location-3.svg",
                              height: MediaQuery.of(context).size.width * 0.04, color: AppColors.black),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.005),

                          ///   Home Depot 4, City, State text
                          Text(AppString.lastDropOffLocation,
                              style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.02),

                          ///   Last Drop-off Location text
                          Flexible(
                              child: Text(controller.routeDetail.value?.lastDropoffLocation ?? "N/A",
                                  style: AppTextStyles(context).routeDetailsTransitTextStyle))
                        ],
                      ),
                    ],
                  ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///   Stop details List UI
  Widget expandTileStop(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: AppColors.themeWhiteColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(AppDimen.circular30), topRight: Radius.circular(AppDimen.circular30))),
              margin: const EdgeInsets.only(bottom: 10),
              child: Theme(
                data: Theme.of(context).copyWith(dividerColor: Colors.white),
                child: Card(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(width: AppDimen.width0_39, color: AppColors().green2),
                      borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular30))),
                  child: ExpansionTile(
                    onExpansionChanged: (bo) {
                      if (!bo) {
                        controller.isRouteOpen.value = true;
                        controller.isStopOpen.value = false;
                      } else {
                        controller.isRouteOpen.value = false;
                        controller.isStopOpen.value = true;
                      }
                    },
                    initiallyExpanded: true,
                    backgroundColor: Colors.white,
                    collapsedBackgroundColor: Colors.white,
                    expandedCrossAxisAlignment: CrossAxisAlignment.end,
                    title: Row(
                      mainAxisSize: MainAxisSize.min, // Change here
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(AppString.stopDetailStopDetails,
                            textAlign: TextAlign.left, style: AppTextStyles(context).routeDetailsAndStopDetails),
                        (controller.userRole.value == UserRole.MERCHANDISER.name) ||
                                (controller.subDriver == "yes") ||
                                (controller.routeDetail.value?.lockStatus == 1)
                            ? const SizedBox().marginZero
                            : Visibility(
                                visible:
                                    controller.routeDetail.value?.driver?.driverDetail?.resequencingShipmentsAllowed ==
                                            1 &&
                                        controller.copyShipmentListResequence.length != 1 &&
                                        controller.copyShipmentListResequence.isNotEmpty,
                                child: InkWell(
                                  onTap: () async {
                                    ///here we will call method to get eta with here map

                                    // controller.getETA(
                                    //     controller.copyShipmentListResequence,
                                    //     controller.routeDetail.value?.id);
                                    bool result = await Get.toNamed(Routes.RE_SEQUENCE_SHIPMENTS);
                                    if (result == true) {
                                      controller.canChangeOrgList.value = true;
                                      controller.isShipmentReOrdered.value = false;
                                      controller.getRouteDetails();
                                    }
                                  },
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.035,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(context).size.width * 0.001,
                                        bottom: MediaQuery.of(context).size.width * 0.001,
                                        left: MediaQuery.of(context).size.width * 0.025,
                                        right: MediaQuery.of(context).size.width * 0.025),
                                    decoration: BoxDecoration(
                                        color: AppColors().yellow1,
                                        border: Border.all(color: Colors.black87),
                                        borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular8))),
                                    child: Text(
                                      AppString.reSequenceShipments,
                                      style: AppTextStyles(context).bold4TextStyle(
                                        fontSize: MediaQuery.of(context).size.height * 0.017,
                                        textColor: AppColors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.themeWhiteColor,
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min, // Change here
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: controller.stepperData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final stepData = controller.stepperData[index];
                                  GlobalKey keyindex = GlobalKey();
                                  WidgetsBinding.instance.addPostFrameCallback(
                                    (timeStamp) {
                                      var hieght = _getHeight(keyindex);
                                      controller.hightItemView.value = hieght;
                                      controller.hightItemView.refresh();
                                      controller.update();
                                    },
                                  );

                                  return Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    // color: AppColors.yellow, //(index==3) ? AppColors.yellow : AppColors.black,
                                    child: Row(
                                      children: [
                                        /// Line
                                        /// const SizedBox(width: 10.0),
                                        /// Line
                                        Column(
                                          children: [
                                            Visibility(
                                                visible: index == 0,
                                                child: wareHouse(
                                                    isFirst: index == 0,
                                                    isSelected: (controller.userRole.value == UserRole.LOADER.name)
                                                        ? false
                                                        : true)),
                                            // Line
                                            line1(index, context,
                                                isSelected: (controller.stepperData[index].content['deliveryStatus'] ==
                                                        DELIVERED ||
                                                    controller.stepperData[index].content['deliveryStatus'] ==
                                                        UNDELIVERED ||
                                                    controller.stepperData[index].content['deliveryStatus'] ==
                                                        CANCELED),
                                                isFirst: index == 0,
                                                stopId: controller.stepperData[index].content['id'],
                                                rightGlobalkey: keyindex),
                                            // Avatar
                                            avatar(
                                                isSelected: (controller.stepperData[index].content['deliveryStatus'] ==
                                                        DELIVERED ||
                                                    controller.stepperData[index].content['deliveryStatus'] ==
                                                        UNDELIVERED ||
                                                    controller.stepperData[index].content['deliveryStatus'] ==
                                                        CANCELED),
                                                count: index + 1),
                                            // Line
                                            line1(index, context,
                                                isSelected: index < controller.stepperData.length - 1 &&
                                                        (controller.stepperData[index + 1].content['deliveryStatus'] ==
                                                                DELIVERED ||
                                                            controller
                                                                    .stepperData[index + 1].content['deliveryStatus'] ==
                                                                UNDELIVERED ||
                                                            controller
                                                                    .stepperData[index + 1].content['deliveryStatus'] ==
                                                                CANCELED) ||
                                                    (index == controller.stepperData.length - 1 &&
                                                        (controller.stepperData[index].content['deliveryStatus'] ==
                                                                DELIVERED ||
                                                            controller.stepperData[index].content['deliveryStatus'] ==
                                                                UNDELIVERED ||
                                                            controller.stepperData[index].content['deliveryStatus'] ==
                                                                CANCELED)),
                                                isFirst: index == 0,
                                                stopId: controller.stepperData[index].content['id'],
                                                rightGlobalkey: keyindex),

                                            Visibility(
                                              visible: index == (controller.stepperData.length - 1),
                                              child: wareHouse(
                                                isSelected: (index == controller.stepperData.length - 1 &&
                                                    (controller.routeDetail.value?.status?.toLowerCase() == COMPLETED)),
                                                isFirst: false,
                                              ),
                                            ),

                                            const SizedBox(width: 10.0),
                                          ],
                                        ),
                                        const SizedBox(width: 5.0),
                                        Column(
                                          key: keyindex,
                                          children: [
                                            Visibility(
                                                visible: index == 0,
                                                replacement: const SizedBox().marginZero,
                                                child: wareHouseName(context)),
                                            stepperDetailContainer(
                                                stepData, context, int.parse(stepData.id.toString())),
                                            // SizedBox(height: MediaQuery.of(context).size.width * 0.05,),
                                            Visibility(
                                                visible: index == controller.stepperData.length - 1,
                                                replacement: const SizedBox().marginZero,
                                                child: wareHouseName(context)),
                                            // SizedBox(height: MediaQuery.of(context).size.width * 0.02,),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 10.0)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget wareHouse({required bool isSelected, required bool isFirst}) {
    return Container(
        width: 30,
        height: 30,
        margin: (isFirst) ? const EdgeInsets.only(top: 20) : const EdgeInsets.only(bottom: 20),
        decoration:
            BoxDecoration(color: isSelected ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(16.0)),
        child: Center(
            child: Icon(
          Icons.account_balance_rounded,
          color: isSelected ? Colors.white : Colors.black,
          size: 20.0,
        )));
  }

  Widget avatar({required bool isSelected, required int count}) {
    return Container(
      width: 30,
      height: 30,
      // margin: const EdgeInsets.only(right: 8),
      decoration:
          BoxDecoration(color: isSelected ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(16.0)),
      child: Center(
          child: Text("$count",
              style: TextStyle(color: (isSelected) ? Colors.white : Colors.black, fontWeight: FontWeight.w900))),
    );
  }

  Widget line1(int index, BuildContext context,
      {required bool isSelected, required bool isFirst, required stopId, required rightGlobalkey}) {
    return Obx(() => Container(
        width: 10,
        height: (controller.hightItemView.value / 2.45),

        // padding: const EdgeInsets.only(top: 20.0),
        decoration:
            BoxDecoration(color: (isSelected) ? Colors.green : Colors.grey, borderRadius: BorderRadius.circular(0.0))));
  }

  double _getHeight(GlobalKey key) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      return renderObject.size.height;
    }
    return 0.0; // Or handle the case where it's not a RenderBox
  }

  Widget wareHouseName(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.71,
      // height: MediaQuery.of(context).size.height * 0.168,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.width * 0.03,
          bottom: MediaQuery.of(context).size.width * 0.015,
          left: MediaQuery.of(context).size.width * 0.02,
          right: MediaQuery.of(context).size.width * 0.02),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 0.01, top: MediaQuery.of(context).size.width * 0.01),
      decoration: BoxDecoration(
          color: AppColors().green5,
          border: Border.all(color: AppColors().green1, width: AppDimen.width1),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(AppDimen.circular15),
              topLeft: Radius.circular(AppDimen.circular15),
              bottomRight: Radius.circular(AppDimen.circular15))),
      child: Text(controller.routeDetail.value?.shipmentDeliveries?[0].shipment?.warehouse?.name ?? "N/A"),
    );
  }

  /// Stepper Detail Custom Container
  Widget stepperDetailContainer(StepperItemData data, BuildContext context, int stepperID) {
    final accountController = Get.put(AccountController());
    bool isMerchandiserLocation = accountController.customerLocationList.any((element) =>
        element.deliveryLocationName ==
        data.content['shipment']['shipment_customer_delivery_locations']['delivery_location_name']);
    List<PropsNotes>? notesList = data.content['noteByDriver'];

    int eta = data.content['eta'];
    String formattedUpdatedTime;
    String dateAndTime;
    if (data.content['deliveryStatus'] == IN_TRANSIT_DELAY || data.content['deliveryStatus'] == IN_TRANSIT_ON_TIME) {
      String pdt = DateFormat('hh:mm a').format(DateTime.now());
      // Parse the start time
      DateTime parsedStartTime = DateFormat('h:mm a').parse(pdt);

      String pdtDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
      // Parse the start time
      DateTime parsedStartTimeNow = DateFormat('yyyy-MM-dd HH:mm:ss').parse(pdtDateTime);

      // Add 136 minutes
      DateTime updatedTime = parsedStartTime.add(Duration(minutes: eta));

      // Add 136 minutes
      DateTime updatedTimeNow = parsedStartTimeNow.add(Duration(minutes: eta));

      // Format the result with AM/PM
      formattedUpdatedTime = DateFormat('h:mm a').format(updatedTime);
      dateAndTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedTimeNow.toLocal());
    } else {
      String pdt = DateFormat('hh:mm a').format(controller.routeDetail.value?.plannedDepartureTime ?? DateTime.now());
      // Parse the start time
      DateTime parsedStartTime = DateFormat('h:mm a').parse(pdt);

      String pdtDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(controller.routeDetail.value?.plannedDepartureTime ?? DateTime.now());
      // Parse the start time
      DateTime parsedStartTimeNow = DateFormat('yyyy-MM-dd HH:mm:ss').parse(pdtDateTime);

      // Add 136 minutes
      DateTime updatedTime = parsedStartTime.add(Duration(minutes: eta));

      // Add 136 minutes
      DateTime updatedTimeNow = parsedStartTimeNow.add(Duration(minutes: eta));

      // Format the result with AM/PM
      formattedUpdatedTime = DateFormat('h:mm a').format(updatedTime);
      dateAndTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(updatedTimeNow.toLocal());
    }

    if (data.content['deliveredAt'] != null) {
      controller.isWithinDeliveredWindow.value = controller.isArrivedTimeWithinDeliveryWindow(
          data.content['deliveredAt']?.toIso8601String() ?? "",
          data.content['shipment']['props_delivery_window']['start'],
          data.content['shipment']['props_delivery_window']['end']);
    }
    if (data.content['undeliveredAt'] != null) {
      controller.isWithinUndeliveredWindow.value = controller.isArrivedTimeWithinDeliveryWindow(
          data.content['undeliveredAt']?.toIso8601String() ?? "",
          data.content['shipment']['props_delivery_window']['start'],
          data.content['shipment']['props_delivery_window']['end']);
    }

    if (data.content['arrivedAt'] != null) {
      controller.isWithinArrivedWindow.value = controller.isArrivedTimeWithinDeliveryWindow(
          data.content['arrivedAt']?.toIso8601String() ?? "",
          data.content['shipment']['props_delivery_window']['start'],
          data.content['shipment']['props_delivery_window']['end']);
    }
    if (data.content['arrivedAt'] == null) {
      controller.isWithinArrivedWindow.value = controller.isArrivedTimeWithinDeliveryWindow(
          dateAndTime,
          data.content['shipment']['props_delivery_window']['start'],
          data.content['shipment']['props_delivery_window']['end']);
    }
    return InkWell(
      onTap: () async {
        if (controller.userRole.value == UserRole.MERCHANDISER.name) {
        } else {
          var shipmentID = '${data.content['id']}';
          final stopDetailController = Get.put(StopDetailsController());
          stopDetailController.stopId = int.tryParse(shipmentID);
          stopDetailController.update();
          stopDetailController.getStopDetails();
          // controller.socketService?.onTriggerEventPressed();
          var result = await Get.toNamed(Routes.STOP_ROUTE_DETAIL);
          if (result == true) {
            controller.routeId = controller.routeDetail.value?.id ?? 0;
            controller.getRouteDetails();
            controller.update();
          }
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.71,
        // height: MediaQuery.of(context).size.height * 0.23,
        child: ListTile(
          contentPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
          visualDensity: const VisualDensity(),
          subtitle: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width * 0.02,
                left: MediaQuery.of(context).size.width * 0.02,
                right: MediaQuery.of(context).size.width * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.02),
            decoration: BoxDecoration(
                color: data.content['deliveryStatus'] == DELIVERED
                    ? AppColors().green5
                    : (data.content['deliveryStatus'] == UNDELIVERED || data.content['deliveryStatus'] == CANCELED)
                        ? AppColors().red5
                        : controller.userRole.value == UserRole.MERCHANDISER.name
                            ? isMerchandiserLocation
                                ? AppColors.themeWhiteColor
                                : AppColors().gray5
                            : AppColors.themeWhiteColor,
                border: Border.all(color: AppColors().green2, width: AppDimen.width1),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppDimen.circular15),
                    bottomLeft: Radius.circular(AppDimen.circular15),
                    bottomRight: Radius.circular(AppDimen.circular15))),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///   SOO113  and Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ///   SOO113 Text and Icon
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Visibility(
                                    visible: false,
                                    child: SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.04,
                                        height: MediaQuery.of(context).size.width * 0.07,
                                        child: Checkbox(
                                            value: data.content['loading_complete'] == 0 ? false : true,
                                            // Use your actual value
                                            onChanged: (newValue) {
                                              controller.update();
                                            },
                                            checkColor: AppColors.greenIconColor,
                                            activeColor: AppColors.themeCompleteDeliveryContainerBackGroundColor,
                                            hoverColor: AppColors.greenIconColor,
                                            focusColor: AppColors.greenIconColor))),

                                ///   For Gap
                                // SizedBox(width: MediaQuery.of(context).size.width * 0.02), // Add some spacing
                                Flexible(
                                  child: Text('${data.content['shipment']['name'] ?? ""}',
                                      style: AppTextStyles(context).stopDetailSoo113TextStyle.copyWith(fontSize: 15)),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (controller.userRole.value == UserRole.MERCHANDISER.name) {
                                      if (isMerchandiserLocation) {
                                        if (notesList?.isEmpty ?? false) {
                                        } else {
                                          showModalBottomSheet<void>(
                                              context: context,
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(AppDimen.circular20),
                                                      topRight: Radius.circular(AppDimen.circular20))),
                                              builder: (context) {
                                                return SizedBox(
                                                  height: 900,
                                                  width: MediaQuery.of(context).size.width,
                                                  child: NotesModalBottomSheet(notesList: notesList),
                                                );
                                              });
                                        }
                                      }
                                    } else {
                                      if (notesList?.isEmpty ?? false) {
                                      } else {
                                        showModalBottomSheet<void>(
                                            context: context,
                                            backgroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(AppDimen.circular20),
                                                    topRight: Radius.circular(AppDimen.circular20))),
                                            builder: (context) {
                                              return Container(
                                                height: 900,
                                                width: MediaQuery.of(context).size.width,
                                                child: NotesModalBottomSheet(notesList: notesList),
                                              );
                                            });
                                      }
                                    }
                                  },
                                  child: controller.userRole.value == UserRole.MERCHANDISER.name
                                      ? isMerchandiserLocation
                                          ? SvgPicture.asset("assets/icons/document-bold.svg",
                                              height: MediaQuery.of(context).size.width * 0.06,
                                              color: (notesList)?.isEmpty ?? false
                                                  ? AppColors().gray1
                                                  : AppColors().green1)
                                          : SvgPicture.asset("assets/icons/document-bold.svg",
                                              height: MediaQuery.of(context).size.width * 0.06,
                                              color: AppColors().gray1)
                                      : SvgPicture.asset("assets/icons/document-bold.svg",
                                          height: MediaQuery.of(context).size.width * 0.06,
                                          color:
                                              (notesList)?.isEmpty ?? false ? AppColors().gray1 : AppColors().green1),
                                ),

                                /// Call Button
                                (controller.userRole.value == UserRole.MERCHANDISER.name)
                                    ? (isMerchandiserLocation)
                                        ? data.content['shipment']['shipment_customer_delivery_locations']
                                                    ['delivery_contact_phone'] ==
                                                null
                                            ? Container(height: 0)
                                            : GestureDetector(
                                                onTap: () {
                                                  Utils().makePhoneCall(
                                                      '${data.content['shipment']['shipment_customer_delivery_locations']['delivery_contact_phone'] ?? "N/A"}');
                                                },
                                                child: Container(
                                                    margin: const EdgeInsets.only(left: 5),
                                                    padding: const EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        color: AppColors.greenIconColor,
                                                        borderRadius: BorderRadius.circular(AppDimen.circular50)),
                                                    child: SvgPicture.asset(
                                                      "assets/svgs/call.svg",
                                                      width: MediaQuery.of(context).size.width * 0.05,
                                                    )),
                                              )
                                        : data.content['shipment']['shipment_customer_delivery_locations']
                                                    ['delivery_contact_phone'] ==
                                                null
                                            ? Container(height: 0)
                                            : Container(
                                                margin: const EdgeInsets.only(left: 5),
                                                padding: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                    color: AppColors().gray1,
                                                    borderRadius: BorderRadius.circular(AppDimen.circular50)),
                                                child: SvgPicture.asset(
                                                  "assets/svgs/call.svg",
                                                  width: MediaQuery.of(context).size.width * 0.04,
                                                ))
                                    : Container(),
                                data.content['fork_lift'] == 0
                                    ? Container()
                                    : Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: SvgPicture.asset(
                                          "assets/svgs/forklift.svg",
                                          height: MediaQuery.of(context).size.width * 0.06,
                                          color: AppColors.blackIconColor,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ///   In Transit (On-Time)
                      controller.userRole.value == UserRole.MERCHANDISER.name
                          ? Flexible(
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                                margin: const EdgeInsets.only(left: 5),
                                decoration: BoxDecoration(
                                    color: Utils().bgForStatus(
                                        isPickUpOrder: false, data.content['deliveryStatus'].toString() ?? ""),
                                    borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular7))),
                                child: Text(data.content['deliveryStatus'].toString().capitalize ?? "",
                                    style: AppTextStyles(context).routeInTransitTextStyle.copyWith(
                                        color: Utils().bgIsYellow(data.content['deliveryStatus'] ?? "")
                                            ? AppColors.black
                                            : AppColors.white)),
                              ),
                            )
                          : SizedBox().marginZero,
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  // SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  controller.userRole.value != UserRole.LOADER.name
                      ? Container(
                          margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/svgs/user.svg",
                                height: MediaQuery.of(context).size.width * 0.04,
                                color: AppColors.darkGreyIconColor,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.01,
                              ),
                              Flexible(
                                child: Text(
                                    '${data.content['shipment']['shipment_customer_delivery_locations']['delivery_location_name'] ?? "N/A"}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle),
                              ),
                            ],
                          ),
                        )
                      : Container(),

                  ///   Home Depot 1, main Street, Tampa, FI and Icons
                  Row(
                    children: [
                      SvgPicture.asset(
                        "assets/svgs/location-3.svg",
                        height: MediaQuery.of(context).size.width * 0.04,
                        color: AppColors.darkGreyIconColor,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Flexible(
                        child: Text(
                            '${data.content['shipment']['shipment_customer_delivery_locations']['delivery_location_address_line_1'] ?? ""}'
                            ', ${data.content['shipment']['shipment_customer_delivery_locations']['delivery_location_city'] ?? ""}'
                            ', ${data.content['shipment']['shipment_customer_delivery_locations']['delivery_location_state'] ?? ""}'
                            ', ${data.content['shipment']['shipment_customer_delivery_locations']['delivery_location_zipcode'] ?? ""}',
                            softWrap: true,
                            style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle),
                      ),
                    ],
                  ),

                  ///   +8897453210, P:30 R:50 T:30, ETA 5:20 PM and Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///   P:30 R:50 T:30 & Icon
                      Container(
                        padding: EdgeInsets.only(
                            right: MediaQuery.of(context).size.width * 0.01,
                            top: MediaQuery.of(context).size.width * 0.01,
                            bottom: MediaQuery.of(context).size.width * 0.01),
                        child: Row(
                          children: [
                            SvgPicture.asset(AppAssets.scaleIcon,
                                height: MediaQuery.of(context).size.width * 0.037, color: AppColors.darkGreyIconColor),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.008),
                            Text(
                              "P:${data.content['pQuantity'] ?? "0"} R:${data.content['rQuantity'] ?? "0"} T:${data.content['tQuantity'] ?? "0"}",
                              style: AppTextStyles(context).bold3TextStyle(
                                  textColor: AppColors().gray2, fontSize: MediaQuery.of(context).size.width * 0.028),
                            ),
                            GestureDetector(
                              onTap: () {
                                if (controller.userRole.value == UserRole.MERCHANDISER.name) {
                                  if (isMerchandiserLocation) {
                                    controller.getShipmentInventory(data.content['shipmentId'] ?? 0).then((value) {
                                      showDialog(
                                          context: context,
                                          builder: (context) => QuantityPopUp(
                                                inventoryData: controller.inventoryList,
                                                isRoutePopUp: false,
                                              ));
                                    });
                                  }
                                } else {
                                  controller.getShipmentInventory(data.content['shipmentId'] ?? 0).then((value) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => QuantityPopUp(
                                            inventoryData: controller.inventoryList, isRoutePopUp: false));
                                  });
                                }
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(left: 2),
                                  decoration: BoxDecoration(
                                      color: controller.userRole.value == UserRole.MERCHANDISER.name
                                          ? (isMerchandiserLocation)
                                              ? AppColors.themeRed1
                                              : AppColors().gray1
                                          : AppColors.themeRed1,
                                      borderRadius: BorderRadius.circular(AppDimen.circular50)),
                                  child: Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: AppColors.white,
                                    size: MediaQuery.of(context).size.width * 0.05,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),

                      ///   ETA 5:20pm and Icon
                      (data.content['deliveryStatus'] != UNDELIVERED && data.content['deliveryStatus'] != CANCELED)
                          ? Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.timeIcon,
                                  height: MediaQuery.of(context).size.width * 0.037,
                                  color: AppColors().gray2,
                                ),
                                Text(
                                  " ETA :",
                                  style: AppTextStyles(context).bold3TextStyle(
                                      textColor: AppColors().gray2,
                                      fontSize: MediaQuery.of(context).size.width * 0.028),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.01,
                                ),
                                Text(
                                  data.content['arrivedAt'] != null
                                      ? Utils.convertUtcToLocal(data.content['arrivedAt'].toString())
                                      : formattedUpdatedTime,
                                  style: data.content['deliveryStatus'] == LOADED
                                      ? AppTextStyles(context).bold3TextStyle(
                                          textColor: AppColors().gray2,
                                          fontSize: MediaQuery.of(context).size.width * 0.028)
                                      : controller.isWithinArrivedWindow.value
                                          ? AppTextStyles(context).completeDeliveryArrivedAtTextStyle
                                          : AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                                ),
                              ],
                            )
                          : Container(),
                    ],
                  ),

                  ///   06/29/2023 (4:00pm-6:00pm) and Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          ///   Icon
                          SvgPicture.asset(
                            "assets/icons/sharp-calendar-month.svg",
                            height: MediaQuery.of(context).size.width * 0.04,
                            color: AppColors.darkGreyIconColor,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.005,
                          ),

                          ///   22H 30M(Expected) text
                          SizedBox(
                            width: controller.isInProgress(stopId: data.content['shipment']['id'])
                                ? null
                                : MediaQuery.of(context).size.width * 0.35,
                            child: Text(
                                '${Utils.convertDateFormatDDMMYYYY(data.content['delivery_date'].split(' ')[0] ?? "")}'
                                ' (${Utils.formatUtcDateTime(data.content['shipment']['props_delivery_window']['start'] ?? "").split(' ')[1]}'
                                ' ${Utils.formatUtcDateTime(data.content['shipment']['props_delivery_window']['start'] ?? "").split(' ')[2]}'
                                ' - ${Utils.formatUtcDateTime(data.content['shipment']['props_delivery_window']['end'] ?? "").split(' ')[1]}'
                                ' ${Utils.formatUtcDateTime(data.content['shipment']['props_delivery_window']['end'] ?? "").split(' ')[2]})',
                                maxLines: controller.isInProgress(stopId: data.content['shipment']['id']) ? 1 : 2,
                                style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle),
                          ),
                        ],
                      ),
                      controller.userRole.value == UserRole.MERCHANDISER.name
                          ? (isMerchandiserLocation)
                              ? const SizedBox().marginZero
                              : Icon(Icons.lock,
                                  color: AppColors().gray1, size: MediaQuery.of(context).size.width * 0.05)
                          : const SizedBox().marginZero
                    ],
                  ),

                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.005,
                  ),

                  ///   06/29/2023 (4:00pm-6:00pm) and Icon

                  if (data.content['undeliveredAt'] != null) ...{
                    Row(
                      children: [
                        Text(
                          "${AppString.undeliveredAt}: ${Utils.convertUtcToLocal(data.content['undeliveredAt'].toString())}",
                          textAlign: TextAlign.left,
                          style: controller.isWithinUndeliveredWindow.value
                              ? AppTextStyles(context).completeDeliveryArrivedAtTextStyle
                              : AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                        ),
                      ],
                    )
                  },

                  if (data.content['deliveredAt'] != null) ...{
                    Row(
                      children: [
                        Text(
                          "${AppString.deliveredAt}: ${Utils.convertUtcToLocal(data.content['deliveredAt'].toString())}",
                          textAlign: TextAlign.left,
                          style: controller.isWithinUndeliveredWindow.value
                              ? AppTextStyles(context).completeDeliveryArrivedAtTextStyle
                              : AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                        ),
                      ],
                    )
                  },
                  ((controller.userRole.value != UserRole.MERCHANDISER.name && controller.subDriver != "yes") &&
                          controller.isInProgress(stopId: data.content['shipment']['id']))
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                /// Icon
                                InkWell(
                                  onTap: () {
                                    controller.routeDetail.value?.status = IN_TRANSIT_ARRIVED;
                                    controller.update();
                                    controller.completeDeliveryAction(data.content['id'].toString());
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svgs/check.svg",
                                    height: MediaQuery.of(context).size.width * 0.08,
                                  ),
                                ),

                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.005,
                                ),

                                SizedBox(
                                  child: Text(
                                    AppString.aRRIVED,
                                    maxLines: 2,
                                    style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle,
                                  ),
                                ),
                              ],
                            ),

                            /// ETA 5:20pm and Icon
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    cancelDelivery(context, data.content['id'], data.content['shipment']['name']);
                                  },
                                  child: SvgPicture.asset(
                                    "assets/svgs/cross.svg",
                                    height: MediaQuery.of(context).size.width * 0.08,
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.005,
                                ),
                                SizedBox(
                                  child: Text(
                                    AppString.uNDELIVERED,
                                    maxLines: 2,
                                    style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Utils().makePhoneCall(
                                        '$countryCode${data.content['shipment']['shipment_customer_delivery_locations']['delivery_contact_phone']}');
                                  },
                                  child: SvgPicture.asset(
                                    "assets/icons/whatsapp-fill.svg",
                                    height: MediaQuery.of(context).size.width * 0.08,
                                    color: AppColors.greenIconColor,
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context).size.width * 0.005,
                                ),
                                SizedBox(
                                  child: Text(
                                    AppString.cALL,
                                    maxLines: 2,
                                    style: AppTextStyles(context).routeDetailsOriginGreyColorTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox().marginZero,
                  //
                  // SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                  ///   Undelivered, 06/29/2023, Note and Icons
                  if (data.content['canceledAt'] != null) ...{
                    Row(
                      children: [
                        Text(
                          "${AppString.cancelledAt}: ${Utils.convertUtcToLocal(data.content['canceledAt'].toString())}",
                          textAlign: TextAlign.left,
                          style: AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                        ),
                      ],
                    )
                  },
                ],
              ),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(AppDimen.circular15),
                bottomLeft: Radius.circular(AppDimen.circular15),
                bottomRight: Radius.circular(AppDimen.circular15)),
          ),
        ),
      ),
    );
  }

  // @override
  // PreferredSizeWidget? appBar(BuildContext context) {
  //   return null;
  // }

  Widget buildRouteDetails(BuildContext context) {
    return controller.userRole.value == UserRole.MERCHANDISER.name
        ? expandTileRoute(context)
        : (controller.routeDetail.value?.id == null) ||
                (controller.routeDetail.value?.status?.toLowerCase() != LOADED &&
                    controller.routeDetail.value?.status?.toLowerCase() != IN_TRANSIT_ON_TIME &&
                    controller.routeDetail.value?.status?.toLowerCase() != IN_TRANSIT_DELAY &&
                    controller.routeDetail.value?.status?.toLowerCase() != IN_TRANSIT_ARRIVED &&
                    controller.routeDetail.value?.status?.toLowerCase() != DELIVERED &&
                    controller.routeDetail.value?.status?.toLowerCase() != COMPLETED)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.16,
                alignment: Alignment.center,
                child: Text(AppString.noRouteFound, style: AppTextStyles(context).routeNoTextStyle),
              )
            : expandTileRoute(context);
  }

  Widget buildStopDetails(BuildContext context) {
    return controller.userRole.value == UserRole.MERCHANDISER.name
        ? expandTileStop(context)
        : (controller.routeDetail.value?.id == null) ||
                (controller.routeDetail.value?.status?.toLowerCase() != LOADED &&
                    controller.routeDetail.value?.status?.toLowerCase() != IN_TRANSIT_ON_TIME &&
                    controller.routeDetail.value?.status?.toLowerCase() != IN_TRANSIT_DELAY &&
                    controller.routeDetail.value?.status?.toLowerCase() != IN_TRANSIT_ARRIVED &&
                    controller.routeDetail.value?.status?.toLowerCase() != DELIVERED &&
                    controller.routeDetail.value?.status?.toLowerCase() != COMPLETED)
            ? const SizedBox()
            : expandTileStop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRouteDetails(context),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        buildStopDetails(context),
      ],
    );
  }

  Widget lineAvatarSize(BuildContext context, {required bool isSelected, required bool isFirst}) {
    // return SizedBox();
    return Container(
      width: 10,
      height: MediaQuery.of(context).size.height * 0.03,
      decoration: BoxDecoration(
        color: (isSelected) ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.circular(0.0),
      ),
    );
  }

  void cancelDelivery(BuildContext context, int id, String name) {
    showDialog(
        context: context,
        builder: (context) {
          return Theme(
            data: Theme.of(context).copyWith(dialogBackgroundColor: Colors.white),
            child: AlertDialog(
                content: Container(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.height * 0.65,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.023),
                color: Colors.white,
              ),
              child: Column(children: [
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.024),
                  child: Text(
                    "${AppString.markUndeliveredShipment} $name",
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.018),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.03,
                    left: MediaQuery.of(context).size.height * 0.03,
                    right: MediaQuery.of(context).size.height * 0.03,
                  ),
                  child: TextFormField(
                    autofocus: true,
                    autocorrect: false,
                    keyboardType: TextInputType.multiline,
                    controller: controller.notesTextEditingController.value,

                    // minLines: 1,
                    maxLines: 6,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[300],
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.01)),
                        borderSide: BorderSide(width: MediaQuery.of(context).size.height * 0.001, color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.01)),
                        borderSide: BorderSide(width: MediaQuery.of(context).size.height * 0.001, color: Colors.grey),
                      ),
                      contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    controller.cancelDeliveryAction(id.toString(), controller.notesTextEditingController.value.text,
                        controller.routeDetail.value?.id ?? 0);
                    Get.back();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(MediaQuery.of(context).size.height * 0.05),
                        border: Border.all(
                          color: Colors.green,
                          width: MediaQuery.of(context).size.height * 0.001,
                        )),
                    // color:Colors.yellow,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.034,
                        left: MediaQuery.of(context).size.height * 0.08,
                        right: MediaQuery.of(context).size.height * 0.08),
                    child: Text(AppString.save, style: AppTextStyles(context).notesSaveButtonStyle),
                  ),
                )
              ]),
            )),
          );
        });
  }
}
