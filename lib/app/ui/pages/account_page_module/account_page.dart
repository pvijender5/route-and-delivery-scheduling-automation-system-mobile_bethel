/// [AccountPage] displays user account details and provides navigation to related features.
import 'package:bethel_farm/base/base_view.dart';
import 'package:bethel_farm/core/app_assets/app_assets.dart';
import 'package:bethel_farm/core/app_dimens/app_dimens.dart';
import 'package:bethel_farm/core/app_string/app_strings.dart';
import 'package:bethel_farm/data/enums/user_role.dart';
import 'package:bethel_farm/modules/dashboard/account/work_dairy/ctrl/work_dairy_ctrl.dart';
import 'package:bethel_farm/utils/logout_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../core/app_colors/app_colors.dart';
import '../../../../core/app_text_styles/app_text_styles.dart';
import '../../../../utils/exports.dart';
import '../../../../utils/utils.dart';
import '../../../controllers/account_module_controller/account_controller.dart';

class AccountPage extends BaseView<AccountController> {
  final accountController = Get.put(AccountController());

  @override
  PreferredSizeWidget? appBar(BuildContext context) {
    Get.lazyPut(() => AccountController());
    accountController.getUserDetail();
    return null;
  }

  @override
  Widget body(BuildContext context) {
    return Scaffold(
      // extendBody: true,
      // extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
      body: Obx(
        () => (accountController.userDetail.value.id == null)
            ? const SizedBox()
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.height * 0.02, right: MediaQuery.of(context).size.height * 0.02),
                child: RefreshIndicator(
                  displacement: 250,
                  backgroundColor: AppColors.themeDarkGreen1,
                  color: Colors.white,
                  strokeWidth: 3,
                  triggerMode: RefreshIndicatorTriggerMode.onEdge,
                  onRefresh: () async {
                    await controller.onRefresh();
                  },
                  child: Column(
                    children: [
                      Utils().commonAppBar("", context),
                      Container(
                          alignment: Alignment.bottomCenter,
                          color: Colors.transparent,
                          width: MediaQuery.of(context).size.width,
                          child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.black38,
                              child: SvgPicture.asset(
                                AppAssets.profileUserImage,
                                height: AppDimen.height40,
                                // height: MediaQuery.of(context).size.height * .80,
                              ))),
                      //Padding View
                      SizedBox(height: AppDimen.height10),
                      //Hello Msg View
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          '${AppString.hello}, ${accountController.userDetail.value.name.toString().capitalize}',
                          style: AppTextStyles(context).helloUser,
                        ),
                      ),
                      SizedBox(height: AppDimen.height5),
                      Container(
                          alignment: Alignment.bottomCenter,
                          child: Text(AppString.hereAreSomePersonalProfile, style: AppTextStyles(context).profileText)),
                      SizedBox(height: AppDimen.height10),
                      Expanded(
                        child: ListView(
                          children: [
                            Container(
                              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0)),
                                color: AppColors().green5,
                              ),
                              child: Column(
                                children: [
                                  Row(children: [
                                    Text(
                                        "${Utils.roleIdString(accountController.user.value.roleId ?? 0)} ${AppString.id}:  ",
                                        style: AppTextStyles(context).titleLabel),
                                    Text('${accountController.userDetail.value.id}',
                                        style: AppTextStyles(context).titleLabelData),
                                    SizedBox(width: AppDimen.height50),
                                    Text('${AppString.status}: ', style: AppTextStyles(context).titleLabel),
                                    Text('${accountController.userDetail.value.status}',
                                        style: AppTextStyles(context).titleLabelData)
                                  ]),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        '${AppString.emailId}:  ',
                                        style: AppTextStyles(context).titleLabel,
                                      ),
                                      Text('${accountController.userDetail.value.email}',
                                          style: AppTextStyles(context).titleLabelData),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        '${AppString.contactNo}:  ',
                                        style: AppTextStyles(context).titleLabel,
                                      ),
                                      Text(accountController.userDetail.value.primaryContactNumber ?? "N/A",
                                          style: AppTextStyles(context).titleLabelData),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text(
                                        '${AppString.role}:  ',
                                        style: AppTextStyles(context).titleLabel,
                                      ),
                                      Text('${Utils.roleIdString(accountController.user.value.roleId ?? 0)}',
                                          style: AppTextStyles(context).titleLabelData),
                                    ],
                                  ),

                                  Visibility(
                                    visible: Utils.roleIdString(accountController.user.value.roleId ?? 0) == "Loader",
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Row(
                                        children: [
                                          Text('${AppString.warehouseAssigned}:  ',
                                              style: AppTextStyles(context).titleLabel),
                                          Text(accountController.userDetail.value.wareHouseName?.wareHouseName ?? "N/A",
                                              style: AppTextStyles(context).titleLabelData),
                                        ],
                                      ),
                                    ),
                                  ),

