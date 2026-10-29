/// This file defines the `CompleteDelivery` class, which is responsible for managing
/// the UI and functionality related to completing a delivery in the driver module.
/// It includes features such as displaying delivery details, handling delivery actions,
/// capturing proof of delivery (camera, signature, notes), and interacting with maps.

import 'dart:io';

import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/modules/dashboard/route/route_detail_controller.dart';
import 'package:bethel_farm/app/controllers/driver_module_controller/stop_details_ctrl.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/route_details_ctrl.dart';
import 'package:bethel_farm/modules/loader/pickup_order_detail/view/quantity_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hand_signature/signature.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../../../base/base_view.dart';
import '../../../../../core/app_assets/app_assets.dart';
import '../../../../../core/app_dimens/app_dimens.dart';
import '../../../../../core/app_string/app_strings.dart';
import 'package:dotted_border/dotted_border.dart';

import '../../../../../utils/exports.dart';
import '../../../../data/enums/user_role.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/utils.dart';

HandSignatureControl control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);

class CompleteDelivery extends BaseView<StopDetailsController> {
  final stopDetailController = Get.put(StopDetailsController());
  final routeDetailController = Get.put(RouteDetailController());

  /// Base AppBar
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  bool _onBackPressed() {
    controller.stopTimer();
    return true;
  }

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return _onBackPressed();
        },
        child: Scaffold(
            backgroundColor: AppColors.themeWhiteColor,
            body: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              //margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.08),
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.height * 0.02,
                right: MediaQuery.of(context).size.height * 0.02,
              ),
              child: Column(
                children: [
                  ///   Route Details and Icons
                  routeDetailWithIcons(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Obx(
                        () => (stopDetailController.responseData.value!.data == null)
                            ? const SizedBox()
                            : Container(
                                // height: MediaQuery.of(context).size.height*0.99,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.height * 0.003,
                                    right: MediaQuery.of(context).size.height * 0.003),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// For Gap
                                    SizedBox(height: MediaQuery.of(context).size.height * 0.016),

                                    ///   Mark Complete For Stop No.3
                                    Text(
                                        '${AppString.completeDeliveryMarkCompleteForStop} '
                                        '${stopDetailController.responseData.value?.data?.routeNo}',
                                        textAlign: TextAlign.left,
                                        style: AppTextStyles(context).markCompleteAndDeliveryRequirementsTextStyle),

                                    SizedBox(height: MediaQuery.of(context).size.height * 0.004),

                                    ///   Collect Proof of Deliver
                                    GestureDetector(
                                      onTap: () {
                                        //setState(() {
                                        print(">>>Collect Proof of Deliver<<<");

                                        /// Collect Proof of Deliver for driver only..
                                        // openNotePad();
                                        // openSignaturePad(context);
                                        //  openCamera();
                                        // });
                                      },
                                      child: Text(AppString.completeDeliveryCollectProofOfDelivery,
                                          textAlign: TextAlign.left,
                                          style: AppTextStyles(context).collectProofOfDelivery),
                                    ),

                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.016,
                                    ),

                                    ///   Used for SOO115 and Container
                                    soo115Container(context),

                                    SizedBox(height: MediaQuery.of(context).size.height * 0.022),

                                    ///   Delivery Requirements
                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : Text(AppString.completeDeliveryDeliveryRequirements,
                                            style: AppTextStyles(context).markCompleteAndDeliveryRequirementsTextStyle),

                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : SizedBox(height: MediaQuery.of(context).size.height * 0.005),

                                    ///   0 of 3 Completed
                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : Text(
                                            '${controller.count.toString()}${AppString.completeDelivery0Of3Completed}',
                                            style: AppTextStyles(context).completeDeliveryOriginGreyColorTextStyle),

                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                                    ///   Used for Camera, Signature and Notes icons
                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : cameraSignatureNotesIcons(context),

                                    ///   Check box, Mark Current Point for Future Deliveries at this

                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : controller.responseData.value?.data?.deliveryStatus == DELIVERED ||
                                                controller.responseData.value?.data?.deliveryStatus == UNDELIVERED ||
                                                controller.responseData.value?.data?.deliveryStatus == CANCELED
                                            ? CheckboxListTile(
                                                title: Text(
                                                    AppString
                                                        .completeDeliveryMarkCurrentPointForFutureDeliveriesAtThisCustomerLocation,
                                                    style: AppTextStyles(context).completeDeliveryCommonTextStyle),
                                                value:
                                                    (controller.responseData.value?.data?.shipment?.fhfNotes?.isEmpty ??
                                                            false)
                                                        ? false
                                                        : true,
                                                onChanged: (newValue) {},
                                                controlAffinity: ListTileControlAffinity.leading,
                                                checkColor: AppColors.greenIconColor,
                                                activeColor: AppColors.themeCompleteDeliveryContainerBackGroundColor)
                                            : CheckboxListTile(
                                                title: Text(
                                                    AppString
                                                        .completeDeliveryMarkCurrentPointForFutureDeliveriesAtThisCustomerLocation,
                                                    style: AppTextStyles(context).completeDeliveryCommonTextStyle),
                                                value: stopDetailController.markCurrentPoint.value,
                                                onChanged: (newValue) {
                                                  stopDetailController.markCurrentPoint.value = newValue!;
                                                  if (newValue) {
                                                    // stopDetailController
                                                    //     .displayCurrentLocation();
                                                    _openMapAndFhfNotes(context);
                                                  }
                                                },
                                                controlAffinity: ListTileControlAffinity.leading,
                                                checkColor: AppColors.greenIconColor,
                                                activeColor: AppColors.themeCompleteDeliveryContainerBackGroundColor),

                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                                    ///   Complete Delivery Button
                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () {
                                                if (controller.responseData.value?.data?.deliveryStatus == DELIVERED ||
                                                    controller.responseData.value?.data?.deliveryStatus ==
                                                        UNDELIVERED ||
                                                    controller.responseData.value?.data?.deliveryStatus == CANCELED ||
                                                    controller.responseData.value?.data?.arrivedAt == null) {
                                                  return;
                                                } else {
                                                  if (Get.put(RouteDetailController()).isInProgress(
                                                      stopId: controller.responseData.value?.data?.shipmentId ?? -1)) {
                                                    if (controller.responseData.value?.data?.deliveryStatus ==
                                                        DELIVERED) {
                                                      Utils.showErrorMessage(AppString.alreadyDelivered);
                                                    } else if (controller.responseData.value?.data?.deliveryStatus ==
                                                        UNDELIVERED) {
                                                      Utils.showErrorMessage(AppString.shipmentUndelivered);
                                                    } else if (controller.signatureFound.value &&
                                                            !controller.imageFound.value ||
                                                        !controller.signatureFound.value &&
                                                            controller.imageFound.value ||
                                                        !controller.signatureFound.value &&
                                                            !controller.imageFound.value) {
                                                      Utils.showErrorMessage(AppString.photoAndSignAreMandatory);
                                                    } else {
                                                      controller.imageType.value = "";
                                                      controller.image?.value = File("");
                                                      controller.rawImage.value.value = null;
                                                      controller.svg.value.value = null;
                                                      controller.rawImageFit.value.value = null;
                                                      controller.notesTextEditingController.value.text = "";
                                                      controller.cancelTextEditingController.value.text = "";
                                                      controller.completeDeliveryAction(
                                                          stopDetailController.responseData.value?.data?.id
                                                                  .toString() ??
                                                              "",
                                                          "delivered_at");
                                                    }
                                                  } else {
                                                    Utils.showErrorMessage(AppString.pleaseDeliverInProgressShipment);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.55,
                                                // height: MediaQuery.of(context).size.height * 0.06,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                  color: (controller.responseData.value?.data?.deliveryStatus ==
                                                              DELIVERED ||
                                                          controller.responseData.value?.data?.deliveryStatus ==
                                                              UNDELIVERED ||
                                                          controller.responseData.value?.data?.deliveryStatus ==
                                                              CANCELED ||
                                                          controller.responseData.value?.data?.arrivedAt == null)
                                                      ? AppColors.white_1
                                                      : AppColors.themeGreen1Color,
                                                  borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10)),
                                                ),
                                                child: Text(
                                                  AppString.completeDeliveryCompleteDelivery,
                                                  style: AppTextStyles(context).completeDeliveryButtonTextStyle,
                                                ),
                                              ),
                                            ),
                                          ),

                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                                    ///   Complete Delivery Button
                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : Container(
                                            alignment: Alignment.center,
                                            child: InkWell(
                                              onTap: () {
                                                if (controller.responseData.value?.data?.deliveryStatus == DELIVERED ||
                                                    controller.responseData.value?.data?.deliveryStatus ==
                                                        UNDELIVERED ||
                                                    controller.responseData.value?.data?.deliveryStatus == CANCELED) {
                                                  null;
                                                } else {
                                                  if (controller.responseData.value?.data?.deliveryStatus ==
                                                      DELIVERED) {
                                                    Utils.showErrorMessage(AppString.alreadyDelivered);
                                                  } else if (controller.responseData.value?.data?.deliveryStatus ==
                                                      UNDELIVERED) {
                                                    Utils.showErrorMessage(AppString.shipmentUndelivered);
                                                  } else {
                                                    cancelDelivery(context);
                                                  }
                                                }
                                              },
                                              child: Container(
                                                width: MediaQuery.of(context).size.width * 0.55,
                                                // height: MediaQuery.of(context)
                                                //     .size
                                                //     .height *
                                                //     0.06,
                                                alignment: Alignment.center,
                                                padding: EdgeInsets.all(15),
                                                // left: MediaQuery.of(context)
                                                //     .size
                                                //     .width *
                                                //     0.035,
                                                // right:
                                                // MediaQuery.of(context)
                                                //     .size
                                                //     .width *
                                                //     0.035),
                                                decoration: BoxDecoration(
                                                    color: (controller.responseData.value?.data?.deliveryStatus ==
                                                                DELIVERED ||
                                                            controller.responseData.value?.data?.deliveryStatus ==
                                                                UNDELIVERED ||
                                                            controller.responseData.value?.data?.deliveryStatus ==
                                                                CANCELED)
                                                        ? AppColors.white_1
                                                        : AppColors.themeGreen1Color,
                                                    borderRadius:
                                                        BorderRadius.all(Radius.circular(AppDimen.circular10))),
                                                child: Text(AppString.cancelDeliveryCompleteDelivery,
                                                    style: AppTextStyles(context).completeDeliveryButtonTextStyle),
                                              ),
                                            ),
                                          ),
                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                                    (controller.responseData.value?.data?.deliveryStatus == LOADED ||
                                            routeDetailController.subDriver == "yes")
                                        ? Container()
                                        : Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                                AppString
                                                    .completeDeliveryPhotosAndSignatureAreMandataryToCompleteTheShipment,
                                                style: AppTextStyles(context).completeDeliveryOriginGreyColorTextStyle),
                                          ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }

  ///   Route Details and Icons
  Widget routeDetailWithIcons(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///   Back button icon and Work Dairy
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///   back icon
              InkWell(
                onTap: () {
                  controller.stopTimer();
                  Get.back();
                },
                child: Container(
                    height: MediaQuery.of(context).size.width * 0.11,
                    width: MediaQuery.of(context).size.width * 0.11,
                    padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015),
                    decoration: BoxDecoration(
                        color: AppColors().green5,
                        borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular50))),
                    child: Icon(Icons.arrow_back_ios,
                        size: MediaQuery.of(context).size.width * 0.055, color: AppColors.blackIconColor)),
              ),

              ///   For gap
              SizedBox(width: MediaQuery.of(context).size.width * 0.04),

              ///   Route Details
              Text(AppString.shipmentDetails,
                  style: AppTextStyles(context)
                      .bold4TextStyle(textColor: AppColors.black, fontSize: MediaQuery.of(context).size.width * 0.055))
            ],
          ),

          ///   Notification Icon
          InkWell(
            onTap: () {
              Get.toNamed(
                Routes.NOTIFICATION,
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.width * 0.11,
              width: MediaQuery.of(context).size.width * 0.11,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.015),
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
              child: SvgPicture.asset(
                AppAssets.bellIcon,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Used for SOO115 and Container
  Widget soo115Container(BuildContext context) {
    int eta = stopDetailController.responseData.value?.data?.duration ?? 0;
    String formattedUpdatedTime;
    String dateAndTime;
    if (stopDetailController.responseData.value?.data?.deliveryStatus == IN_TRANSIT_DELAY ||
        stopDetailController.responseData.value?.data?.deliveryStatus == IN_TRANSIT_ON_TIME) {
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
      String pdt = DateFormat('hh:mm a')
          .format(stopDetailController.responseData.value?.data?.routes?.plannedDepartureTime ?? DateTime.now());
      // Parse the start time
      DateTime parsedStartTime = DateFormat('h:mm a').parse(pdt);

      String pdtDateTime = DateFormat('yyyy-MM-dd HH:mm:ss')
          .format(stopDetailController.responseData.value?.data?.routes?.plannedDepartureTime ?? DateTime.now());
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
    if (stopDetailController.responseData.value?.data?.arrivedAt != null) {
      controller.isWithinWindow.value = controller.isArrivedTimeWithinDeliveryWindow(
          stopDetailController.responseData.value?.data?.arrivedAt?.toIso8601String() ?? "",
          stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].start ?? DateTime.now(),
          stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].end ?? DateTime.now());
    }
    if (stopDetailController.responseData.value?.data?.delivered_at != null) {
      controller.isWithinDeliveredWindow.value = controller.isArrivedTimeWithinDeliveryWindow(
          stopDetailController.responseData.value?.data?.delivered_at?.toIso8601String() ?? "",
          stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].start ?? DateTime.now(),
          stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].end ?? DateTime.now());
    }
    if (stopDetailController.responseData.value?.data?.undelivered_at != null) {
      controller.isWithinUndeliveredWindow.value = controller.isArrivedTimeWithinDeliveryWindow(
          stopDetailController.responseData.value?.data?.undelivered_at?.toIso8601String() ?? "",
          stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].start ?? DateTime.now(),
          stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].end ?? DateTime.now());
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height * 0.32,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: AppColors.themeCompleteDeliveryContainerBackGroundColor,
          borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ///   SOO115 and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///   SOO115
              Text(
                stopDetailController.responseData.value?.data?.shipment?.name ?? "N/A",
                style: AppTextStyles(context).markCompleteAndDeliveryRequirementsTextStyle,
              ),
              Row(
                children: [
                  stopDetailController.responseData.value?.data?.shipment?.forkLift == 0
                      ? Container()
                      : SvgPicture.asset("assets/svgs/forklift.svg",
                          height: MediaQuery.of(context).size.width * 0.08, color: AppColors.blackIconColor),
                  stopDetailController.userRole.value == UserRole.LOADER.name
                      ? const SizedBox()
                      : InkWell(
                          onTap: () {
                            Utils().makePhoneCall(
                                '$countryCode${stopDetailController.responseData.value?.data?.shipment?.shipmentCustomerDeliveryLocations?.deliveryContactPhone ?? ""}');
                          },
                          child: SvgPicture.asset(
                            "assets/icons/whatsapp-fill.svg",
                            height: MediaQuery.of(context).size.width * 0.12,
                            color: AppColors.greenIconColor,
                          ),
                        ),
                ],
              ),
            ],
          ),

          controller.userRole.value != UserRole.LOADER.name
              ? Container(
                  margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                  child: Row(
                    children: [
                      SvgPicture.asset("assets/svgs/user.svg",
                          height: MediaQuery.of(context).size.width * 0.04, color: AppColors.blackIconColor),
                      SizedBox(width: MediaQuery.of(context).size.width * 0.01),
                      Flexible(
                        child: Text(
                            stopDetailController.responseData.value?.data?.shipment?.shipmentCustomerDeliveryLocations
                                    ?.deliveryLocationName ??
                                "N/A",
                            softWrap: true,
                            style: AppTextStyles(context).completeDeliveryCommonTextStyle),
                      ),
                    ],
                  ),
                )
              : Container(),

          ///   July29,2023 , 3 stops, P:30 R:50 T:30 and icons
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// jULY 29,2023 and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svgs/sharp-calendar-month.svg",
                      height: MediaQuery.of(context).size.width * 0.04, color: AppColors.blackIconColor),

                  SizedBox(width: MediaQuery.of(context).size.width * 0.005),

                  ///   jULY 29,2023
                  (stopDetailController.responseData.value?.data?.routes == null)
                      ? SizedBox()
                      : Text(
                          DateFormat.yMMMMd()
                              .format(stopDetailController.responseData.value!.data!.routes!.deliveryDate!),
                          style: AppTextStyles(context).completeDeliveryCommonTextStyle),
                ],
              ),

              // SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              //
              // /// 3 stops and icon
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     SvgPicture.asset(
              //       "assets/svgs/location-3.svg",
              //       height: MediaQuery.of(context).size.width * 0.04,
              //       color: AppColors.blackIconColor,
              //     ),
              //
              //     ///   jULY 29,2023
              //     (stopDetailController.responseData.value?.data?.routes ==null) ? SizedBox() : Text
              //       ("${stopDetailController.responseData.value?.data?.routes?.totalStops??0} Stops",
              //         style: AppTextStyles(context)
              //             .completeDeliveryCommonTextStyle),
              //   ],
              // ),
            ],
          ),

          ///   PDT 09:30AM, 120 miles and icons
          Row(
            children: [
              ///   PDT 09:30AM and icon
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/svgs/stopwatch.svg",
                      height: MediaQuery.of(context).size.width * 0.04, color: AppColors.blackIconColor),

                  SizedBox(width: MediaQuery.of(context).size.width * 0.005),

                  ///   PDT 09:30AM
                  (stopDetailController.responseData.value?.data?.routes == null)
                      ? const SizedBox()
                      : Text(
                          stopDetailController.responseData.value?.data?.arrivedAt != null
                              ? "ETA: ${Utils.convertUtcToLocalDateTime(stopDetailController.responseData.value?.data?.arrivedAt ?? DateTime.now())}"
                              : "ETA: $formattedUpdatedTime",
                          style: AppTextStyles(context).completeDeliveryCommonTextStyle),
                ],
              ),
              //
              // SizedBox(width: MediaQuery.of(context).size.width * 0.03),
              //
              // ///   120 miles and icons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     SvgPicture.asset("assets/svgs/round-speed.svg",
              //         height: MediaQuery.of(context).size.width * 0.04,
              //         color: AppColors.blackIconColor),
              //     SizedBox(width: MediaQuery.of(context).size.width * 0.005),
              //
              //     ///   120 miles
              //     Text("${((stopDetailController.responseData.value?.data?.distance??0) / 1609.344).toStringAsFixed(2)}miles",
              //         style: AppTextStyles(context)
              //             .completeDeliveryCommonTextStyle),
              //
              //   ],
              // ),
            ],
          ),

          ///   22H 30M and icon
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// P:30 R:50 T:30 and icon
              InkWell(
                onTap: () {
                  controller
                      .getShipmentInventory(stopDetailController.responseData.value?.data?.shipment?.id ?? 0)
                      .then((value) {
                    showDialog(
                        context: context,
                        builder: (context) =>
                            QuantityPopUp(inventoryData: stopDetailController.inventoryList, isRoutePopUp: false));
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/svgs/scale.svg",
                      height: MediaQuery.of(context).size.width * 0.04,
                      color: AppColors.blackIconColor,
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.005),

                    ///   jULY 29,2023
                    Text(
                        "P: ${stopDetailController.responseData.value?.data?.pQuantity} R: ${stopDetailController.responseData.value?.data?.rQuantity} T: ${stopDetailController.responseData.value?.data?.tQuantity}",
                        style: AppTextStyles(context).completeDeliveryCommonTextStyle),

                    SizedBox(width: MediaQuery.of(context).size.width * 0.005),

                    SvgPicture.asset(
                      "assets/svgs/info.svg",
                      height: MediaQuery.of(context).size.width * 0.04,
                      color: AppColors.blackIconColor,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ///   Bethel WHS-Arcadia,LA, Origin Point and icons
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     SvgPicture.asset("assets/svgs/location-3.svg",
          //         height: MediaQuery.of(context).size.width * 0.04,
          //         color: AppColors.blackIconColor),
          //     SizedBox(width: MediaQuery.of(context).size.width * 0.005),
          //
          //     ///   Bethel WHS-Arcadia,LA
          //     (stopDetailController.responseData.value?.data?.routes == null) ? SizedBox(): Text
          //       (stopDetailController.
          //     responseData.value?.data?.routes?.originPoints??"N/A",
          //         style:
          //         AppTextStyles(context).completeDeliveryCommonTextStyle),
          //
          //     ///   Origin Point
          //     // Text(AppString.completeDeliveryOriginPoint,
          //     //     style: AppTextStyles(context)
          //     //         .completeDeliveryOriginGreyColorTextStyle),
          //   ],
          // ),

          ///   Home Depot3, City, State , Last Drop-Off Location and Icons
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svgs/location-3.svg",
                    height: MediaQuery.of(context).size.width * 0.04, color: AppColors.blackIconColor),
                SizedBox(width: MediaQuery.of(context).size.width * 0.005),

                ///   Home Depot3, City, State
                (stopDetailController.responseData.value?.data?.routes == null)
                    ? const SizedBox()
                    : Flexible(
                        child: Text(
                            '${stopDetailController.responseData.value?.data?.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationAddressLine1}'
                            ', ${stopDetailController.responseData.value?.data?.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationCity}'
                            ', ${stopDetailController.responseData.value?.data?.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationState}'
                            ', ${stopDetailController.responseData.value?.data?.shipment?.shipmentCustomerDeliveryLocations?.deliveryLocationZipcode}',
                            maxLines: 3,
                            softWrap: true,
                            style: AppTextStyles(context).completeDeliveryCommonTextStyle),
                      ),

                // ///   Last Drop-Off Location
                // Text(AppString.completeDeliveryLastDropOffLocation,
                //     style: AppTextStyles(context)
                //         .completeDeliveryOriginGreyColorTextStyle),
              ],
            ),
          ),

          Row(
            children: [
              ///   Icon
              SvgPicture.asset(
                "assets/icons/sharp-calendar-month.svg",
                height: MediaQuery.of(context).size.width * 0.04,
                color: AppColors.blackIconColor,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.005,
              ),

              ///   22H 30M(Expected) text
              Text(
                  '${Utils.convertDateFormatDDMMYYYY(stopDetailController.responseData.value?.data?.routes?.deliveryDate.toString().split(' ')[0] ?? "")}'
                  '(${Utils.formatUtcDateTime(stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].start.toString() ?? "").split(' ')[1]}'
                  ' ${Utils.formatUtcDateTime(stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].start.toString() ?? "").split(' ')[2]}'
                  ' - ${Utils.formatUtcDateTime(stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].end.toString() ?? "").split(' ')[1]}'
                  ' ${Utils.formatUtcDateTime(stopDetailController.responseData.value?.data?.shipment?.propsDeliveryWindow?[0].end.toString() ?? "").split(' ')[2]})',
                  style: AppTextStyles(context).completeDeliveryCommonTextStyle),
            ],
          ),

          ///   Arrived at : 6:00pm
          /*Text("Arrived at: " ,
            textAlign: TextAlign.left,
            style: AppTextStyles(context).completeDeliveryArrivedAtTextStyle,
          ),*/
          if ((stopDetailController.responseData.value?.data?.shipment?.fhfNotes ?? []).isNotEmpty) ...{
            Row(
              children: [
                Text(
                  AppString.locationFHFAvailable,
                  textAlign: TextAlign.left,
                  style: AppTextStyles(context).completeDeliveryCommonTextStyle,
                ),
              ],
            )
          },

          if (stopDetailController.responseData.value?.data?.undelivered_at != null) ...{
            Row(
              children: [
                Text(
                  "${AppString.undeliveredAt}: ${Utils.convertUtcToLocal(stopDetailController.responseData.value?.data?.undelivered_at?.toIso8601String() ?? "")}",
                  textAlign: TextAlign.left,
                  style: controller.isWithinUndeliveredWindow.value
                      ? AppTextStyles(context).completeDeliveryArrivedAtTextStyle
                      : AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                ),
              ],
            )
          },

          if (stopDetailController.responseData.value?.data?.canceled_at != null) ...{
            Row(
              children: [
                Text(
                  "${AppString.canceledAt}: ${Utils.convertUtcToLocal(stopDetailController.responseData.value?.data?.canceled_at?.toIso8601String() ?? "")}",
                  textAlign: TextAlign.left,
                  style: AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                ),
              ],
            )
          },

          if (stopDetailController.responseData.value?.data?.delivered_at != null) ...{
            Row(
              children: [
                Text(
                  "${AppString.deliveredAt}: ${Utils.convertUtcToLocal(stopDetailController.responseData.value?.data?.delivered_at?.toIso8601String() ?? "")}",
                  textAlign: TextAlign.left,
                  style: controller.isWithinDeliveredWindow.value
                      ? AppTextStyles(context).completeDeliveryArrivedAtTextStyle
                      : AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                ),
              ],
            )
          },

          if (stopDetailController.responseData.value?.data?.arrivedAt != null) ...{
            Row(
              children: [
                Text(
                  "${AppString.arrivedAt}: ${Utils.convertUtcToLocal(stopDetailController.responseData.value?.data?.arrivedAt?.toIso8601String() ?? "")}",
                  textAlign: TextAlign.left,
                  style: controller.isWithinWindow.value
                      ? AppTextStyles(context).completeDeliveryArrivedAtTextStyle
                      : AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                ),
                stopDetailController.responseData.value?.data?.undelivered_at == null
                    ? Obx(() => (stopDetailController.sDuration.value != "")
                        ? Text(
                            " (${stopDetailController.sDuration})",
                            textAlign: TextAlign.left,
                            style: controller.isWithinWindow.value
                                ? AppTextStyles(context).completeDeliveryArrivedAtTextStyle
                                : AppTextStyles(context).completeDeliveryLateArrivedAtTextStyle,
                          )
                        : Text(""))
                    : Container(),
              ],
            )
          }
        ],
      ),
    );
  }

  ///   Used for Camera, Signature and Notes icons
  Widget cameraSignatureNotesIcons(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.width * 0.05, top: MediaQuery.of(context).size.width * 0.05),
      decoration: BoxDecoration(
          color: AppColors.themeCompleteDeliveryContainerBackGroundColor,
          borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),

          ///   Camera icon
          (stopDetailController.responseData.value?.data?.deliveryProofs?.isEmpty ?? false)
              ? InkWell(
                  onTap: () {
                    if (stopDetailController.responseData.value?.data?.deliveryStatus == UNDELIVERED ||
                        stopDetailController.responseData.value?.data?.deliveryStatus == CANCELED ||
                        stopDetailController.responseData.value?.data?.arrivedAt == null) {
                      return;
                    } else {
                      openCamera();
                    }
                  },
                  child: DottedBorder(
                    color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
                    strokeWidth: AppDimen.width1, //thickness of dash/dots
                    dashPattern: [2, 4],
                    //dash patterns, 10 is dash width, 6 is space width
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.18,
                      color: Colors.white,
                      padding: EdgeInsets.all(AppDimen.padding10),
                      child: SvgPicture.asset(
                        "assets/icons/camera-fill.svg",
                        color: AppColors.darkGreyIconColor,
                      ),
                    ),
                  ),
                )
              : (stopDetailController.responseData.value?.data?.deliveryProofs?.isNotEmpty ?? false)
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.18,
                      color: Colors.white,
                      child: (stopDetailController.responseData.value?.data?.deliveryProofs
                                      ?.where((proof) => proof.type == "image")
                                      .map((proof) => Image.network(
                                            proof.attachment ??
                                                "", // Replace with the actual URL property in your model
                                            fit: BoxFit.fill,
                                          ))
                                      .toList() ??
                                  <Widget>[])
                              .firstOrNull ??
                          InkWell(
                            onTap: () {
                              openCamera();
                            },
                            child: DottedBorder(
                              color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
                              strokeWidth: AppDimen.width1, //thickness of dash/dots
                              dashPattern: [2, 4],
                              //dash patterns, 10 is dash width, 6 is space width
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.09,
                                width: MediaQuery.of(context).size.width * 0.18,
                                color: Colors.white,
                                padding: EdgeInsets.all(AppDimen.padding10),
                                child: SvgPicture.asset(
                                  "assets/icons/camera-fill.svg",
                                  color: AppColors.darkGreyIconColor,
                                ),
                              ),
                            ),
                          ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.18,
                      color: Colors.white,
                      child: Image(
                        image: FileImage(stopDetailController.image?.value ?? File("")),
                        fit: BoxFit.fill,
                      ),
                    ),

          ///   Signature icon
          (stopDetailController.responseData.value?.data?.deliveryProofs?.isEmpty ?? false)
              ? InkWell(
                  onTap: () {
                    controller.rawImage.value.value = null;
                    controller.svg.value.value = null;
                    controller.rawImageFit.value.value = null;
                    if (stopDetailController.responseData.value?.data?.deliveryStatus == UNDELIVERED ||
                        stopDetailController.responseData.value?.data?.deliveryStatus == CANCELED ||
                        stopDetailController.responseData.value?.data?.arrivedAt == null) {
                      return;
                    } else {
                      openSignaturePad(context);
                    }
                  },
                  child: DottedBorder(
                    color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
                    strokeWidth: AppDimen.width1, //thickness of dash/dots
                    dashPattern: [2, 4],
                    //dash patterns, 10 is dash width, 6 is space width
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.18,
                      color: Colors.white,
                      padding: EdgeInsets.all(AppDimen.padding10),
                      child: SvgPicture.asset(
                        "assets/icons/signature-20-filled.svg",
                        color: AppColors.darkGreyIconColor,
                      ),
                    ),
                  ),
                )
              : (stopDetailController.responseData.value?.data?.deliveryProofs?.isNotEmpty ?? false)
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.18,
                      color: Colors.white,
                      child: (stopDetailController.responseData.value?.data?.deliveryProofs
                                      ?.where((proof) => proof.type == "signature")
                                      .map((proof) => Image.network(
                                            proof.attachment ??
                                                "", // Replace with the actual URL property in your model
                                            fit: BoxFit.fill,
                                          ))
                                      .toList() ??
                                  <Widget>[])
                              .firstOrNull ??
                          InkWell(
                            onTap: () {
                              controller.rawImage.value.value = null;
                              controller.svg.value.value = null;
                              controller.rawImageFit.value.value = null;
                              openSignaturePad(context);
                            },
                            child: DottedBorder(
                              color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
                              strokeWidth: AppDimen.width1, //thickness of dash/dots
                              dashPattern: [2, 4],
                              //dash patterns, 10 is dash width, 6 is space width
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.09,
                                width: MediaQuery.of(context).size.width * 0.18,
                                color: Colors.white,
                                padding: EdgeInsets.all(AppDimen.padding10),
                                child: SvgPicture.asset(
                                  "assets/icons/signature-20-filled.svg",
                                  color: AppColors.darkGreyIconColor,
                                ),
                              ),
                            ),
                          ),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.width * 0.18,
                      color: Colors.white,
                      child: ValueListenableBuilder<String?>(
                        valueListenable: stopDetailController.svg.value,
                        builder: (context, data, child) {
                          if (data == null) {
                            return Container(
                              color: Colors.grey[300],
                              child: Center(
                                child: Text(AppString.signatureNotFound),
                              ),
                            );
                          }
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: SvgPicture.string(
                              data,
                              placeholderBuilder: (_) => Container(
                                color: Colors.lightBlueAccent,
                                child: Center(
                                  child: Text(AppString.parsingData),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

          ///   Notes icon
          InkWell(
            onTap: () {
              if (stopDetailController.responseData.value?.data?.deliveryStatus == UNDELIVERED ||
                  stopDetailController.responseData.value?.data?.deliveryStatus == CANCELED ||
                  stopDetailController.responseData.value?.data?.deliveryStatus == DELIVERED ||
                  stopDetailController.responseData.value?.data?.arrivedAt == null) {
                return;
              } else {
                controller.notesTextEditingController.value.text = "";
                controller.cancelTextEditingController.value.text = "";
                openNotePad(context);
              }
            },
            child: DottedBorder(
              color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
              strokeWidth: AppDimen.width1, //thickness of dash/dots
              dashPattern: [2, 4],
              child: Container(
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.18,
                  color: Colors.white,
                  padding: EdgeInsets.all(AppDimen.padding10),
                  child: SvgPicture.asset(
                    "assets/icons/notes-bold.svg",
                    color: AppColors.darkGreyIconColor,
                  )),
            ),
          ),

          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
        ],
      ),
    );
  }

  void openNotePad(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              content: Material(
            color: Colors.transparent,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.4,
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
                    AppString.notes,
                    style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
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
                    controller: stopDetailController.notesTextEditingController.value,

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
                    stopDetailController
                        .completeDeliveryAction(stopDetailController.responseData.value?.data?.id.toString() ?? "");
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
            ),
          ));
        });
  }

  void cancelDelivery(BuildContext context) {
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
                    "${AppString.markUndeliveredShipment} ${stopDetailController.responseData.value?.data?.shipment?.name}",
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
                    controller: stopDetailController.cancelTextEditingController.value,

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
                    Get.back();
                    stopDetailController.cancelDeliveryAction(
                        stopDetailController.responseData.value?.data?.id.toString() ?? "",
                        controller.cancelTextEditingController.value.text);
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

  void openCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    // setState(() {
    if (pickedFile != null) {
      stopDetailController.image?.value = File(pickedFile.path);
      stopDetailController.imageType.value = "image";
      stopDetailController.completeDeliveryAction(stopDetailController.responseData.value?.data?.id.toString() ?? "");
    } else {
      Utils.showWarningMessage(AppString.alert, AppString.noImageSelected);
    }
  }

  void openSignaturePad(BuildContext context) {
    stopDetailController.svg.value.value = null;
    stopDetailController.rawImage.value.value = null;
    stopDetailController.rawImageFit.value.value = null;
    control.clear();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    MediaQuery.of(context).size.height * 0.003,
                  ),
                ),
              ),
              contentPadding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.015,
              ),
              title: Container(
                alignment: Alignment.center,
                child: Text(
                  AppString.addSignature,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                ),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * 0.59,
                // width: MediaQuery.of(context).size.width,
                //color: Colors.red,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.34,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.030,
                          right: MediaQuery.of(context).size.width * 0.030),
                      color: Colors.grey[700],
                      child: Stack(
                        children: <Widget>[
                          Container(
                            constraints: const BoxConstraints.expand(),
                            color: Colors.grey[300],
                            child: HandSignature(
                              control: control,
                              type: SignatureDrawType.shape,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///   Clear Button
                        CupertinoButton(
                          onPressed: () {
                            control.clear();
                            stopDetailController.svg.value.value = null;
                            stopDetailController.rawImage.value.value = null;
                            stopDetailController.rawImageFit.value.value = null;
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.30,
                            alignment: Alignment.center,
                            color: Colors.lime,
                            child: Text(
                              AppString.clear,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),

                        ///   Save Button
                        CupertinoButton(
                          onPressed: () async {
                            Get.back();
                            stopDetailController.svg.value.value = control.toSvg(
                              color: Colors.black,
                              type: SignatureDrawType.shape,
                              fit: true,
                            );
                            stopDetailController.rawImage.value.value = await control.toImage(
                              color: Colors.blueAccent,
                              background: Colors.greenAccent,
                              fit: false,
                            );
                            stopDetailController.imageType.value = "signature";
                            stopDetailController.completeDeliveryAction(
                                stopDetailController.responseData.value?.data?.id.toString() ?? "");
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.30,
                            alignment: Alignment.center,
                            color: Colors.lime,
                            child: Text(
                              AppString.save,
                              style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width * 0.04,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///   Show Image
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.15,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.030,
                          right: MediaQuery.of(context).size.width * 0.030),
                      color: Colors.white,
                      child: _buildSvgView(),
                    )
                  ],
                ),
              ));
        });
  }

  ///   Save image Widget
  Widget _buildSvgView() => Obx(
        () => Container(
          width: 192.0,
          height: 96.0,
          decoration: BoxDecoration(
            border: Border.all(),
            color: Colors.white30,
          ),
          child: ValueListenableBuilder<String?>(
            valueListenable: stopDetailController.svg.value,
            builder: (context, data, child) {
              if (data == null) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(AppString.signatureNotFound),
                  ),
                );
              }
              return Padding(
                padding: EdgeInsets.all(8.0),
                child: SvgPicture.string(
                  data,
                  placeholderBuilder: (_) => Container(
                    color: Colors.lightBlueAccent,
                    child: Center(
                      child: Text(AppString.parsingData),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );

  void _openMapAndFhfNotes(BuildContext context) {
    controller.getCurrentLocation(zoomLevel: 15.0);
    showDialog(
        context: context,
        barrierDismissible: false,
        // Set this to false to prevent dismissing on tap outside or pressing back button
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(
                  MediaQuery.of(context).size.height * 0.003,
                ),
              ),
            ),
            contentPadding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.015,
            ),
            title: Container(
              alignment: Alignment.center,
              child: Text(
                AppString.pinPointCurrentLocation,
                style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
              ),
            ),
            content: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.59,
                // width: MediaQuery.of(context).size.width,
                //color: Colors.red,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.34,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.030,
                          right: MediaQuery.of(context).size.width * 0.030),
                      color: Colors.grey[700],
                      child: Stack(
                        children: <Widget>[
                          Container(
                            constraints: const BoxConstraints.expand(),
                            color: Colors.grey[300],
                            child: HereMap(
                              onMapCreated: (m) {
                                onMapCreated(m);
                              },
                              gestureRecognizers: Utils().createGestureRecognizers(),
                            ),
                            // GoogleMap(
                            //   gestureRecognizers: Set()
                            //     ..add(Factory<OneSequenceGestureRecognizer>(
                            //         () => EagerGestureRecognizer())),
                            //   scrollGesturesEnabled: true,
                            //   initialCameraPosition: CameraPosition(
                            //     target: LatLng(
                            //         controller
                            //                 .currentLocation.value?.latitude ??
                            //             27.3108198,
                            //         controller
                            //                 .currentLocation.value?.longitude ??
                            //             -81.9889776),
                            //     zoom: 11.5,
                            //   ),
                            //   onMapCreated: (mapController) {
                            //     if (!controller
                            //         .controllerMap.value.isCompleted) {
                            //       controller.controllerMap.value
                            //           .complete(mapController);
                            //     }
                            //   },
                            //   markers: controller.markersList,
                            //   myLocationButtonEnabled:
                            //       true, // Set to true to enable the "Show Your Location" button
                            //   myLocationEnabled:
                            //       true, // Set to true to show the blue dot indicating the current location
                            // ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.01,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.030,
                          right: MediaQuery.of(context).size.width * 0.030),
                      child: Column(
                        children: <Widget>[
                          Text(
                            AppString.enterLocationNotes,
                            style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.003,
                          ),
                          TextFormField(
                            autofocus: true,
                            autocorrect: false,
                            keyboardType: TextInputType.multiline,
                            controller: stopDetailController.notesTextEditingController.value,

                            // minLines: 1,
                            maxLines: 1,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[300],
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.01)),
                                borderSide:
                                    BorderSide(width: MediaQuery.of(context).size.height * 0.001, color: Colors.grey),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(MediaQuery.of(context).size.height * 0.01)),
                                borderSide:
                                    BorderSide(width: MediaQuery.of(context).size.height * 0.001, color: Colors.grey),
                              ),
                              contentPadding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ///   Clear Button
                          CupertinoButton(
                            onPressed: () {
                              stopDetailController.markCurrentPoint.value = false;
                              Get.back();
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.30,
                              alignment: Alignment.center,
                              color: Colors.lime,
                              child: Text(
                                AppString.cancel,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),

                          ///   Save Button
                          CupertinoButton(
                            onPressed: () async {
                              stopDetailController.addPinFhFNotes(
                                  stopDetailController.responseData.value?.data?.shipmentId.toString() ?? "");
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.30,
                              alignment: Alignment.center,
                              color: Colors.lime,
                              child: Text(
                                AppString.save,
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void onMapCreated(HereMapController hereMapController) {
    controller.hereMapController.value = hereMapController;
    controller.hereMapController.refresh();
    // The camera can be configured before or after a scene is loaded.
    const double distanceToEarthInMeters = 8000;
    MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, distanceToEarthInMeters);
    controller.hereMapController.value?.camera.lookAtPointWithMeasure(
        GeoCoordinates(controller.currentLocation.value?.latitude ?? 27.3108198,
            controller.currentLocation.value?.longitude ?? -81.9889776),
        mapMeasureZoom);

    addMapMarker(
        GeoCoordinates(controller.currentLocation.value?.latitude ?? 27.3108198,
            controller.currentLocation.value?.longitude ?? -81.9889776),
        controller.hereMapController.value!);
    // Load the map scene using a map scheme to render the map with.
    controller.hereMapController.value?.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
      }
    });
  }

  void addMapMarker(GeoCoordinates geoCoordinates, HereMapController hereMapController) {
    int imageWidth = 60;
    int imageHeight = 80;
    MapImage mapImage = MapImage.withFilePathAndWidthAndHeight("assets/images/truck.png", imageWidth, imageHeight);
    MapMarker mapMarker = MapMarker(geoCoordinates, mapImage);
    hereMapController.mapScene.addMapMarker(mapMarker);
  }
}
