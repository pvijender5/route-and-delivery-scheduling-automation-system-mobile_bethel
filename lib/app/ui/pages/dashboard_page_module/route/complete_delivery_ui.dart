//
//
// import 'package:bethel_farm/core/app_colors/app_colors.dart';
// import 'package:bethel_farm/utils/exports.dart';
// import 'package:flutter/material.dart';
// import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get_core/src/get_main.dart';
// import '../../../../core/app_dimens/app_dimens.dart';
// import '../../../../core/app_string/app_strings.dart';
// import 'package:dotted_border/dotted_border.dart';
//
// import '../../../base/base_view.dart';
// import '../../loader/loader_route_detail/route_details_ctrl.dart';
//
// class CompleteDelivery extends BaseView<RouteDetailsController> {
//   bool _value = false;
//   final controller = Get.put(RouteDetailsController());
//   @override
//   PreferredSizeWidget? appBar(BuildContext context) {
//     Get.lazyPut(() => RouteDetailsController());
//     return null;
//   }
//
//   @override
//   Widget body(BuildContext context) {
//
//     return Scaffold(
//       backgroundColor: AppColors.themeWhiteColor,
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.08),
//         padding: EdgeInsets.only(
//           left: MediaQuery.of(context).size.height*0.02,
//           right: MediaQuery.of(context).size.height*0.02,
//         ),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ///   Mark Complete For Stop No.3
//               Text(AppString.completeDeliveryMarkCompleteForStop,textAlign: TextAlign.left,
//                   style: AppTextStyles(context).markCompleteAndDeliveryRequirementsTextStyle),
//               ///   For Gap
//               SizedBox(height: MediaQuery.of(context).size.height*0.01),
//               ///   Collect Proof of Deliver
//               Text(AppString.completeDeliveryCollectProofOfDelivery,textAlign: TextAlign.left,
//                   style: AppTextStyles(context).collectProofOfDelivery),
//               ///   For Gap
//               SizedBox(height: MediaQuery.of(context).size.height*0.01,),
//               ///   Used for SOO115 and C-ontainer
//               soo115Container(context),
//               SizedBox(height: MediaQuery.of(context).size.height*0.022),
//               ///   Delivery Requirements
//               Text(AppString.completeDeliveryDeliveryRequirements,
//                   style: AppTextStyles(context).markCompleteAndDeliveryRequirementsTextStyle),
//               SizedBox(height: MediaQuery.of(context).size.height*0.005),
//               ///   0 of 3 Completed
//               Text(AppString.completeDelivery0Of3Completed,
//                   style: AppTextStyles(context).completeDeliveryOriginGreyColorTextStyle),
//               ///   For Gap
//               SizedBox(height: MediaQuery.of(context).size.height*0.02),
//               ///   Used for Camera, Signature and Notes icons
//               cameraSignatureNotesIcons(context),
//               ///   Check box, Mark Current Point for Future Deliveries at this
//               CheckboxListTile(
//                   title: Text(AppString.completeDeliveryMarkCurrentPointForFutureDeliveriesAtThisCustomerLocation,
//                     style: AppTextStyles(context).completeDeliveryCommonTextStyle,
//                   ),
//                   value: _value,
//                   onChanged: (newValue) {
//                     _value = newValue!;
//                   },
//                   controlAffinity: ListTileControlAffinity.leading,
//                   checkColor: AppColors.greenIconColor,
//                   activeColor: AppColors.themeCompleteDeliveryContainerBackGroundColor
//               ),
//               ///   For Gap
//               SizedBox(height: MediaQuery.of(context).size.height*0.02),
//               ///   Complete Delivery Button
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Container(
//                     width: MediaQuery.of(context).size.width*0.45,
//                     height: MediaQuery.of(context).size.height*0.06,
//                     alignment: Alignment.center,
//                     padding: EdgeInsets.only(
//                         left: MediaQuery.of(context).size.width * 0.035,
//                         right: MediaQuery.of(context).size.width * 0.035
//                     ),
//                     decoration: BoxDecoration(
//                         color: AppColors.themeGreen1Color,
//                         borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))
//                     ),
//                     child: Text(AppString.completeDeliveryCompleteDelivery,
//                         style: AppTextStyles(context).completeDeliveryButtonTextStyle),
//                   ),
//                 ],
//               ),
//               ///   For Gap
//               SizedBox(height: MediaQuery.of(context).size.height*0.03),
//               Container(
//                 alignment: Alignment.center,
//                 child: Text(AppString.completeDeliveryPhotosAndSignatureAreMandataryToCompleteTheShipment,
//                     style: AppTextStyles(context).completeDeliveryOriginGreyColorTextStyle),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//   ///   Used for SOO115 and Container
//   Widget soo115Container(BuildContext context){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       height: MediaQuery.of(context).size.height*0.32,
//       padding: EdgeInsets.only(
//         left: MediaQuery.of(context).size.width * 0.03,
//         right: MediaQuery.of(context).size.width * 0.03,
//         top: MediaQuery.of(context).size.width * 0.005,
//         bottom: MediaQuery.of(context).size.width * 0.03
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.themeCompleteDeliveryContainerBackGroundColor,
//         borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular20))
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ///   SOO115 and icon
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               ///   SOO115
//               Text(AppString.completeDeliverySOO115,
//                 style: AppTextStyles(context).markCompleteAndDeliveryRequirementsTextStyle,),
//               SvgPicture.asset(
//                 "assets/icons/whatsapp-fill.svg",
//                 height: MediaQuery.of(context).size.width * 0.12,
//                 color: AppColors.greenIconColor,
//               ),
//             ],
//           ),
//           ///   July29,2023 , 3 stops, P:30 R:50 T:30 and icons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               /// jULY 29,2023 and icon
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     "assets/svgs/sharp-calendar-month.svg",
//                     height: MediaQuery.of(context).size.width * 0.04,
//                     color: AppColors.blackIconColor
//                   ),
//                   ///   For Gap
//                   SizedBox(width: MediaQuery.of(context).size.width*0.005),
//                   ///   jULY 29,2023
//                   Text(AppString.completeDeliveryJuly292023,
//                     style: AppTextStyles(context).completeDeliveryCommonTextStyle
//                   ),
//                 ],
//               ),
//               ///   For Gap
//               SizedBox(width: MediaQuery.of(context).size.width*0.03),
//               /// 3 stops and icon
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   ///   Location Icon
//                   SvgPicture.asset(
//                     "assets/svgs/location-3.svg",
//                     height: MediaQuery.of(context).size.width * 0.04,
//                     color: AppColors.blackIconColor,
//                   ),
//                   ///   jULY 29,2023
//                   Text(AppString.completeDelivery3Stops,
//                     style: AppTextStyles(context).completeDeliveryCommonTextStyle
//                   ),
//                 ],
//               ),
//               ///   For Gap
//               SizedBox(width: MediaQuery.of(context).size.width*0.03),
//               /// P:30 R:50 T:30 and icon
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     "assets/svgs/scale.svg",
//                     height: MediaQuery.of(context).size.width * 0.04,
//                     color: AppColors.blackIconColor,
//                   ),
//                   ///   For Gap
//                   SizedBox(width: MediaQuery.of(context).size.width*0.005),
//                   ///   jULY 29,2023
//                   Text(AppString.completeDeliveryP30R50T30,
//                     style: AppTextStyles(context).completeDeliveryCommonTextStyle
//                   ),
//                   ///   For Gap
//                   SizedBox(width: MediaQuery.of(context).size.width*0.005),
//                   ///   Info icon
//                   SvgPicture.asset(
//                     "assets/svgs/info.svg",
//                     height: MediaQuery.of(context).size.width * 0.04,
//                     color: AppColors.blackIconColor,
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           ///   PDT 09:30AM, 120 miles and icons
//           Row(
//             children: [
//               ///   PDT 09:30AM and icon
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     "assets/svgs/stopwatch.svg",
//                     height: MediaQuery.of(context).size.width * 0.04,
//                     color: AppColors.blackIconColor
//                   ),
//
//                   SizedBox(width: MediaQuery.of(context).size.width*0.005),
//
//                   ///   PDT 09:30AM
//                   Text(AppString.completeDeliveryPDT0930AM,
//                     style: AppTextStyles(context).completeDeliveryCommonTextStyle
//                   ),
//                 ],
//               ),
//               SizedBox(width: MediaQuery.of(context).size.width*0.03),
//               ///   120 miles and icons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SvgPicture.asset(
//                     "assets/svgs/round-speed.svg",
//                     height: MediaQuery.of(context).size.width * 0.04,
//                     color: AppColors.blackIconColor
//                   ),
//                   SizedBox(width: MediaQuery.of(context).size.width*0.005),
//                   ///   120 miles
//                   Text(AppString.completeDelivery120Miles,
//                     style: AppTextStyles(context).completeDeliveryCommonTextStyle
//                   ),
//                   ///   For Gap
//                   SizedBox(width: MediaQuery.of(context).size.width*0.03),
//                   SvgPicture.asset(
//                     "assets/svgs/forklift.svg",
//                     height: MediaQuery.of(context).size.width * 0.04,
//                     color: AppColors.blackIconColor
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           ///   22H 30M and icon
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SvgPicture.asset(
//                 "assets/svgs/time.svg",
//                 height: MediaQuery.of(context).size.width * 0.04,
//                 color: AppColors.blackIconColor
//               ),
//               ///   For Gap
//               SizedBox(width: MediaQuery.of(context).size.width*0.005),
//               ///   22H 30M
//               Text(AppString.completeDelivery22H30M,
//                 style: AppTextStyles(context).completeDeliveryCommonTextStyle
//               ),
//             ],
//           ),
//           ///   Bethel WHS-Arcadia,LA, Origin Point and icons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SvgPicture.asset(
//                 "assets/svgs/location-3.svg",
//                 height: MediaQuery.of(context).size.width * 0.04,
//                 color: AppColors.blackIconColor
//               ),
//               SizedBox(width: MediaQuery.of(context).size.width*0.005),
//               ///   Bethel WHS-Arcadia,LA
//               Text(AppString.completeDeliveryBethelWHSArcadiaLA,
//                 style: AppTextStyles(context).completeDeliveryCommonTextStyle
//               ),
//               ///   Origin Point
//               Text(AppString.completeDeliveryOriginPoint,
//                 style: AppTextStyles(context).completeDeliveryOriginGreyColorTextStyle
//               ),
//             ],
//           ),
//           ///   Home Depot3, City, State , Last Drop-Off Location and Icons
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SvgPicture.asset(
//                 "assets/svgs/location-3.svg",
//                 height: MediaQuery.of(context).size.width * 0.04,
//                 color: AppColors.blackIconColor
//               ),
//               SizedBox(width: MediaQuery.of(context).size.width*0.005),
//               ///   Home Depot3, City, State
//               Text(AppString.completeDeliveryHomeDepot3CityState,
//                 style: AppTextStyles(context).completeDeliveryCommonTextStyle
//               ),
//               ///   Last Drop-Off Location
//               Text(AppString.completeDeliveryLastDropOffLocation,
//                 style: AppTextStyles(context).completeDeliveryOriginGreyColorTextStyle
//               ),
//             ],
//           ),
//           ///   Arrived at 6:00pm
//           Text(AppString.completeDeliveryArrivedAt6Pm,textAlign: TextAlign.left ,
//             style: AppTextStyles(context).completeDeliveryArrivedAtTextStyle
//           )
//         ],
//       ),
//     );
//   }
//   ///   Used for Camera, Signature and Notes icons
//   Widget cameraSignatureNotesIcons(BuildContext context){
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       padding: EdgeInsets.only(
//         bottom: MediaQuery.of(context).size.width*0.05,
//         top: MediaQuery.of(context).size.width*0.05
//       ),
//       decoration: BoxDecoration(
//         color: AppColors.themeCompleteDeliveryContainerBackGroundColor,
//           borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SizedBox(width: MediaQuery.of(context).size.width*0.02),
//           ///   Camera icon
//           DottedBorder(
//             color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
//             strokeWidth: AppDimen.width1, //thickness of dash/dots
//             dashPattern: [2,4],
//             child: Container(
//               height:MediaQuery.of(context).size.height*0.09,
//               width: MediaQuery.of(context).size.width*0.18,
//               color:AppColors.white,
//               padding: EdgeInsets.all(AppDimen.padding10),
//               child: SvgPicture.asset(
//                 "assets/icons/camera-fill.svg",
//                 color: AppColors.darkGreyIconColor,
//               ),
//             ),
//           ),
//           ///   Signature icon
//           DottedBorder(
//             color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
//             strokeWidth: AppDimen.width1, //thickness of dash/dots
//             dashPattern: [2,4],
//             child: Container(
//               height:MediaQuery.of(context).size.height*0.09,
//               width: MediaQuery.of(context).size.width*0.18,
//               color: AppColors.white,
//               padding: EdgeInsets.all(AppDimen.padding10),
//               child: SvgPicture.asset(
//                 "assets/icons/signature-20-filled.svg",
//                 color: AppColors.darkGreyIconColor,
//               ),
//             ),
//           ),
//
//           ///   Notes icon
//           DottedBorder(
//             color: AppColors.themeCompleteDeliveryContainerDottedBorderColor,
//             strokeWidth: AppDimen.width1, //thickness of dash/dots
//             dashPattern: [2,4],
//             child: Container(
//               height:MediaQuery.of(context).size.height*0.09,
//               width: MediaQuery.of(context).size.width*0.18,
//               color: AppColors.white,
//               padding: EdgeInsets.all(AppDimen.padding10),
//               child: SvgPicture.asset(
//                 "assets/icons/notes-bold.svg",
//                 color: AppColors.darkGreyIconColor,
//               )
//             ),
//           ),
//           ///   For Gap
//           SizedBox(width: MediaQuery.of(context).size.width*0.02),
//         ],
//       ),
//     );
//   }
// }