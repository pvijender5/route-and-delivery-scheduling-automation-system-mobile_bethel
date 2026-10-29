/// `AppDecorations` class provides reusable decoration styles for input fields,
/// such as email and password text fields, ensuring consistent UI design across the application.

import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/core/app_dimens/app_dimens.dart';
import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppDecorations {
  /// Email Text Field Decoration
  static InputDecoration emailInputDecorations(String hintText, BuildContext context) {
    // var inputLabelTextStyle;
    return InputDecoration(
      errorMaxLines: 8,
      border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      filled: true,
      fillColor: Colors.white.withOpacity(AppDimen.width0_79),
      // hintText: hintText,
      labelText: hintText,
      labelStyle: AppTextStyles(context).inputLabelTextStyle,
      contentPadding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
        top: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.06,
        bottom: MediaQuery.of(context).size.width * 0.04,
      ),
      //contentPadding: EdgeInsets.symmetric(
      //  vertical: screenHeight(context) * 0.026,
      // horizontal: 10.0),
      // contentPadding: EdgeInsets.fromLTRB(15, screenHeight * 0.018 * 2, 15, screenHeight * 0.018 *2),
      enabledBorder: OutlineInputBorder(
          gapPadding: AppDimen.padding1,
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      // border: const OutlineInputBorder(),
    );
  }

  /// Password Text Field Decoration
  static InputDecoration passwordInputDecorations(
    String hintText,
    BuildContext context,
    bool passwordVisible,
    VoidCallback togglePasswordVisibility,
  ) {
    return InputDecoration(
      errorMaxLines: 8,
      border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      filled: true,
      fillColor: Colors.white.withOpacity(AppDimen.width0_79),
      labelText: hintText,
      labelStyle: AppTextStyles(context).inputLabelTextStyle,
      contentPadding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.06,
        top: MediaQuery.of(context).size.width * 0.04,
        right: MediaQuery.of(context).size.width * 0.06,
        bottom: MediaQuery.of(context).size.width * 0.04,
      ),
      suffixIcon: InkWell(
        onTap: togglePasswordVisibility,
        child: Icon(
          // Based on passwordVisible state choose the icon
          passwordVisible ? Icons.visibility : Icons.visibility_off,
          color: AppColors.themeDarkGreen1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
          gapPadding: AppDimen.padding1,
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimen.circular10),
          borderSide: BorderSide(color: AppColors.inputFieldBorderColor, width: AppDimen.width2)),
      // border: const OutlineInputBorder(),
    );
  }
}
