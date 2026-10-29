/// A widget that displays a logout confirmation alert.
///
/// The `LogoutAlert` widget can be used to show a confirmation dialog
/// when the user attempts to log out. It supports two modes:
/// - **Message Only Mode**: Displays a custom message without logout options.
/// - **Confirmation Mode**: Displays a confirmation dialog with "Confirm" and "Cancel" buttons.
///
/// Parameters:
/// - `showMessageOnly`: A boolean indicating whether to show only a message.
/// - `message`: A custom message to display in the alert.

import 'package:bethel_farm/app/controllers/account_module_controller/account_controller.dart';
import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LogoutAlert extends StatefulWidget {
  bool showMessageOnly = false;
  String message = "";

  LogoutAlert(this.showMessageOnly, this.message);

  @override
  State<LogoutAlert> createState() => _LogoutAlertState();
}

class _LogoutAlertState extends State<LogoutAlert> {
  final accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: (widget.showMessageOnly)
                  ? MediaQuery.of(context).size.height * 0.25
                  : MediaQuery.of(context).size.height * 0.41,
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.height * 0.03, right: MediaQuery.of(context).size.height * 0.03),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular20)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///   Please Confirm
                  Text((widget.showMessageOnly) ? AppString.alert : AppString.pleaseConfirm,
                      style: AppTextStyles(context).bold2TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.055, textColor: AppColors.black)),

                  ///   Circle Tick Check Mark Image
                  Visibility(
                      visible: !widget.showMessageOnly,
                      replacement: const SizedBox(),
                      child: Image.asset(AppAssets.circleTickCheckMark, height: 100, color: AppColors.greenIconColor)),
                  Text((widget.showMessageOnly) ? widget.message : AppString.areYouSureYouWantToLogout,
                      textAlign: TextAlign.center,
                      style: AppTextStyles(context).bold3TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.04, textColor: AppColors.black)),

                  ///   Confirm Button and Cancel Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ///   Confirm Button
                      Visibility(
                        visible: !widget.showMessageOnly,
                        replacement: const SizedBox(),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          // height: MediaQuery.of(context).size.height * 0.055,
                          margin: const EdgeInsets.only(right: 40.0),
                          decoration: BoxDecoration(
                              color: AppColors().green1,
                              borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                          child: MaterialButton(
                            child: Text(AppString.confirmButton,
                                style: AppTextStyles(context).bold3TextStyle(fontSize: 16, textColor: AppColors.white)),
                            onPressed: () {
                              accountController.logoutUser();
                            },
                          ),
                        ),
                      ),

                      ///   Cancel Button
                      Container(
                        width: MediaQuery.of(context).size.width * 0.28,
                        // height: MediaQuery.of(context).size.height * 0.055,
                        decoration: BoxDecoration(
                            color: AppColors().red1,
                            borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                        child: MaterialButton(
                          child: Text((widget.showMessageOnly) ? AppString.ok : AppString.cancelButton,
                              style: AppTextStyles(context).bold3TextStyle(fontSize: 16, textColor: AppColors.white)),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
