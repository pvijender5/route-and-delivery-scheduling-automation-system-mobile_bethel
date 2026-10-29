/// Extension `AppTextStyles` provides various text styles for UI components.
/// These styles are dynamically calculated based on the screen dimensions
/// and utilize predefined colors from `AppColors`.

import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:flutter/material.dart';

extension AppTextStyles on BuildContext {
  TextStyle get title =>
      TextStyle(fontSize: MediaQuery.of(this).size.height * 0.02, fontWeight: FontWeight.w500, color: Colors.black);

  TextStyle get signInButtonStyle => TextStyle(
      fontWeight: FontWeight.w800, fontSize: MediaQuery.of(this).size.height * 0.024, color: AppColors.btnTextColor);

  TextStyle get forgotPasswordButtonStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 0.025,
      fontWeight: FontWeight.w600,
      color: AppColors.forgotBtnBackgroundColor);

  TextStyle get notesSaveButtonStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 0.022, fontWeight: FontWeight.w800, color: AppColors.whiteColor);

  TextStyle get loadboardButtonStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 018, fontWeight: FontWeight.w600, color: AppColors.whiteColor);

  TextStyle get dashboardUsernameStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.05, fontWeight: FontWeight.w500, color: AppColors.textColorBlack);

  TextStyle get dashboardStaticText => TextStyle(
      color: AppColors().textGrayColor, fontWeight: FontWeight.w500, fontSize: MediaQuery.of(this).size.width * 0.04);

  TextStyle get dashboardShipmentPointsStyle =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.09, fontWeight: FontWeight.w500, color: AppColors.white);

  TextStyle get totalShipmentTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.03,
      fontWeight: FontWeight.w400,
      color: AppColors.fontTextWhiteColor);

  TextStyle get onTimeDeliveryPerformanceTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 0.016,
      color: AppColors.fontTextWhiteColor,
      fontWeight: FontWeight.w500);

  TextStyle get performancePercentTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.03,
      fontWeight: FontWeight.w700,
      color: AppColors.fontTextGreenColor);

  TextStyle get othersDriversSuccessTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextWhiteColor,
      fontSize: MediaQuery.of(this).size.height * 0.014);

  TextStyle get totalEarningsPointsTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 0.03,
      color: AppColors.fontTextWhiteColor,
      fontWeight: FontWeight.w500);

  TextStyle get totalEarningsTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextWhiteColor,
      fontSize: MediaQuery.of(this).size.height * 0.02);

  TextStyle get totalRoutesTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.04,
      fontWeight: FontWeight.w400,
      color: AppColors.fontTextWhiteColor);

  TextStyle get activeAndAssignedTabTextStyle =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.037, fontWeight: FontWeight.w700);

  TextStyle get dashboardDateTextStyle => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.of(this).size.height * 0.02,
        color: AppColors.fontTextGreyColor,
      );

  TextStyle get routeNoTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 0.024,
      fontWeight: FontWeight.w700,
      color: AppColors.fontRoooTextColor);

  TextStyle get notificationTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 0.013,
      fontWeight: FontWeight.w700,
      color: AppColors.fontRoooTextColor);

  TextStyle get routeInTransitTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextBlackColor,
      fontSize: MediaQuery.of(this).size.height * 0.015);

  TextStyle get routeDetailsTransitTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextBlackColor,
      fontSize: MediaQuery.of(this).size.width * 0.030);

  TextStyle get routeDetailsTransitTextStyle1 => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.031,
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextGreyColor);

  TextStyle get routesDropOffLocationTextStyle =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.029, fontWeight: FontWeight.w700, color: Colors.grey[800]);

  TextStyle get resendOtpTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.height * 0.016,
      fontWeight: FontWeight.w500,
      color: AppColors.fontResendOtpTextColor);

  TextStyle get titleLabel => TextStyle(
        fontSize: MediaQuery.of(this).size.width * 0.038,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontFamily: "Roboto",
      );

  TextStyle get titleLabelData => TextStyle(
        fontSize: MediaQuery.of(this).size.width * 0.035,
        fontWeight: FontWeight.normal,
        color: Colors.black87,
        fontFamily: "Roboto",
      );

  TextStyle get workDiaryStyle => TextStyle(
        fontSize: MediaQuery.of(this).size.width * 0.042,
        fontWeight: FontWeight.w600,
        color: AppColors.profileBorderColor,
        fontFamily: "Roboto",
      );

  TextStyle get helloUser => TextStyle(
        fontSize: MediaQuery.of(this).size.width * 0.050,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        fontFamily: "Roboto",
      );

  TextStyle get profileText => TextStyle(
        fontSize: MediaQuery.of(this).size.width * 0.035,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
        fontFamily: "Roboto",
      );

  TextStyle get logoutBtnStyle => TextStyle(
        fontSize: MediaQuery.of(this).size.width * 0.040,
        color: Colors.white,
      );

  TextStyle get otpTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextPurpleAccentColor,
      fontSize: MediaQuery.of(this).size.height * 0.04);

  TextStyle get inputHintTextStyle => TextStyle(
      color: const Color(0xffc1c1c2),
      fontWeight: FontWeight.w100,
      fontSize: MediaQuery.of(this).size.height * 0.018,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.6);

  TextStyle get inputLabelTextStyle => TextStyle(
      color: AppColors.fontTextBlackColor,
      fontWeight: FontWeight.w300,
      fontSize: MediaQuery.of(this).size.height * 0.018,

      ///AppDimen.screenHeight * 0.018,
      fontStyle: FontStyle.normal,
      letterSpacing: 0.6);

  TextStyle get inputTextStyle => TextStyle(
      color: const Color(0xff151516),
      fontWeight: FontWeight.w400,
      fontSize: MediaQuery.of(this).size.height * 0.018,

      ///AppDimen.screenHeight * 0.018,
      fontStyle: FontStyle.normal);

  ///   Home page Hello Nik text style
  TextStyle get helloNikTextStyle => TextStyle(
      color: AppColors.fontTextBlackColor,
      fontWeight: FontWeight.w400,
      fontSize: MediaQuery.of(this).size.width * 0.05,
      fontStyle: FontStyle.normal);

  ///   Home page Here are your routes
  TextStyle get hereAreYourRoutesTextStyle => TextStyle(
      color: AppColors().textGrayColor, fontWeight: FontWeight.w500, fontSize: MediaQuery.of(this).size.width * 0.04);

  ///   Thursday, june20,2023 text style
  TextStyle get thursdayJuneTextStyle => TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: MediaQuery.of(this).size.height * 0.02,
        color: AppColors.fontTextGreyColor,
      );

  ///   Home page Performance summary
  TextStyle get performanceSummaryTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: MediaQuery.of(this).size.height * 0.025,
      color: AppColors.fontTextBlackColor);

  ///   Home page Number text style
  TextStyle get numberTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.07,
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextWhiteColor);

  ///   Bold2 Text style
  TextStyle? bold2TextStyle(
      {Color? textColor,
      double? fontSize,
      FontWeight? fontWeight = FontWeight.w700,
      // double? letterSpacing,
      String fontFamily = "Roboto",
      FontStyle fontStyle = FontStyle.normal}) {
    return TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      // letterSpacing: letterSpacing
    );
  }

  ///   Bold3 Text style
  TextStyle? bold3TextStyle(
      {Color? textColor,
      double? fontSize,
      FontWeight? fontWeight = FontWeight.w500,
      // double? letterSpacing,
      String fontFamily = "Roboto",
      FontStyle fontStyle = FontStyle.normal}) {
    return TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      // letterSpacing: letterSpacing
    );
  }

  TextStyle get pickUpOrderTextStyle =>
      TextStyle(color: Colors.grey[500], fontWeight: FontWeight.w500, fontSize: MediaQuery.of(this).size.width * 0.034);

  ///   Bold4 Text style
  TextStyle? bold4TextStyle(
      {Color? textColor,
      double? fontSize,
      FontWeight? fontWeight = FontWeight.w500,
      // double? letterSpacing,
      String fontFamily = "Roboto",
      FontStyle fontStyle = FontStyle.normal}) {
    return TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      // letterSpacing: letterSpacing
    );
  }

  ///   Home page Tab bar textstyle
  TextStyle get tabBarTextStyle =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.033, fontWeight: FontWeight.w700);

  ///   Search page list view driver to vin text style
  TextStyle get driverToVinTextStyle => TextStyle(
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextBlackColor,
      fontSize: MediaQuery.of(this).size.width * 0.033);

  ///   Routes 3 found (Search page)
  TextStyle get routes3Found =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.035, fontWeight: FontWeight.w500, color: Colors.grey[600]);

  ///   Search text style
  TextStyle get searchText => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.06,
      fontWeight: FontWeight.w700,
      color: AppColors.fontTextBlackColor);

  ///   Selected Calender Text Style
  TextStyle get selectedCalenderTextStyle =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.05, fontWeight: FontWeight.w500, color: AppColors.black);

  ///   Active Calender Text Style
  TextStyle get activeCalenderTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.03,
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextWhiteColor);

  ///   InActive Calender Text Style
  TextStyle get inActiveCalenderTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.03,
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextBlackColor);

  ///   Hello Rob text style
  TextStyle get helloRobTextStyle =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.05, fontWeight: FontWeight.w500, color: Colors.black);

  ///   Merchandiser Interface Text Style
  TextStyle get merchandiserListTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.035,
      fontWeight: FontWeight.w500,
      color: AppColors.fontTextDarkGreyColor);

  ///   Merchandiser Hello Laura text style
  TextStyle get merchandiserHelloLauraTextStyle =>
      TextStyle(fontSize: MediaQuery.of(this).size.width * 0.05, fontWeight: FontWeight.w500, color: Colors.black);

  ///   Merchandiser Interface ROOOOI text
  TextStyle get merchandiserRoooiTextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.035,
      fontWeight: FontWeight.w600,
      color: AppColors.fontRoooTextColor);

  ///   Home screen, Thursday june date text style
  TextStyle get homeThursdayJuneDateTextStyle => TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: MediaQuery.of(this).size.height * 0.02,
      color: AppColors.fontTextGreyColor);

  ///   Route Detail Origin text used for Grey color
  TextStyle get routeDetailsOriginGreyColorTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.fontTextDarkGreyColor,
      fontSize: MediaQuery.of(this).size.width * 0.028);

  ///   Stop Detail Undelivered 06/29/2023 with red color
  TextStyle get stopDetailUndeliveredTextStyle => TextStyle(
      fontWeight: FontWeight.w700, color: AppColors.fontTextRedColor, fontSize: MediaQuery.of(this).size.width * 0.028);

  ///   Stop Detail SOO113 with black color
  TextStyle get stopDetailSoo113TextStyle => TextStyle(
      fontSize: MediaQuery.of(this).size.width * 0.05,
      fontWeight: FontWeight.w600,
      color: AppColors.fontTextBlackColor);

  ///   Stop Detail SOO113 with black color
  TextStyle get routeDetailsAndStopDetails =>
      TextStyle(color: Colors.black, fontSize: MediaQuery.of(this).size.width * 0.045, fontWeight: FontWeight.w600);

  ///   Complete Delivery Mark Complete FOr Stop and Delivery Requirements Text style
  TextStyle get markCompleteAndDeliveryRequirementsTextStyle =>
      TextStyle(color: Colors.black, fontSize: MediaQuery.of(this).size.width * 0.042, fontWeight: FontWeight.w600);

  ///   Complete Delivery Mark Complete FOr Stop and Delivery Requirements Text style
  TextStyle get collectProofOfDelivery => TextStyle(
      color: AppColors.textColorGreyDark,
      fontSize: MediaQuery.of(this).size.width * 0.030,
      fontWeight: FontWeight.w500);

  ///   Complete Delivery Common text style
  TextStyle get completeDeliveryCommonTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.fontTextBlackColor,
      fontSize: MediaQuery.of(this).size.width * 0.030);

  ///   Complete Delivery Arrived at 6:00 with green color text style
  TextStyle get completeDeliveryArrivedAtTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.fontTextDarkGreenColor,
      fontSize: MediaQuery.of(this).size.width * 0.035);

  ///   Complete Delivery Arrived at 6:00 with red color text style
  TextStyle get completeDeliveryLateArrivedAtTextStyle => TextStyle(
      fontWeight: FontWeight.w700, color: AppColors.fontTextRed1, fontSize: MediaQuery.of(this).size.width * 0.035);

  ///   Complete Delivery Origin text, Last Drop-off Location and 0 of 3 Completed, used for Grey color
  TextStyle get completeDeliveryOriginGreyColorTextStyle => TextStyle(
      fontWeight: FontWeight.w700,
      color: AppColors.fontTextDarkGreyColor,
      fontSize: MediaQuery.of(this).size.width * 0.028);

  ///   Complete Delivery Button Text style
  TextStyle get completeDeliveryButtonTextStyle => TextStyle(
      color: AppColors.themeWhiteColor, fontSize: MediaQuery.of(this).size.width * 0.042, fontWeight: FontWeight.w600);

  ///   Bold Text style
  TextStyle? boldTextStyle(
      {Color? textColor,
      double? fontSize,
      FontWeight? fontWeight = FontWeight.w900,
      // double? letterSpacing,
      String fontFamily = "Roboto",
      FontStyle fontStyle = FontStyle.normal}) {
    return TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      // letterSpacing: letterSpacing
    );
  }

  ///   Bold1 Text style
  TextStyle? bold1TextStyle(
      {Color? textColor,
      double? fontSize,
      FontWeight? fontWeight = FontWeight.w800,
      // double? letterSpacing,
      String fontFamily = "Roboto",
      FontStyle fontStyle = FontStyle.normal}) {
    return TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      // letterSpacing: letterSpacing
    );
  }

  ///   Normal text style
  TextStyle? normalTextStyle(
      {Color? textColor,
      double? fontSize,
      FontWeight? fontWeight = FontWeight.w400,
      // double? letterSpacing,
      String fontFamily = "Roboto",
      FontStyle fontStyle = FontStyle.normal}) {
    return TextStyle(
      color: textColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontFamily: fontFamily,
      fontStyle: fontStyle,
      // letterSpacing: letterSpacing
    );
  }
}