                                  /// Work Dairy Option
                                  (accountController.user.value.roleId == 5 || accountController.user.value.roleId == 8)
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.only(top: 5, bottom: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${AppString.truckUnit}:  ',
                                                style: AppTextStyles(context).titleLabel,
                                              ),
                                              Text(
                                                  accountController
                                                          .userDetail.value.driverDetail?.truck?.truckModelName ??
                                                      "NA",
                                                  style: AppTextStyles(context).titleLabelData),
                                            ],
                                          ),
                                        ),

                                  (accountController.user.value.roleId == 5 || accountController.user.value.roleId == 8)
                                      ? const SizedBox()
                                      : Container(
                                          margin: const EdgeInsets.only(bottom: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                '${AppString.vin}:  ',
                                                style: AppTextStyles(context).titleLabel,
                                              ),
                                              Text(accountController.userDetail.value.driverDetail?.truck?.vin ?? "NA",
                                                  style: AppTextStyles(context).titleLabelData),
                                            ],
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            // Work Diary

                            SizedBox(
                              height: 40,
                            ),

                            (accountController.user.value.roleId == 4 ||
                                    accountController.user.value.roleId == 5 ||
                                    accountController.user.value.roleId == 8)
                                ? const SizedBox()
                                : InkWell(
                                    onTap: () {
                                      if (accountController.roleId == UserRole.CARRIER_OWNER.name) {
                                        WorkDairyController().to.getCOWorkDetail();
                                        Get.toNamed(Routes.CARRIER_OWNER_WORK_DAIRY);
                                      } else {
                                        WorkDairyController().to.getDriverWorkDetail();
                                        Get.toNamed(Routes.DRIVER_WORK_DAIRY);
                                      }
                                    },
                                    child: Container(
                                      //padding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                                      // margin: const EdgeInsets.only(top: 40, bottom: 20),
                                      width: MediaQuery.of(context).size.width * 0.90,
                                      height: AppDimen.height55,
                                      //color: Colors.cyan,
                                      decoration: BoxDecoration(
                                          border: Border.all(color: AppColors.profileBorderColor, width: 1),
                                          borderRadius: const BorderRadius.all(Radius.circular(10))),

                                      child: Row(
                                        children: [
                                          SizedBox(width: AppDimen.width35),

                                          // SvgPicture.asset(

                                          //   AppAssets.fileImage,

                                          //   height: MediaQuery.of(context).size.height * .035,

                                          //   width: AppDimen.width25,

                                          // ),

                                          SizedBox(
                                            width: AppDimen.width10,
                                          ),

                                          Text(
                                            AppString.workDiary,
                                            style: AppTextStyles(context).workDiaryStyle,
                                          ),

                                          Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                            color: Colors.transparent,
                                            height: AppDimen.height30,
                                            width: MediaQuery.of(context).size.width * 0.55,
                                            child: CircleAvatar(
                                              radius: 30,
                                              backgroundColor: AppColors.profileArrowBtnBgColor,
                                              child: SvgPicture.asset(AppAssets.workArrowImage),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            // Customer location and store assigned
                            SizedBox(height: AppDimen.height20),

                            /// merchandiser = 5
                            accountController.user.value.roleId == 5
                                ? Text("${AppString.customerLocationStoreAssigned}:",
                                    style: AppTextStyles(context).bold3TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.043,
                                        textColor: AppColors.black))
                                : const SizedBox(),

                            ///   For Gap
                            ///   merchandiser = 5
                            accountController.user.value.roleId == 5
                                ? SizedBox(height: MediaQuery.of(context).size.height * 0.015)
                                : const SizedBox(),

                            ///   Container for Customer Name and Location/Store Address
                            /// merchandiser = 5
                            accountController.user.value.roleId == 5
                                ? Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(
                                        left: MediaQuery.of(context).size.width * 0.015,
                                        right: MediaQuery.of(context).size.width * 0.015,
                                        top: MediaQuery.of(context).size.width * 0.02,
                                        bottom: MediaQuery.of(context).size.width * 0.02),
                                    decoration: BoxDecoration(
                                        color: AppColors().red5,
                                        borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.25,
                                          child: Text(
                                            AppString.customerName,
                                            style: AppTextStyles(context).bold3TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * 0.033,
                                                textColor: AppColors().red1),
                                          ),
                                        ),

                                        ///   Shipment
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.45,
                                          child: Text(
                                            AppString.locationStoreAddress,
                                            style: AppTextStyles(context).bold3TextStyle(
                                                fontSize: MediaQuery.of(context).size.width * 0.033,
                                                textColor: AppColors().red1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),

                            ///   For Gap
                            accountController.user.value.roleId == 5
                                ? SizedBox(height: MediaQuery.of(context).size.height * 0.015)
                                : const SizedBox(),
                            accountController.user.value.roleId == 5
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.customerLocationList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context, int index) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
                                        padding: EdgeInsets.only(
                                          left: MediaQuery.of(context).size.width * 0.015,
                                          right: MediaQuery.of(context).size.width * 0.015,
                                          top: MediaQuery.of(context).size.width * 0.01,
                                          bottom: MediaQuery.of(context).size.width * 0.02,
                                        ),
                                        decoration: BoxDecoration(
                                            color: AppColors().green5,
                                            borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            ///   Customer name
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.25,
                                              child: Text(controller.customerLocationList[index].customer?.name ?? "",
                                                  style: AppTextStyles(context).bold3TextStyle(
                                                      fontSize: MediaQuery.of(context).size.width * 0.03,
                                                      textColor: AppColors.black)),
                                            ),
                                            const SizedBox(width: 5),

                                            ///   Shipment Point 10
                                            Flexible(
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width * 0.45,
                                                child: Text(
                                                    "${controller.customerLocationList[index].deliveryLocationName}/${controller.customerLocationList[index].deliveryLocationAddressLine1 ?? ""},${controller.customerLocationList[index].deliveryLocationCity ?? ""},${controller.customerLocationList[index].deliveryLocationState ?? ""},${controller.customerLocationList[index].deliveryLocationZipcode ?? ""}",
                                                    style: AppTextStyles(context).bold3TextStyle(
                                                        fontSize: MediaQuery.of(context).size.width * 0.03,
                                                        textColor: AppColors.black)),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    })
                                : const SizedBox().marginZero
                            // accountController.user.value.roleId == 5 ?

                            // CustomerLocationList() : const SizedBox(),
                          ],
                        ),
                      ),

                      // Logout Button
                      Container(
                          margin: const EdgeInsets.only(left: 20, right: 20, bottom: 0, top: 10),
                          decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10))),
                          width: MediaQuery.of(context).size.width,
                          // height: MediaQuery.of(context).size.width * 0.10,
                          //color: AppColors.profile button bgColor,
                          child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return LogoutAlert(false, "");
                                    });
                              },
                              style: TextButton.styleFrom(backgroundColor: AppColors.profilebuttonbgColor),
                              child: Text(AppString.logOutButton, style: AppTextStyles(context).logoutBtnStyle))),
                      const SizedBox(height: 5.0),
                      Text('version 0.1.22', style: AppTextStyles(context).profileText),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
