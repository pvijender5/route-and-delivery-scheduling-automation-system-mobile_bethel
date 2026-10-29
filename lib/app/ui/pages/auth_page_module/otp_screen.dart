/// `OtpScreen` is a view class that represents the OTP verification screen.
/// It extends `BaseView` and uses `OtpController` for managing the state and logic.
/// The class includes:
/// - UI elements such as the logo and background image.
/// - A PIN code input field for entering the OTP.
/// - Buttons for verifying the OTP, resending the OTP, and navigating back.
/// - Dynamic text updates for the resend timer.
import 'package:bethel_farm/utils/exports.dart';
import 'package:bethel_farm/utils/utils.dart';
import 'package:flutter/material.dart';
import '../../../../core/app_text_styles/app_text_styles.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../base/base_view.dart';
import '../../../../../core/app_colors/app_colors.dart';
import '../../../../../core/app_dimens/app_dimens.dart';
import '../../../../../core/app_string/app_strings.dart';
import '../../../../../widgets/bethel_logo.dart';
import '../../../../../widgets/grass_image.dart';
import '../../../controllers/auth_module_controller/otp_ctrl.dart';

class OtpScreen extends BaseView<OtpController> {
  final otpController = Get.put(OtpController());
  final formKey = GlobalKey<FormState>();

  OtpScreen() {
    var data = Get.arguments;
    debugPrint("OTP Screen get arguments >> $data");
    controller.textEditingController.clear();
    controller.email = data;
    controller.otpCode.value = "";
  }

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        color: AppColors.themeWhiteColor,
        child: Column(children: [
          /// SVG Grass Image
          GrassImage.GrassImageview(context),

          /// Bethel Logo
          BethelIcon.BethelLogo(context),

          /// Static Text
          Container(
            height: MediaQuery.of(context).size.height * 0.075,
            width: MediaQuery.of(context).size.width * 0.85,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.018),
            child: Text(AppString.resendOtpText,
                textAlign: TextAlign.center, style: AppTextStyles(context).resendOtpTextStyle),
          ),

          ///Four Text Inputs For OTP
          Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),

              /// OTP Text Field
              child: PinCodeTextField(
                appContext: context,
                pastedTextStyle: TextStyle(
                  color: Colors.green.shade600,
                  fontWeight: FontWeight.bold,
                ),
                length: 4,
                obscureText: false,
                obscuringCharacter: '*',
                blinkWhenObscuring: true,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(AppDimen.circular7),
                    fieldHeight: MediaQuery.of(context).size.height * 0.08,
                    fieldWidth: MediaQuery.of(context).size.width * 0.165,
                    activeFillColor: AppColors.activeFillColor,
                    activeColor: AppColors.whiteColor,
                    activeBorderWidth: AppDimen.width1,
                    inactiveColor: AppColors.activeFillColor,
                    inactiveBorderWidth: AppDimen.width1,
                    inactiveFillColor: AppColors.whiteColor,
                    selectedFillColor: AppColors.whiteColor,
                    selectedColor: AppColors.whiteColor,
                    selectedBorderWidth: AppDimen.width1),
                // cursorColor: AppColor().red2,
                cursorColor: Colors.brown,
                cursorHeight: MediaQuery.of(context).size.width * 0.07,
                cursorWidth: AppDimen.width1_5,
                textStyle: TextStyle(
                    color: AppColors.otpTextColor,
                    fontWeight: FontWeight.w800,
                    fontSize: MediaQuery.of(context).size.width * 0.07),
                // animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                // errorAnimationController:otpController.errorController,
                controller: otpController.textEditingController,
                keyboardType: TextInputType.number,
                boxShadows: [
                  BoxShadow(offset: const Offset(0, 1), color: Colors.black12, blurRadius: AppDimen.circular50)
                ],
                onChanged: (value) {
                  debugPrint("otp  $value");
                  controller.otpCode.value = value;
                },
                onCompleted: (value) {
                  debugPrint("otp  $value");
                  controller.otpCode.value = value;
                },
                onTap: () {
                  print("Pressed");
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //                               //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
              ),
            ),
          ),

          ///Didn't Receive Email
          Container(
            width: MediaQuery.of(context).size.width * 85,
            height: MediaQuery.of(context).size.height * 0.02,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.002),
            child:
                Text(AppString.otpText1, textAlign: TextAlign.center, style: AppTextStyles(context).resendOtpTextStyle),
          ),

          ///You can resend in 15s
          Obx(
            () => Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width * 85,
              height: MediaQuery.of(context).size.height * 0.022,
              child: RichText(
                text: TextSpan(children: [
                  TextSpan(
                      text: AppString.youCanResendIn,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.033,
                          fontWeight: FontWeight.w500,
                          color: AppColors.fontResendOtpTextColor)),
                  TextSpan(
                      text: " ${controller.start.value} sec",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.032,
                          fontWeight: FontWeight.w800,
                          color: AppColors.forgotBtnBackgroundColor)),
                ]),
              ),
            ),
          ),

          ///Continue Button
          Obx(
            () => InkWell(
              onTap: () {
                if (controller.otpCode.value.isNotEmpty || controller.otpCode.value.length == 4) {
                  if (controller.otpCode.value.isEmpty || controller.otpCode.value.length <= 3) {
                  } else {
                    controller.verifyOtp();
                  }
                } else {
                  // Utils.showWarningMessage("Alert!", "Please Fill OTP");
                }
              },
              child: Container(
                alignment: Alignment.center,
                // height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.86,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.04),
                    bottomLeft: Radius.circular(MediaQuery.of(context).size.width * 0.04),
                    bottomRight: Radius.circular(MediaQuery.of(context).size.width * 0.04),
                  ),
                  color: (controller.otpCode.value.isEmpty || controller.otpCode.value.length <= 3)
                      ? AppColors.white_1
                      : AppColors.btnBackgroundColor,
                ),
                child: Text(AppString.continueButton, style: AppTextStyles(context).signInButtonStyle),
              ),
            ),
          ),

          ///Resend OTP
          Obx(
            () => InkWell(
              onTap: () {
                if (controller.start.value == 0) {
                  controller.otpCode.value = "";
                  controller.textEditingController.text = "";
                  controller.resendOtp();
                } else {
                  // controller.textEditingController.text = "";
                  // controller.otpCode.value = "";
                }
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.039),
                child: Text(AppString.resendOtp,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.025,
                        fontWeight: FontWeight.w600,
                        color: (controller.start.value == 0) ? AppColors.forgotBtnBackgroundColor : AppColors.white_1)),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.039),
            child: InkWell(
              onTap: () {
                controller.otpCode.value = "";
                controller.textEditingController.text = "";
                Get.back();
                controller.dispose();
              },
              child: Text(AppString.backButton.capitalizeFirst ?? "",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.025,
                      fontWeight: FontWeight.w600,
                      color: AppColors.forgotBtnBackgroundColor)),
            ),
          )
        ]),
      ),
    ));
  }
}
