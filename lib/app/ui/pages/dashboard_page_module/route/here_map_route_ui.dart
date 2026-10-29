// import 'dart:io';
// import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
// import 'package:bethel_farm/modules/dashboard/route/route_expand.dart';
// import 'package:bethel_farm/modules/loader/loader_route_detail/here_route_details_ctrl.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:here_sdk/consent.dart';
// import 'package:here_sdk/core.dart';
// import 'package:here_sdk/core.engine.dart';
// import 'package:here_sdk/core.errors.dart';
// import 'package:here_sdk/gestures.dart';
// import 'package:here_sdk/mapview.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:wakelock_plus/wakelock_plus.dart';
//
// import '../../../core/app_colors/app_colors.dart';
// import '../../../core/app_decoration/app_decoration.dart';
// import '../../../core/app_dimens/app_dimens.dart';
// import '../../../core/app_string/app_strings.dart';
// import '../../../core/app_values/app_values.dart';
// import '../../../core/widgets/elevated_container.dart';
// import '../../../data/enums/user_role.dart';
// import '../../../utils/exports.dart';
// import '../../../utils/utils.dart';
// import '../../loader/pickup_order_detail/view/notes_modal_bottom_sheet.dart';
//
//
// class HereMapRouteUI extends StatefulWidget {
//   @override
//   _HereMapRouteUIState createState() => _HereMapRouteUIState();
// }
//
// class _HereMapRouteUIState extends State<HereMapRouteUI> with WidgetsBindingObserver {
//   var hereRouteController=Get.put(HereRouteDetailCtrl());
//   static const String _trackingOn = "Tracking: ON";
//   static const String _trackingOff = "Tracking: OFF";
//   String _trackingState = "Pending ...";
//   bool _isTracking = true;
//
//   // When using HERE Positioning in your app, it is required to request and to show the user's consent decision.
//   // In addition, users must be able to change their consent decision at any time.
//   // Note that this is only needed when running on Android devices.
//   ConsentEngine? _consentEngine;
//   String _consentState = "Pending ...";
//   String _messageState = "";
//
//   Future<bool> _handleBackPress() async {
//     // Handle the back press.
//     hereRouteController.detach();
//
//     // Return true to allow the back press.
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _handleBackPress,
//       child: Scaffold(
//             backgroundColor: AppColors.white,
//             body: Stack(children: [
//               Obx(
//                     () =>  Column(
//                   children: [
//
//                     /// Notification Icon
//                     hereRouteController.userRole.value == UserRole.MERCHANDISER.name ? Container() :
//
//                     Container(
//                       padding: const EdgeInsets.only(left: 10,right:10),
//                       width: MediaQuery.of(context).size.width,
//                       height: MediaQuery.of(context).size.height * 0.06,
//                       margin: EdgeInsets.only(top:MediaQuery.of(context).size.height * 0.06 ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           ///   back icon
//                           InkWell(
//                             onTap: () {
//                               WakelockPlus.toggle(enable: false);
//                               _onBackPressed();
//                               Get.back(result: true);
//                             },
//                             child: Container(
//                                 height: MediaQuery.of(context).size.width * 0.08,
//                                 width: MediaQuery.of(context).size.width * 0.08,
//                                 padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015),
//                                 decoration: BoxDecoration(
//                                     color: AppColors().green5, borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular50))),
//                                 child: Icon(
//                                   Icons.arrow_back_ios,
//                                   size: MediaQuery.of(context).size.width * 0.05,
//                                   color: AppColors.blackIconColor,
//                                 )),
//                           ),
//
//                           ///   Route Details
//                           Text((hereRouteController.viewOnly.value)
//                               ? AppString.routeDetailText
//                               : (hereRouteController.routeDetail.value?.loadingBy == "driver" &&
//                               (hereRouteController.userRole.value.toLowerCase() == "driver" ||
//                                   hereRouteController.userRole.value.toLowerCase() == "sub_driver")) ||
//                               (hereRouteController.routeDetail.value?.loadingBy == "carrier_owner" &&
//                                   hereRouteController.userId == hereRouteController.routeDetail.value?.driver?.id) ||
//                               hereRouteController.userRole.value.toLowerCase() == "driver"
//                               ? AppString.driverDetailRouteDetails
//                               : (hereRouteController.userRole.value.toLowerCase() == "loader")
//                               ? AppString.loadingDetailRouteDetails
//                               : AppString.routeDetails,
//                               textAlign: TextAlign.start,
//                               style: TextStyle(
//                                   fontSize: MediaQuery.of(context).size.width * 0.05,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black)),
//
//                           ///   For gap
//                           SizedBox(width: MediaQuery.of(context).size.width * 0.08),
//
//                           ///   Notification icon
//                           Utils().notificationIconWidget(context: context, height: (MediaQuery.of(context).size.height * 0.035),color: AppColors.black),
//                         ],
//                       ),
//                     ),
//
//                     SizedBox(
//                         height: MediaQuery.sizeOf(context).height * 0.8,
//                         width: MediaQuery.sizeOf(context).width,
//                         child:
//                         HereMap(onMapCreated:(m){
//                           hereRouteController.hereMapController=m;
//                           _onMapCreated(hereRouteController.hereMapController!);},gestureRecognizers: Utils().createGestureRecognizers(),
//                         ),
//
//                     ),
//                   ],
//                 ),
//               ),
//               Stack(
//                 children: [
//                   Stack(
//                     children: [
//                       Obx(
//                             () =>  Stack(
//                           children: [
//
//
//                             // Positioned widget for the remaining time display and maneuver directions
//                             if (hereRouteController.userRole.value != UserRole.MERCHANDISER.name && hereRouteController.routeDetail.value?.status?.toLowerCase() != "completed")
//                               Positioned(
//                                 top: 120 ,
//                                 left: 16,
//                                 right: 16,
//                                 child: messageStateWidget(_messageState),
//                               ),
//
//                           ],
//                         ),
//                       ),
//                       DraggableScrollableSheet(
//                         key: hereRouteController.sheet,
//                         initialChildSize: 0.45,
//                         maxChildSize: 0.85,
//                         minChildSize: 0.12,
//                         expand: true,
//                         snap: true,
//                         snapSizes: const [0.12],
//                         controller: hereRouteController.controller.value,
//                         builder: (BuildContext context, ScrollController scrollController) {
//                           return DecoratedBox(
//                             decoration: BoxDecoration(
//                                 color: AppColors.themeWhiteColor,
//                                 borderRadius: BorderRadius.only(
//                                     topLeft: Radius.circular(AppDimen.circular30),
//                                     topRight: Radius.circular(AppDimen.circular30))),
//                             child: CustomScrollView(controller: scrollController, slivers: [
//                               SliverToBoxAdapter(
//                                 child: Column(
//                                   children: [
//                                     Obx(
//                                           () =>  Column(
//                                         mainAxisAlignment: MainAxisAlignment.center,
//                                         crossAxisAlignment: CrossAxisAlignment.center,
//                                         children: [
//                                           ///   Swipe up Linear line View
//                                           Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: [
//                                                 Container(
//                                                     height: MediaQuery.of(context).size.height * 0.01,
//                                                     width: MediaQuery.of(context).size.width * 0.17,
//                                                     alignment: Alignment.center,
//                                                     color: Colors.grey[400],
//                                                     margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01))
//                                               ]),
//
//                                           ///   Note pad, Pause button and direction icon
//                                           Row(
//                                               mainAxisAlignment: MainAxisAlignment.center,
//                                               crossAxisAlignment: CrossAxisAlignment.center,
//                                               children: [
//                                                 ///   Note pad icon
//                                                 hereRouteController.subDriver=="yes"
//                                                     ? const SizedBox():
//                                                 InkWell(
//                                                     onTap: () {
//                                                       if (hereRouteController.routeDetail.value?.id == null) {
//                                                         // print('null');
//                                                       } else {
//                                                         showModalBottomSheet<void>(
//                                                             context: context,
//                                                             backgroundColor: Colors.white,
//                                                             shape: RoundedRectangleBorder(
//                                                                 borderRadius: BorderRadius.only(
//                                                                     topLeft: Radius.circular(AppDimen.circular20),
//                                                                     topRight: Radius.circular(AppDimen.circular20))),
//                                                             builder: (context) {
//                                                               return SizedBox(
//                                                                 height: 900,
//                                                                 width: MediaQuery.of(context).size.width,
//                                                                 child: NotesModalBottomSheet(
//                                                                   deliveryInstructions:
//                                                                   hereRouteController.routeDetail.value?.deliveryInstruction,
//                                                                   isDelivery: true,
//                                                                 ),
//                                                               );
//                                                             });
//                                                       }
//                                                     },
//                                                     child: Container(
//                                                         padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//                                                         decoration: BoxDecoration(
//                                                             color: Colors.amber,
//                                                             borderRadius: BorderRadius.circular(AppDimen.circular50)),
//                                                         child: SvgPicture.asset("assets/icons/edit-notes.svg",
//                                                             height: MediaQuery.of(context).size.width * 0.065,
//                                                             color: AppColors.white))),
//
//                                                 SizedBox(width: MediaQuery.of(context).size.width * 0.08),
//
//                                                 ///   Pause Button icon
//                                                 (hereRouteController.userRole.value == UserRole.MERCHANDISER.name || hereRouteController.subDriver=="yes")
//                                                     ? const SizedBox()
//                                                     : (hereRouteController.routeDetail.value?.isPaused == 1 ||
//                                                     hereRouteController.routeDetail.value?.status?.toLowerCase() == "in-transit-arrived")
//                                                     ? InkWell(
//                                                     onTap: () {
//                                                       if (hereRouteController.routeDetail.value?.status?.toLowerCase() == "in-transit-on-time" ||
//                                                           hereRouteController.routeDetail.value?.status?.toLowerCase() == "in-transit-delay") {
//                                                         hereRouteController.routeStatus.value="";
//                                                         hereRouteController.routePauseLog();
//                                                         hereRouteController.update();
//                                                       }else if(hereRouteController.routeDetail.value?.status?.toLowerCase() == "in-transit-arrived"){
//
//                                                         hereRouteController.selectedReason.value="pause for a break";
//                                                         hereRouteController.reasonTextController?.value.text="Arrived at the location for the delivery";
//                                                         hereRouteController.routeStatus.value="in-transit-on-time";
//                                                         hereRouteController.routePauseLog();
//                                                         hereRouteController.update();
//                                                       }else if(hereRouteController.routeDetail.value?.status?.toLowerCase() == "delivered" &&
//                                                           hereRouteController.routeDetail.value?.isPaused==1){
//
//                                                         hereRouteController.selectedReason.value="pause for a break";
//                                                         hereRouteController.reasonTextController?.value.text="Arrived at the location for the delivery";
//                                                         bool allDelivered = hereRouteController.stepperData.every((element) => element.content['deliveryStatus'] == "delivered"||element.content['deliveryStatus'] == "undelivered");
//                                                         if(allDelivered){
//                                                           hereRouteController.routeStatus.value = "delivered";
//                                                         }else {
//                                                           hereRouteController.routeStatus.value = "in-transit-on-time";
//                                                         }
//                                                         hereRouteController.update();
//                                                         print(hereRouteController.reasonTextController?.value.text);
//                                                         hereRouteController.routePauseLog();
//                                                       }
//                                                     },
//                                                     child: SvgPicture.asset("assets/icons/route-play-icon.svg",
//                                                         height: MediaQuery.of(context).size.height * 0.10))
//                                                     : (hereRouteController.routeDetail.value?.status?.toLowerCase() != "in-transit-on-time"
//                                                     && hereRouteController.routeDetail.value?.status?.toLowerCase() != "in-transit-delay"
//                                                     && hereRouteController.routeDetail.value?.status?.toLowerCase() != "in-transit-arrived"
//                                                     && hereRouteController.routeDetail.value?.status?.toLowerCase() != "delivered")
//                                                     ? SvgPicture.asset(
//                                                   "assets/icons/route-pause-icon-disable.svg",
//                                                   height: MediaQuery.of(context).size.height * 0.10,
//                                                 )
//                                                     :  hereRouteController.subDriver=="yes" ?SizedBox():InkWell(
//                                                   onTap: () {
//                                                     _showPopupRoutePauseLog(context, hereRouteController);
//                                                   },
//                                                   child: SvgPicture.asset(
//                                                     "assets/icons/route-pause-icon.svg",
//                                                     height: MediaQuery.of(context).size.height * 0.10,
//                                                   ),
//                                                 ),
//                                                 SizedBox(
//                                                   width: MediaQuery.of(context).size.width * 0.08,
//                                                 ),
//
//                                                 ///   Direction icon
//                                                 hereRouteController.subDriver=="yes"
//                                                     ? const SizedBox()
//                                                     : InkWell(
//                                                     onTap: () async {
//                                                       hereRouteController.controller.value.jumpTo(0.12);
//                                                       if (hereRouteController.userRole.value != UserRole.MERCHANDISER.name) {
//                                                         // Animate the camera to the new position
//                                                         // controller.isSheetOpen.value = !controller.isSheetOpen.value;
//                                                         await hereRouteController.lastKnownLocation;
//
//                                                       }
//                                                     },
//                                                     child: Container(
//                                                         padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
//                                                         decoration: BoxDecoration(
//                                                             color: Colors.blueAccent,
//                                                             borderRadius: BorderRadius.circular(AppDimen.circular50)),
//                                                         child: SvgPicture.asset("assets/icons/direction-fill.svg",
//                                                             height: MediaQuery.of(context).size.width * 0.065,
//                                                             color: AppColors.white)))
//                                               ]),
//
//
//                                         ],),
//                                     ),
//
//                                     ///   Used for display expand Route details UI
//                                     Container(
//                                         height: MediaQuery.of(context).size.height * 0.7,
//                                         width: MediaQuery.of(context).size.width * 0.88,
//                                         margin: EdgeInsets.only(
//                                             left: MediaQuery.of(context).size.width * 0.003,
//                                             right: MediaQuery.of(context).size.width * 0.003,
//                                             top: MediaQuery.of(context).size.width * 0.02),
//                                         child: Container()
//                                         // RouteExpand()
//                                     )
//                                   ],
//                                 ),),
//                             ],),);
//                         },
//                       ),
//                     ],
//                   ),
//                   Obx(
//                         () =>hereRouteController.isLoading.value
//                         ? Center(
//                         child: ElevatedContainer(
//                             padding: EdgeInsets.all(AppValues.margin),
//                             child: const CircularProgressIndicator(color: AppColors.colorPrimary)))
//                         : Container(),
//                   ),
//                 ],
//               ),
//
//             ]),
//           ),
//
//     );
//   }
//   void _showPopupRoutePauseLog(BuildContext context, HereRouteDetailCtrl controller) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return Obx(
//                 () => Material(
//               color: Colors.transparent,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SingleChildScrollView(
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       padding: EdgeInsets.only(
//                         left: MediaQuery.of(context).size.height * 0.03,
//                         right: MediaQuery.of(context).size.height * 0.03,
//                         top: MediaQuery.of(context).size.height * 0.025,
//                         bottom: MediaQuery.of(context).size.height * 0.025,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.white,
//                         borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular20)),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           ///   Sort By and cross icon
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               ///   Sort By
//                               Text("Break/Pause Route :",
//                                   style: AppTextStyles(context).bold4TextStyle(
//                                       fontSize: MediaQuery.of(context).size.width * 0.045, textColor: AppColors.black)),
//
//                               ///   Icon
//                               InkWell(
//                                 onTap: () {
//                                   Navigator.pop(context);
//                                 },
//                                 child: Icon(Icons.close, size: MediaQuery.of(context).size.width * 0.07),
//                               )
//                             ],
//                           ),
//
//                           ///   For Gap
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.02),
//
//                           ///   Shipment / Delivery Date
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.9,
//                             height: MediaQuery.of(context).size.height * 0.15,
//                             child: ListView(
//                               children: (controller.breakDown)
//                                   .map((timeValue) => RadioListTile<String>(
//                                 activeColor: Colors.black,
//                                 groupValue: controller.selectedReason.value,
//                                 title: Text(
//                                   timeValue,
//                                   style: AppTextStyles(context).bold4TextStyle(
//                                       fontSize: MediaQuery.of(context).size.width * 0.045,
//                                       textColor: AppColors.black),
//                                 ),
//                                 value: timeValue,
//                                 onChanged: (val) {
//                                   controller.selectedReason.value = val ?? "Breakdown";
//                                 },
//                               ))
//                                   .toList(),
//                             ),
//                           ),
//
//                           ///   For gap
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.015),
//
//                           ///   Pickup time
//                           Row(
//                             children: [
//                               Text("Note",
//                                   style: AppTextStyles(context).bold4TextStyle(
//                                     fontSize: MediaQuery.of(context).size.width * 0.045,
//                                     textColor: AppColors.black,
//                                   )),
//                               Text(" ( optional )",
//                                   style: AppTextStyles(context).bold4TextStyle(
//                                     fontSize: MediaQuery.of(context).size.width * 0.035,
//                                     textColor: AppColors.black,
//                                   )),
//                             ],
//                           ),
//
//                           ///   For Gap
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.035),
//
//                           /// Username input box
//                           TextFormField(
//                               textInputAction: TextInputAction.next,
//                               textAlignVertical: TextAlignVertical.center,
//                               style: AppTextStyles(context).title,
//                               decoration: AppDecorations.emailInputDecorations(AppString.enterText, context),
//                               onChanged: (text) {},
//                               autofocus: false,
//                               controller: controller.reasonTextController?.value),
//
//                           ///   For Gap
//                           SizedBox(height: MediaQuery.of(context).size.height * 0.035),
//
//                           ///   Apply Button and Cancel Button.
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceAround,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 ///   Apply Button
//                                 Container(
//                                   width: MediaQuery.of(context).size.width * 0.35,
//                                   height: MediaQuery.of(context).size.height * 0.055,
//                                   decoration: BoxDecoration(
//                                       color: AppColors().green1,
//                                       borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
//                                   child: MaterialButton(
//                                     child: Text('Save',
//                                         style: AppTextStyles(context).bold4TextStyle(
//                                             fontSize: MediaQuery.of(context).size.width * 0.045,
//                                             textColor: AppColors.white)),
//                                     onPressed: () {
//                                       controller.routePauseLog();
//                                       controller.update();
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                 ),
//
//                                 ///   Clear Button
//                                 Container(
//                                   width: MediaQuery.of(context).size.width * 0.35,
//                                   height: MediaQuery.of(context).size.height * 0.055,
//                                   decoration: BoxDecoration(
//                                       color: AppColors().red1,
//                                       borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
//                                   child: MaterialButton(
//                                     child: Text('Cancel',
//                                         style: AppTextStyles(context).bold4TextStyle(
//                                             fontSize: MediaQuery.of(context).size.width * 0.045,
//                                             textColor: AppColors.white)),
//                                     onPressed: () {
//                                       controller.reasonTextController?.value.text="";
//                                       Navigator.pop(context);
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   void _onMapCreated(HereMapController hereMapController) {
//     final double _distanceInMeters = 2000;
//     try {
//       _consentEngine = ConsentEngine();
//     } on InstantiationException {
//       throw ("Initialization of ConsentEngine failed.");
//     }
//
//     hereMapController.mapScene.loadSceneForMapScheme(MapScheme.normalDay, (MapError? error) async {
//
//       _updateMessageState("Loading MapView ...");
//
//       if (error == null) {
//         // Listen for changes in camera position and update the map
//
//
//
//         MapMeasure mapMeasureZoom = MapMeasure(MapMeasureKind.distance, _distanceInMeters);
//         hereMapController.camera.lookAtPointWithMeasure(hereRouteController.startGeoCoordinates.value!,mapMeasureZoom);
//
//         // 1. Before we start the app we want to ensure that the required permissions are handled.
//         if (!await _requestPermissions()) {
//           await _showDialog("Error", "Cannot start app: Location service and permissions are needed for this app.");
//           // Let the user set the permissions from the system settings as fallback.
//           openAppSettings();
//           SystemNavigator.pop();
//           return;
//         }
//
//         // 2. Once permissions are granted, we request the user's consent decision which is required for HERE Positioning.
//         if (_consentEngine?.userConsentState == ConsentUserReply.notHandled) {
//           await _requestConsent();
//         } else {
//           _updateConsentState();
//         }
//
//         // 3. User has granted required permissions and made a consent decision.
//         _updateMessageState("");
//
//         // hereRouteController = AppLogic(hereMapController, _updateMessageState, _showDialog);
//         ///need to add when navigation
//         hereRouteController.init(hereMapController, _updateMessageState, _showDialog);
//         hereMapController.setWatermarkLocation(
//           Anchor2D.withHorizontalAndVertical(0, 1),
//           Point2D(
//             -hereMapController.watermarkSize.width / 2,
//             -hereMapController.watermarkSize.height / 2,
//           ),
//         );
//         _updateTrackingState();
//       } else {
//         print("Map scene not loaded. MapError: " + error.toString());
//       }
//       // _addGestureListeners(hereMapController);
//     });
//   }
//
//   void _addGestureListeners(HereMapController hereMapController) {
//     hereMapController.gestures.panListener = PanListener((state, origin, translation, velocity) {
//
//     });
//
//     hereMapController.gestures.tapListener = TapListener((Point2D touchPoint) {
//
//     });
//
//     hereMapController.gestures.longPressListener = LongPressListener((state, point) {
//
//     });
//     hereMapController.gestures.twoFingerPanListener = TwoFingerPanListener((state, Point2D touchPoint,Point2D touchPoint1,double val) {
//
//     });
//   }
//
//   // Request permissions with the permission_handler plugin. Set the required permissions here:
//   // Android: navigation_app/android/app/src/main/AndroidManifest.xml
//   // iOS: navigation_app/ios/Runner/Info.plist
//   Future<bool> _requestPermissions() async {
//     if (!await Permission.location.serviceStatus.isEnabled) {
//       return false;
//     }
//
//     if (!await Permission.location.request().isGranted) {
//       return false;
//     }
//
//     if (Platform.isAndroid) {
//       // This permission is optionally needed on Android devices >= Q to improve the positioning signal.
//       Permission.activityRecognition.request();
//     }
//
//     // All required permissions granted.
//     return true;
//   }
//
//   Future<void> _requestConsent() async {
//     if (!Platform.isIOS) {
//       // This shows a localized widget that asks the user if data can be collected or not.
//       await _consentEngine?.requestUserConsent(context);
//     }
//
//     _updateConsentState();
//   }
//
//   // Update the button's text showing the current consent decision of the user.
//   void _updateConsentState() {
//     String stateMessage;
//     if (Platform.isIOS) {
//       stateMessage = "Info: On iOS no consent is required as on iOS no data is collected.";
//     } else if (_consentEngine?.userConsentState == ConsentUserReply.granted) {
//       stateMessage = "Positioning consent: You have granted consent to the data collection.";
//     } else {
//       stateMessage = "Positioning consent: You have denied consent to the data collection.";
//     }
//
//     setState(() {
//       _consentState = stateMessage;
//     });
//   }
//
//   // Update the button's tracking state and set tracking state to VisualNavigator.
//   void _updateTrackingState() {
//     setState(() {
//       _trackingState = _isTracking ? _trackingOn : _trackingOff;
//     });
//
//     if (hereRouteController != null) {
//       hereRouteController.setTracking(_isTracking);
//     }
//   }
//
//   // Update the message text state and show selected log messages.
//   void _updateMessageState(String messageState) {
//     setState(() {
//       _messageState = messageState;
//       print(messageState);
//     });
//   }
//
//   void _startNavigationSimulationButtonClicked() {
//     if (hereRouteController != null) {
//       hereRouteController.startNavigationSimulation();
//     }
//   }
//
//   void _startNavigationButtonClicked() {
//     if (hereRouteController != null) {
//       hereRouteController.startNavigation();
//     }
//   }
//
//   void toggleTrackingButtonClicked() {
//     _isTracking = !_isTracking;
//     _updateTrackingState();
//   }
//
//   void _stopNavigationButtonClicked() {
//     if (hereRouteController != null) {
//       hereRouteController.stopNavigation();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance!.addObserver(this);
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance!.removeObserver(this);
//
//     // Free HERE SDK resources before the application shuts down.
//     SDKNativeEngine.sharedInstance?.dispose();
//     SdkContext.release();
//
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.detached && hereRouteController != null) {
//       hereRouteController.detach();
//     }
//   }
//
//   // A helper method to add a button on top of the HERE map.
//   Align button(String buttonLabel, VoidCallback? callbackFunction) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.lightBlueAccent,
//           foregroundColor: Colors.white,
//         ),
//         onPressed: callbackFunction,
//         child: Text(buttonLabel, style: TextStyle(fontSize: 15)),
//       ),
//     );
//   }
//
//   // A helper method to add a multiline button on top of the HERE map.
//   Align multiLineButton(String buttonLabel, VoidCallback? callbackFunction) {
//     return Align(
//       alignment: Alignment.topCenter,
//       child: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.lightBlueAccent,
//           foregroundColor: Colors.white,
//         ),
//         onPressed: callbackFunction,
//         child: Container(
//           width: MediaQuery.of(context).size.width * 0.8,
//           padding: EdgeInsets.all(2.0),
//           child: Text(
//             buttonLabel,
//             style: TextStyle(fontSize: 15),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       ),
//     );
//   }
//
//   // A helper method to add a message widget on the top of the HERE map.
//   Widget messageStateWidget(String messageState) {
//     return Opacity(
//       opacity: 0.75,
//       child: Card(
//         color: AppColors.themeRed1,
//         child: Padding(
//           padding: EdgeInsets.all(8.0),
//           child: Text(
//             messageState,
//             style: TextStyle(
//               fontSize: 15,
//               color: Colors.white,
//             ),
//           ),
//         ),
//         margin: EdgeInsets.only(left: 12.0, right: 12.0, top: 8.0),
//       ),
//     );
//   }
//
//   // A helper method to show a dialog.
//   Future<void> _showDialog(String title, String message) async {
//     return showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: SingleChildScrollView(
//             child: ListBody(
//               children: <Widget>[
//                 Text(message),
//               ],
//             ),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text("OK"),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
//   bool _onBackPressed() {
//
//     hereRouteController.errorController?.close();
//
//     return true;
//   }
// }