/// A utility class containing various helper methods for common operations.
///
/// The `Utils` class provides static methods for tasks such as:
/// - Validating input (e.g., email, phone number, password).
/// - Formatting dates and times.
/// - Managing permissions for storage and notifications.
/// - Performing mathematical calculations.
/// - Handling file downloads and directory management.
/// - Displaying messages and dialogs.
/// - Working with map markers and geocoding.
///
/// This class is designed to simplify repetitive tasks and improve code reusability.

import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/core/app_dimens/app_dimens.dart';
import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:bethel_farm/modules/notifications/notifications_controller.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:bethel_farm/utils/logout_alert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../app/extensions/hexcolor.dart';
import '../core/app_string/app_strings.dart';
import '../data/model/response/geocode_address_result.dart';
import 'constants.dart';

class Utils {
  static Future openEmail({required String toEmail, required String subject, required String body}) async {
    final url = 'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    // launch url here  _launchUrl(url)  ;
  }

  static bool hasLowerCase(password) {
    return password.contains(RegExp(r'[a-z]'));
  }

  static bool hasUpperCase(password) {
    return password.contains(RegExp(r'[A-Z]'));
  }

  static bool hasDigitsCase(password) {
    return password.contains(RegExp(r'[0-9]'));
  }

  static bool isOnlyNum(String num) {
    final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(num);
  }

  static bool isEmail(String text) {
    final bool emailValid =
        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(text);
    return emailValid;
  }

  static bool checkPasswordAlphaNumeric(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    // output:
    // Vignesh123! : true
    // vignesh123 : false
    // VIGNESH123! : false
    // vignesh@ : false
    // 12345678? : false
    return regExp.hasMatch(value);
  }

  static bool passwordErrorMessage(String value) {
    String pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    // output:
    // Vignesh123! : true
    // vignesh123 : false
    // VIGNESH123! : false
    // vignesh@ : false
    // 12345678? : false
    return regExp.hasMatch(value);
  }

  static bool isValidPhoneNumber(String? value) =>
      RegExp(r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)').hasMatch(value ?? '');

  static String convertDateFormatDDMMYYYY(String inputDate) {
    // Parse the input date string
    final inputFormat = DateFormat('yyyy-MM-dd');
    final inputDateParsed = inputFormat.parse(inputDate);

    // Define the desired output date format
    final outputFormat = DateFormat('MM-dd-yyyy');

    // Format the parsed date to the desired format
    final outputDate = outputFormat.format(inputDateParsed.toLocal());

    return outputDate;
  }

  static String formatDateString(DateTime inputDate) {
    // Define the desired date format
    final format = DateFormat("MMM d, y");

    // Format the DateTime object as a string
    final formattedDate = format.format(inputDate.toLocal());

    return formattedDate;
  }

  static String formatUtcDateTime(String utcDateTimeString) {
    // Parse the UTC date and time string
    final utcDateTime = DateTime.parse(utcDateTimeString);

    // Define the desired date and time format
    final format = DateFormat("yyyy-MM-dd hh:mm a");

    // Format the UTC DateTime object as a string
    final formattedDateTime = format.format(utcDateTime.toLocal());

    return formattedDateTime;
  }

  static String trimTimeFromDate(String date) {
    final dateTime = DateTime.parse(date);
    final formats = DateFormat.jm();
    final formatedTime = formats.format(dateTime);
    return formatedTime;
  }

  static String formatUtcDateTimeWithOutAm(String utcDateTimeString) {
    // Parse the UTC date and time string
    final utcDateTime = DateTime.parse(utcDateTimeString);

    // Define the desired date and time format
    final format = DateFormat("yyyy-MM-dd hh:mm:ss");

    // Format the UTC DateTime object as a string
    final formattedDateTime = format.format(utcDateTime.toLocal());

    return formattedDateTime;
  }

  // Widget textButton(String text, Color color, double width, Color textColor) {
  //   return Container(
  //       height: AppDimen.unitHeight * 22,
  //       width: width,
  //       decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.circular(5))),
  //       child: Center(child: Text(text, textAlign: TextAlign.center, style: AppTextStyles(context).boldTextStyle(AppDimen.unitHeight * 8, textColor: textColor))));
  // }

/*  static showErrorToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }*/

  static void showInfoDialog(BuildContext context, text) {
    showDialog(
        context: context,
        builder: (context) {
          return LogoutAlert(true, text);
        });
  }

