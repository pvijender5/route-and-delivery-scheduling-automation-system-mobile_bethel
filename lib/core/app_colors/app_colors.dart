/// A utility class that defines various color constants used throughout the application.
///
/// This class provides a centralized location for managing color values,
/// ensuring consistency and ease of maintenance across the app.

import 'package:bethel_farm/app/extensions/hexcolor.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const buttonDarkColor = Color(0xFFFFFFFF);

  // static const buttonLightColor = Color(0xFF7E7E7E);
  static Color primary = HexColor("05101A");
  static Color lightGray = HexColor("D3D3D3");

  /// Colors constants
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xff151516);

  static const Color yellow = Colors.yellow;
  static const Color transparentColor = Colors.transparent;
  static var white_1 = const Color(0xff9a9a9a);

  ///Input Field Border color
  static const inputFieldBorderColor = Color(0xFFe5e5e5);

  /// OTP ActiveFillColor
  static const activeFillColor = Color(0xFFd7b8be);

  /// White color
  static const whiteColor = Color(0xFFe5e5e5);

  ///SignIn Button Background Color
  static const btnBackgroundColor = Color(0xFF415b2a);

  ///SignIn Text Color
  static const btnTextColor = Colors.white;

  ///Forgot Password Background Color
  static const forgotBtnBackgroundColor = Color(0xFF7d2326);

  ///Resend Otp Text Color
  static const fontResendOtpTextColor = Color(0xFF8b8d8d);

  ///OTP Input Field Inner Color
  static const otpInputInnerColor = Color(0xFFead8da);

  ///OTP 15s color
  static const otpSecColor = Colors.red;

  /// OTP Text Color
  static const otpTextColor = Color(0xFF7d2326);

  ///   Theme Color
  static const themeWhiteColor = Color(0xFFFFFFFF);
  static const themeGreen1Color = Color(0xFF608339);
  static const themeRed1 = Color(0xFF7d2326);
  static const themeDarkGreen1 = Color(0xFF415b2a);
  static const themeGreen2 = Color(0xFF9ab476);
  static const themeCompleteDeliveryContainerBackGroundColor = Color(0xffe1e1e1);
  static const themeCompleteDeliveryContainerDottedBorderColor = Color(0xffb2b1b1);

  ///   Icons Color
  static const greenIconColor = Colors.green;
  static const grayIconColor = Colors.grey;
  static const darkGreyIconColor = Color(0xff7c7878);
  static const blackIconColor = Colors.black;

  ///  Font Color
  static const fontTextWhiteColor = Color(0xFFFFFFFF);
  static const fontTextGreenColor = Colors.green;
  static const fontTextDarkGreenColor = Color(0xff0aa34f);
  static const fontTextGreyColor = Colors.grey;
  static const fontTextDarkGreyColor = Color(0xff7c7878);
  static const fontTextRedColor = Color(0xffd74b4b);
  static const fontRoooTextColor = Color(0xFFca8c54);
  static const fontTextBlackColor = Colors.black;
  static const fontTextPurpleAccentColor = Colors.purpleAccent;
  static const fontTextRed1 = Color(0xFF7d2326);
  static const fontTextDarkGreen1 = Color(0xFF415b2a);
  static const fontTextGreen1Color = Color(0xFF608339);

  ///   Progress line color
  static const completeProgressLineColor = Color(0xff95dc55);
  static const pendingProgressLineColor = Color(0xffdbe7d0);

  var green1 = const Color(0xFF608339);
  var green2 = const Color(0xFF92a673);
  var green3 = const Color(0xFFb6c4a7);
  var green4 = const Color(0xFFd1d7c1);
  var green5 = const Color(0xFFe5ebe0);

  var golden1 = const Color(0xffe77107);
  var golden2 = const Color(0xFFca8c54);
  var golden3 = const Color(0xffbd9066);
  var golden4 = const Color(0xffa27d5b);
  var golden5 = const Color(0xffe8b281);

  var yellow1 = const Color(0xFFFFF049);
  var yellow2 = const Color(0xFFF8EC65);
  var yellow3 = const Color(0xFFADA974);
  var yellow4 = const Color(0xFFF1EAA0);
  var yellow5 = const Color(0xFFF6F1B7);

  var gray = const Color(0xFF6D6D71);
  var textGrayColor = const Color(0xff8b8d8d);
  // var green2 = const Color(0xFF9ab476);
  var inTransitBackGroundColor = const Color(0xFFFFF049);

  static const Color profileBorderColor = Color(0xFF547433);
  static const Color profilebuttonbgColor = Color(0xFF7D2325);
  static const Color profileArrowBtnBgColor = Color(0xFFE4E7EA);

  /// lsjdhfkjhdsf
  // static const Color pageBackground = Color(0xFFFAFBFD);
  static const Color pageBackground = Color(0xFFFFFFFF);
  static const Color statusBarColor = Color(0xFF38686A);
  static const Color appBarColor = Color(0xFF38686A);
  static const Color appBarIconColor = Color(0xFFFFFFFF);
  static const Color appBarTextColor = Color(0xFFFFFFFF);
  static const Color centerTextColor = Colors.grey;
  static const MaterialColor colorPrimarySwatch = Colors.cyan;
  static const Color colorPrimary = Color(0xFF38686A);
  static const Color colorAccent = Color(0xFF38686A);
  static const Color colorLightGreen = Color(0xFF00EFA7);
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color lightGreyColor = Color(0xFFC4C4C4);
  static const Color errorColor = Color(0xFFAB0B0B);
  static const Color colorDark = Color(0xFF323232);
  static const Color buttonBgColor = colorPrimary;
  static const Color disabledButtonBgColor = Color(0xFFBFBFC0);
  static const Color defaultRippleColor = Color(0x0338686A);
  static const Color textColorPrimary = Color(0xFF323232);
  static const Color textColorSecondary = Color(0xFF9FA4B0);
  static const Color textColorTag = colorPrimary;
  static const Color textColorGreyLight = Color(0xFFABABAB);
  static const Color textColorGreyDark = Color(0xFF979797);
  static const Color textColorBlueGreyDark = Color(0xFF939699);
  static const Color textColorCyan = Color(0xFF38686A);
  static const Color textColorWhite = Color(0xFFFFFFFF);
  static Color searchFieldTextColor = const Color(0xFF323232).withOpacity(0.5);
  static const Color iconColorDefault = Colors.grey;
  static Color barrierColor = const Color(0xFF000000).withOpacity(0.5);
  static Color timelineDividerColor = const Color(0x5438686A);
  static const Color gradientStartColor = Colors.black87;
  static const Color gradientEndColor = Colors.transparent;
  static const Color silverAppBarOverlayColor = Color(0x80323232);
  static const Color switchActiveColor = colorPrimary;
  static const Color switchInactiveColor = Color(0xFFABABAB);
  static Color elevatedContainerColorOpacity = Colors.grey.withOpacity(0.5);
  static const Color suffixImageColor = Colors.grey;
  static const Color textColorBlack = Colors.black;

  var gray1 = const Color(0xFF5A5A5B);
  var gray2 = const Color(0xFF7D7D7E);
  var gray3 = const Color(0xFFA0A0A4);
  var gray4 = const Color(0xFFC5C5C7);
  var gray5 = const Color(0xFFE2E2E3);

  var red1 = const Color(0xFF7d2326);
  var red2 = const Color(0xFF9e6163);
  var red3 = const Color(0xFFc5999a);
  var red4 = const Color(0xFFd7b8be);
  var red5 = const Color(0xFFe8dcdc);
  var darkGreen1 = const Color(0xFF415b2a);
  var darkGreen2 = const Color(0xFF7a8866);
  var darkGreen3 = const Color(0xFFa8b59e);
  var darkGreen4 = const Color(0xFFc4cbbd);
  var darkGreen5 = const Color(0xFFe0e6db);

  var liteGreen1 = const Color(0xFF9ab476);
  var liteGreen2 = const Color(0xFFb7c89f);
  var liteGreen3 = const Color(0xFFcfddc1);
  var liteGreen4 = const Color(0xFFdfe7d5);
  var liteGreen5 = const Color(0xFFf0f0ea);
}
