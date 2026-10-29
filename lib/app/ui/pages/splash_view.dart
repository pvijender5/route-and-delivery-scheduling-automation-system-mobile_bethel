/// \[SplashScreen\] is a view that displays the splash screen of the application.
/// It includes a background image and the Bethel logo, styled and positioned using \[Stack\].
/// This class extends \[BaseView\] and uses \[SplashController\] for managing its logic.

import 'package:bethel_farm/core/app_assets/app_assets.dart';
import 'package:bethel_farm/app/controllers/splash_ctrl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../base/base_view.dart';
import '../../../../core/app_colors/app_colors.dart';

class SplashScreen extends BaseView<SplashController> {
  final ctrl = Get.put(SplashController());
  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    return null;
  }

  @override
  Widget body(BuildContext context) {
    hideKeyBoard(context);
    return Scaffold(
        backgroundColor: AppColors.themeWhiteColor,
        body: Stack(children: [
          /// Background Image
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: SvgPicture.asset(AppAssets.splashBgImagePath,
                  height: MediaQuery.of(context).size.height, fit: BoxFit.fitHeight)),

          /// Bethel Logo
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.25),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: SvgPicture.asset(AppAssets.splashLogoImagePath,
                      height: MediaQuery.of(context).size.height, fit: BoxFit.contain))),
        ]));
  }
}
