/// `LoginPage` is a view class that represents the login screen of the application.
/// It extends `BaseView` and uses `LoginPageController` for managing the state and logic.
/// The class includes:
/// - A form for user authentication with email and password fields.
/// - Buttons for signing in and navigating to the forgot password screen.
/// - UI elements such as the logo and background image
import 'package:bethel_farm/base/base_view.dart';
import 'package:bethel_farm/core/app_assets/app_assets.dart';
import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/core/app_decoration/app_decoration.dart';
import 'package:bethel_farm/core/app_string/app_strings.dart';
import 'package:bethel_farm/app/controllers/auth_module_controller/login_ctrl.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../utils/utils.dart';
import '../../../../core/app_text_styles/app_text_styles.dart';
import '../../../../modules/auth/forgot_pass/forgot_pass.dart';

class LoginPage extends BaseView<LoginPageController> {
  final _formKey = GlobalKey<FormState>();

  /// base Appbar
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    Get.lazyPut(() => LoginPageController());
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Column(
                children: [
                  /// SVG Grass Image
                  SizedBox(
                      height: MediaQuery.of(context).size.height * 0.43,
                      width: MediaQuery.of(context).size.width,
                      child: SvgPicture.asset(AppAssets.loginTopImagePath,
                          height: MediaQuery.of(context).size.height, fit: BoxFit.fill)),

                  ///Bethel Logo
                  Container(
                      alignment: Alignment.center,
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: SvgPicture.asset(AppAssets.splashLogoImagePath,
                              height: MediaQuery.of(context).size.height, fit: BoxFit.contain))),

                  Container(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.08,
                        right: MediaQuery.of(context).size.width * 0.08,
                        top: MediaQuery.of(context).size.width * 0.08),
                    margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.03),
                    child: Column(children: [
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            /// Username input box
                            TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return AppString.emptyEmailField;
                                } else if (Utils.isEmail(value)) {
                                  return null; // Valid email
                                } else if (Utils.isValidPhoneNumber(value)) {
                                  return null; // Valid mobile number
                                } else {
                                  return AppString.emailIsNotValid;
                                }
                              },
                              textAlignVertical: TextAlignVertical.center,
                              style: AppTextStyles(context).title,
                              decoration: AppDecorations.emailInputDecorations(AppString.emailHintText, context),
                              onChanged: (value) {
                                _formKey.currentState!.validate();
                              },
                              autofocus: false,
                              controller: controller.emailTextController,
                            ),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),

                            /// Password input box
                            Obx(
                              () => TextFormField(
                                  obscureText: controller.passEnable.value,
                                  textInputAction: TextInputAction.next,
                                  // maxLength: 8,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppString.passwordNotBeEmpty;
                                    }
                                    // else if (value.length < 8) {
                                    //   return AppString.passwordLength;
                                    // }
                                    return null;
                                  },
                                  // obscureText: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  style: AppTextStyles(context).inputTextStyle,
                                  decoration: AppDecorations.passwordInputDecorations(
                                    AppString.passwordHintText,
                                    context,
                                    controller.passEnable.value,
                                    () {
                                      controller.passEnable.value = !controller.passEnable.value;
                                      controller.update();
                                    },
                                  ),
                                  onChanged: (value) {
                                    _formKey.currentState!.validate();
                                  },
                                  controller: controller.passwordTextController),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.02,
                            ),
                          ])),

                      ///Sign In Button
                      InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            hideKeyBoard(context);
                            controller.loginUser();
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          // height: MediaQuery.of(context).size.height * 0.06,
                          width: MediaQuery.of(context).size.width * 0.86,
                          padding: EdgeInsets.all(12),
                          // margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(MediaQuery.of(context).size.width * 0.04),
                              bottomLeft: Radius.circular(MediaQuery.of(context).size.width * 0.04),
                              bottomRight: Radius.circular(MediaQuery.of(context).size.width * 0.04),
                            ),
                            color: AppColors.btnBackgroundColor,
                          ),
                          child: Text(AppString.signInButton, style: AppTextStyles(context).signInButtonStyle),
                        ),
                      ),

                      ///Forgot Password Button
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
                        child: InkWell(
                          onTap: () {
                            controller.emailTextController.clear();
                            controller.passwordTextController.clear();
                            Get.to(() => ForgotPassword());
                          },
                          child: Text(AppString.loginForgotPassword,
                              style: AppTextStyles(context).forgotPasswordButtonStyle),
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