  static void showErrorMessage(String message) {
    /* Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.black,
        fontSize: 16.0);*/
    Get.snackbar("Error", message,
        isDismissible: true,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        forwardAnimationCurve: Curves.easeOutBack,
        // dismissDirection: SnackDismissDirection.HORIZONTAL,
        backgroundColor: Colors.redAccent);
  }

  static void showWarningMessage(String title, String message) {
    /*Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.yellow,
        textColor: Colors.black,
        fontSize: 16.0);*/
    Get.snackbar(title, message,
        isDismissible: true,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        forwardAnimationCurve: Curves.easeOutBack,
        // dismissDirection: SnackDismissDirection.HORIZONTAL,
        backgroundColor: Colors.deepOrangeAccent);
  }

  static void showSuccessMessage(String message) {
    /*Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.lightGreen,
        textColor: Colors.black,
        fontSize: 16.0);*/
    Get.snackbar("Success!", message,
        isDismissible: true,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        forwardAnimationCurve: Curves.easeOutBack,
        // dismissDirection: SnackDismissDirection.HORIZONTAL,
        backgroundColor: Colors.lightGreen);
  }

  static void showShortSuccessMessage(String title, String message) {
    Get.snackbar(title, message,
        isDismissible: true,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 1),
        forwardAnimationCurve: Curves.easeOutBack,
        // dismissDirection: SnackDismissDirection.HORIZONTAL,
        backgroundColor: Colors.lightGreen);
  }

  static void showNotificationMessage(String title, String message) {
    Get.snackbar(title, message,
        isDismissible: true,
        colorText: AppColors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
        // forwardAnimationCurve: Curves.easeOutBack,
        // dismissDirection: SnackDismissDirection.HORIZONTAL,
        backgroundColor: Colors.purple);
  }

  static double metersToMiles(double meters) {
    const double metersInAMile = 1609.344; // 1 mile = 1609.344 meters
    return meters / metersInAMile;
  }

  static String formatMinutes(int minutes) {
    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;

    String formattedTime = '${hours.toString().padLeft(2, '0')}H ${remainingMinutes.toString().padLeft(2, '0')}M';

    return formattedTime;
  }

  static String? roleIdString(int id) {
    switch (id) {
      case 2:
        return "Driver";
      case 3:
        return "Carrier-Owner";
      case 4:
        return "Sub-Driver";
      case 5:
        return "Merchandiser";
      case 7:
        return "Router";
      case 8:
        return "Loader";
      default:
        return "";
    }
  }

  static Widget commonFieldsStyle(BuildContext context, String fieldName, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            alignment: Alignment.centerLeft,
            width: MediaQuery.of(context).size.height * 0.13,
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.018),
            child: Text(fieldName,
                style: AppTextStyles(context)
                    .bold3TextStyle(fontSize: MediaQuery.of(context).size.width * 0.034, textColor: AppColors.black))),
        Container(
            margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.018),
            child: Text(":", textAlign: TextAlign.center, style: AppTextStyles(context).pickUpOrderTextStyle)),
        Flexible(
          child: Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.018),
              // width: MediaQuery.of(context).size.height * 0.13,
              child: Text(value, textAlign: TextAlign.left, style: AppTextStyles(context).pickUpOrderTextStyle)),
        ),
      ],
    );
  }

  Future<void> clear() async {
    await deleteCacheDir();
    await deleteAppDir();
  }

  Future<void> deleteCacheDir() async {
    Directory tempDir = await getTemporaryDirectory();
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteAppDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    if (appDocDir.existsSync()) {
      appDocDir.deleteSync(recursive: true);
    }
  }

  Widget commonAppBar(String titleText, BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, mainAxisSize: MainAxisSize.max, children: [
      ///  Title
      Flexible(
        child: Text(titleText,
            style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.05, fontWeight: FontWeight.w500, color: Colors.black)),
      ),

      ///   Notification icon
      notificationIconWidget(
          context: context, height: (MediaQuery.of(context).size.height * 0.035), color: AppColors.black),
    ]);
  }

  Widget commonBackArrowAppBar(String titleText, BuildContext context, {String? fromScreen}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ///   back icon
          InkWell(
            onTap: () {
              if (fromScreen != null) {
                // Get.delete<RouteDetailsController>();
              }
              Get.back(result: true);
            },
            child: Container(
                height: MediaQuery.of(context).size.width * 0.08,
                width: MediaQuery.of(context).size.width * 0.08,
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.015),
                decoration: BoxDecoration(
                    color: AppColors().green5, borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular50))),
                child: Icon(
                  Icons.arrow_back_ios,
                  size: MediaQuery.of(context).size.width * 0.05,
                  color: AppColors.blackIconColor,
                )),
          ),

          ///   Route Details
          Text(titleText,
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.05,
                  fontWeight: FontWeight.w500,
                  color: Colors.black)),

          ///   For gap
          // SizedBox(width: MediaQuery.of(context).size.width * 0.08),

          ///   Notification icon
          notificationIconWidget(
              context: context, height: (MediaQuery.of(context).size.height * 0.035), color: AppColors.black),
        ],
      ),
    );
  }

  //
  Widget notificationIconWidget({required BuildContext context, required double height, Color? color}) {
    var controller = Get.put(NotificationsController());
    return InkWell(
        onTap: () {
          controller.getNotifications();
          Get.toNamed(Routes.NOTIFICATION);
        },
        child: Stack(
          children: <Widget>[
            SvgPicture.asset("assets/svgs/bell.svg", height: height, color: color),
            Obx(() => ((controller.notificationList.value?.unreadCount ?? 0) > 0)
                ? Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                      child: Text(
                        '${(controller.notificationList.value?.unreadCount ?? 0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Container())
          ],
        ));
  }

  Color bgForStatus(String status, {required bool isPickUpOrder}) {
    switch (status) {
      case PLANNED:
        return HexColor("#ff9b06");
      case POSTED_TO_LOADBOARD: // Route is available for 3rd party drivers
        return HexColor("#ff9b06");
      case DRIVER_ASSIGNED: // Driver Assigned
        return HexColor("#674EA7");
      case NEW: // Assigned to Warehouse
        return HexColor("#674EA7");
      case ASSIGNED: // Loader Assigned
        return HexColor("#674EA7");
      case "Assigned Self-Loading": // Driver is Loader
        return HexColor("#674EA7");
      case LOADED: // Route loaded
        return (isPickUpOrder) ? HexColor("#38761d") : HexColor("#ea9999");
      case LOADING: // Loading in-progress
        return HexColor("#ea9999");
      case "Assigned-Self Loading": // Driver is Loader
        return HexColor("#ea9999");
      case "Completed": // Loading in-progress
        return HexColor("#38761d");
      case IN_TRANSIT_ON_TIME:
        return HexColor("#ffff00");
      case IN_TRANSIT_DELAY:
        return HexColor("#CF2A27"); // red
      case IN_TRANSIT_ARRIVED:
        return HexColor("#ffff00");
      case IN_TRANSIT_CANCELLED:
        return HexColor("#CF2A27");
      case DELIVERED: // Delivered
        return HexColor("#38761d");
      case COMPLETED: // Completed
        return HexColor("#009e0f");
      case NEW:
        return HexColor("#6FA8DC");
      case UNDELIVERED:
        return HexColor("#CF2A27");
      default:
        return Colors.yellow;
    }
  }

  bool bgIsYellow(String status) {
    switch (status) {
      case PLANNED:
        return false;
      case POSTED_TO_LOADBOARD: // Route is available for 3rd party drivers
        return false;
      case DRIVER_ASSIGNED: // Driver Assigned
        return false;
      case NEW: // Assigned to Warehouse
        return false;
      case ASSIGNED: // Loader Assigned
        return false;
      case "Assigned Self-Loading": // Driver is Loader
        return false;
      case LOADED: // Route loaded
        return false;
      case LOADING: // Loading in-progress
        return false;
      case "Assigned-Self Loading": // Driver is Loader
        return false;
      case IN_TRANSIT_ON_TIME:
        return true;
      case IN_TRANSIT_DELAY:
        return false;
      case IN_TRANSIT_ARRIVED:
        return true;
      case IN_TRANSIT_CANCELLED:
        return false;
      case DELIVERED: // Delivered
        return false;
      case COMPLETED: // Completed
        return false;
      case NEW:
        return false;
      case UNDELIVERED:
        return false;
      default:
        return true;
    }
  }

  Future<void> makePhoneCall(String url) async {
    print(">>> Make Phone Call >> $url");

    String mobile = url.replaceAll(RegExp('-'), '');
    print(">>> Make Phone Call >> $mobile");
    final Uri launchUri = Uri(scheme: 'tel', path: mobile);
    await launchUrl(launchUri);
  }

  static showETA(int content) {
    // int eta= content['eta'];
    // String pdt=DateFormat('hh:mm a').format(controller.routeDetail.value?.plannedDepartureTime??DateTime.now());
    // // Parse the start time
    // DateTime parsedStartTime = DateFormat('h:mm a').parse(pdt);
    //
    // // Add 136 minutes
    // DateTime updatedTime = parsedStartTime.add(Duration(minutes: eta));
    //
    // // Format the result with AM/PM
    // String formattedUpdatedTime = DateFormat('h:mm a').format(updatedTime);
  }
  String _localPath = "";
  //function to download pdf file
  downloadPdf(var documentUrl) async {
    print(documentUrl);
    _checkStoragePermission().then((value) async {
      if (value) {
        SmartDialog.showToast("${AppString.downloading}...");
        await _prepareSaveDir();
        print("Downloading");
        try {
          var timeStamp = DateTime.now().millisecondsSinceEpoch;
          await Dio().download(documentUrl, "$_localPath/BethelForm/$timeStamp/bethel_doc.pdf");
          SmartDialog.showToast(
              "${AppString.downloadCompletedFileSaveOnThisPath}\n$_localPath/BethelForm/$timeStamp+bethel_doc.pdf");
          OpenFile.open("$_localPath/BethelForm/$timeStamp/bethel_doc.pdf");
          print("Download Completed.");
        } catch (e) {
          SmartDialog.showToast("${AppString.downloadFailed}\n\n$e");
          print("Download Failed.\n\n$e");
        }
        SmartDialog.dismiss();
      }
    });
    // print(permissionReady);
  }

  //Function to check permission and request for permission
  Future<bool> _checkStoragePermission() async {
    if (Platform.isAndroid) {
      final manageStatus = await Permission.manageExternalStorage.status;
      final status = await Permission.storage.status;
      //Requesting "storage" permissions always returns "denied" on Android 13+ so we added manageExternalStorage in conditions
      if (manageStatus != PermissionStatus.granted || status != PermissionStatus.granted) {
        // final result = await Permission.manageExternalStorage.request();
        // final results = await Permission.storage.request();
        final Map<Permission, PermissionStatus> results = await [
          Permission.manageExternalStorage,
          Permission.storage,
        ].request();
        if (results[Permission.manageExternalStorage] == PermissionStatus.granted ||
            results[Permission.storage] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  //function to create directory path from device
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  //function to get local path
  Future<String?> _findLocalPath() async {
    if (Platform.isAndroid) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  //
  static Future<bool> checkPermissionsNotification() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final notificationStatus = await Permission.notification.status;

      // Check if any of the permissions is not granted
      if (notificationStatus != PermissionStatus.granted) {
        // Request both notification and location permissions
        final Map<Permission, PermissionStatus> results = await [
          Permission.notification,
        ].request();

        // Check if both permissions are granted
        if (results[Permission.notification] == PermissionStatus.granted) {
          return true;
        }
      } else {
        // Both permissions are already granted
        return true;
      }
    } else {
      // For non-Android platforms, return true as permissions are not needed
      return true;
    }

    // Return false if any permission is not granted
    return false;
  }

  static Future<bool> checkPermissionsLocation() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final locationStatus = await Permission.location.status;
      final locationWhen = await Permission.locationWhenInUse.status;
      final locationAlways = await Permission.locationAlways.status;

      if (locationStatus != PermissionStatus.granted ||
          locationWhen != PermissionStatus.granted ||
          locationAlways != PermissionStatus.granted) {
        final Map<Permission, PermissionStatus> results = await [
          Permission.locationAlways,
          Permission.locationWhenInUse,
          Permission.location,
        ].request();

        if (results[Permission.location] == PermissionStatus.granted ||
            results[Permission.locationWhenInUse] == PermissionStatus.granted ||
            results[Permission.locationAlways] == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }

    return false;
  }

  static double convertKilometersToMiles(double kilometers) {
    const double kilometersInOneMile = 1.60934;
    return kilometers / kilometersInOneMile;
  }

  static String formatTime(DateTime? dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime ?? DateTime.now());
  }

  static String formatUtcDateTimeSeconds(String utcDateTimeString) {
    // Parse the UTC date and time string
    final utcDateTime = DateTime.parse(utcDateTimeString);

    // Define the desired date and time format
    final format = DateFormat("yyyy-MM-dd hh:mm:ss");

    // Format the UTC DateTime object as a string
    final formattedDateTime = format.format(utcDateTime.toLocal());

    return formattedDateTime;
  }

  static String convertUtcToLocal(String utcDateString) {
    // Parse the UTC time string
    DateTime utcDateTime = DateTime.parse(utcDateString);

    // Convert to local time
    DateTime localDateTime = utcDateTime.toLocal();

    // Format the local time string (adjust the format as needed)
    String formattedLocalTime = DateFormat.yMd().add_Hms().format(localDateTime);
    DateTime dateTime = DateFormat('M/d/yyyy H:mm:ss').parse(formattedLocalTime);
    String dateTimeLocal = DateFormat('hh:mm a').format(dateTime);
    return dateTimeLocal;
  }

  static String convertUtcToLocalDateTime(DateTime utcDateString) {
    // Convert to local time
    DateTime localDateTime = utcDateString.toLocal();

    // Format the local time string (adjust the format as needed)
    String formattedLocalTime = DateFormat.yMd().add_Hms().format(localDateTime);
    DateTime dateTime = DateFormat('M/d/yyyy H:mm:ss').parse(formattedLocalTime);
    String dateTimeLocal = DateFormat('hh:mm a').format(dateTime);
    return dateTimeLocal;
  }

  static bool checkStatusForPDT(String status) {
    switch (status) {
      case PLANNED:
        return true;
      case POSTED_TO_LOADBOARD: // Route is available for 3rd party drivers
        return true;
      case DRIVER_ASSIGNED: // Driver Assigned
        return true;
      case NEW: // Assigned to Warehouse
        return true;
      case ASSIGNED: // Loader Assigned
        return true;
      case ASSIGNED_SELF_LOADING: // Driver is Loader
        return true;
      case LOADED: // Route loaded
        return true;
      case LOADING: // Loading in-progress
        return true;
      case "Assigned-Self Loading": // Driver is Loader
        return true;
      case IN_TRANSIT_ON_TIME:
        return false;
      case IN_TRANSIT_DELAY:
        return false;
      case IN_TRANSIT_ARRIVED:
        return true;
      case IN_TRANSIT_CANCELLED:
        return false;
      case DELIVERED: // Delivered
        return false;
      case COMPLETED: // Completed
        return false;
      case UNDELIVERED:
        return false;
      default:
        return false;
    }
  }

//Function to convert address to coordinates with here map
  Future<GeocodeResult?> geocodeAddress(String address, String apiKey) async {
    final url =
        Uri.parse('https://geocode.search.hereapi.com/v1/geocode?q=${Uri.encodeComponent(address)}&apiKey=$apiKey');

    print("Address: $address");
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          // Parse and return the result as a GeocodeResult object
          return GeocodeResult.fromJson(data['items'][0], address);
        } else {
          throw Exception('No geocoding result for: $address');
        }
      } else {
        throw Exception('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Geocoding error for $address: $error');
      return null;
    }
  }

  //function to create gesture on map to drag the map on touch
  Set<Factory<OneSequenceGestureRecognizer>> createGestureRecognizers() {
    return {
      Factory<OneSequenceGestureRecognizer>(
        () => PanGestureRecognizer()
          ..onUpdate = (details) {
            print('Pan Update: ${details.globalPosition}');
          },
      ),
      // Factory<OneSequenceGestureRecognizer>(
      //       () => TapGestureRecognizer()
      //     ..onTap = () {
      //       print('Tap detected on the map.');
      //     },
      // ),
    };
  }

  MapMarker createMarkerWithImagePath(
    GeoCoordinates coordinates,
    String imagePath,
    int width,
    int height, {
    int? drawOrder,
    Anchor2D? anchor,
  }) {
    MapImage mapImage = MapImage.withFilePathAndWidthAndHeight(imagePath, width, height);
    MapMarker mapMarker = createMarkerWithImage(coordinates, mapImage, drawOrder: drawOrder, anchor: anchor);
    return mapMarker;
  }

  /// Creates [MapMarker] in [coordinates] using an [image], [drawOrder] and [anchor].
  MapMarker createMarkerWithImage(
    GeoCoordinates coordinates,
    MapImage image, {
    int? drawOrder,
    Anchor2D? anchor,
  }) {
    MapMarker mapMarker = MapMarker(coordinates, image);
    if (drawOrder != null) {
      mapMarker.drawOrder = drawOrder;
    }
    if (anchor != null) {
      mapMarker.anchor = anchor;
    }

    return mapMarker;
  }

  double degreesToRadians(double degrees) {
    return degrees * (math.pi / 180.0);
  }

  double radiansToDegrees(double radians) {
    return radians * (180.0 / math.pi);
  }

  double calculateHeading(GeoCoordinates from, GeoCoordinates to) {
    double azimuth = math.atan2(
      math.sin(degreesToRadians(to.longitude - from.longitude)),
      math.cos(degreesToRadians(from.latitude)) * math.tan(degreesToRadians(to.latitude)) -
          math.sin(degreesToRadians(from.latitude)) * math.cos(degreesToRadians(to.longitude - from.longitude)),
    );

    return radiansToDegrees(azimuth);
  }
}
