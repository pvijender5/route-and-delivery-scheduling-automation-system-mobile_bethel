/// The `DashboardController` class manages the dashboard functionality.
/// It handles user role initialization, navigation between different views,
/// bubble count retrieval, and application exit confirmation.
/// This controller interacts with the repository for API calls and manages
/// user preferences using `PreferenceManager`.

import 'dart:io' show Platform, exit;

import 'package:bethel_farm/base/base_controller.dart';
import 'package:bethel_farm/core/app_colors/app_colors.dart';
import 'package:bethel_farm/data/local/preference_manager.dart';
import 'package:bethel_farm/data/model/common/common_user.dart';
import 'package:bethel_farm/data/model/response/bubble_count_response.dart';
import 'package:bethel_farm/data/remote/repositories/repository.dart';
import 'package:bethel_farm/data/remote/repositories/repository_impl.dart';
import 'package:bethel_farm/modules/carrier_owner/carrier_owner/view/carrier_owner.dart';
import 'package:bethel_farm/modules/carrier_owner/load_board/load_board_view.dart';
import 'package:bethel_farm/modules/carrier_owner/sub_driver/view/home_sub_driver.dart';
import 'package:bethel_farm/app/ui/pages/account_module/account_page.dart';
import 'package:bethel_farm/app/ui/pages/my_load_page_module/my_load_view.dart';
import 'package:bethel_farm/app/ui/pages/driver_page/home_driver.dart';
import 'package:bethel_farm/modules/loader/home_loader/view/home_loader.dart';
import 'package:bethel_farm/modules/loader/pickup_orders/view/pickup_order_list.dart';
import 'package:bethel_farm/modules/merchandiser/view/home_merchandiser_interface.dart';
import 'package:bethel_farm/app/ui/pages/search_page_module/search_page.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

import '../../../../core/app_text_styles/app_text_styles.dart';
import '../../../core/app_string/app_strings.dart';
import '../../../modules/loader/warehouse_loads/view/warehouse_load_list.dart';
import '../../../modules/merchandiser/view/merchandiser_shipment.dart';

class DashboardController extends BaseController {
  final PreferenceManager _preferenceManager = getx.Get.find(tag: (PreferenceManager).toString());

  RxInt selectedIndex = 0.obs;
  Rx<User?> usr = null.obs;
  RxString userRole = "".obs;
  RxBool isKeyboardVisible = false.obs; // (WidgetsBinding.instance.window.viewInsets.bottom < 0.0)
  final Repository _repository = Get.isRegistered<Repository>()
      ? Get.find<Repository>()
      : Get.put(RepositoryImpl());
  var bubbleCountResponse = BubbleCountResponse().obs;

  /// List of widgets representing the driver's dashboard views.
  RxList<Widget> driver = [
    HomeDriverView(),
    SearchPage(),
    // LoaderHome(),
    MyLoadPage(),
    // const InHouseLoader(),
    AccountPage(),
  ].obs;


  RxInt selectedPosition = 0.obs;

  /// Initializes the dashboard controller, retrieves the user role, clears preferences if empty,
  /// and fetches bubble count data.
  @override
  Future<void> onInit() async {

    userRole.value = await _preferenceManager.getString(PreferenceManager.userRole);
    print(">>> 1. User Role >> ${userRole.value}");

    if(userRole.value==""){
      _preferenceManager.clear();
      // Get.toNamed(Routes.LOGIN);
    }

    refresh();
    update();
    getBubbleCount();
    super.onInit();
  }




  /// Fetches route details for a user based on `route_id` and `userInterface`,
  /// and updates the bubble count.
  Future<void> readRouteByUser({required int route_id,required String userInterface}) async {
    try{
      var response = await _repository.readRouteByUser(route_id: route_id, userInterface: userInterface);

    }catch(e){
      print(e.toString());
    }
    getBubbleCount();
  }

  /// Retrieves the bubble count data from the repository and updates the UI.
  Future<void> getBubbleCount() async {
      var pickUpOrdersService = _repository.getBubbleCount();
      callDataService(pickUpOrdersService, onSuccess: _handleBubbleCountResponseSuccess);
      hideLoading();

  }

  /// Updates the bubble count response and refreshes the UI.
  _handleBubbleCountResponseSuccess(BubbleCountResponse response) {
    bubbleCountResponse.value = response;
    refresh();
    update();
  }

  /// Displays a confirmation dialog asking the user whether they want to exit the application.
  /// The dialog contains two buttons: "Yes" to exit the app and "No" to dismiss the dialog.
  /// On Android, the app exits using `SystemNavigator.pop()`, while on iOS, it exits using `exit(0)`.
  /// Returns `false` if the dialog is dismissed without a selection.
  ///
  /// * `context`: The `BuildContext` used to display the dialog.
  Future<bool> showExitPopup(BuildContext context) async {
    return await getx.Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 50),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  color: Colors.white,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        AppString.doYouWantToExitAnApp,
                        textAlign: TextAlign.center,
                        style: AppTextStyles(context).title,
                      ),
                      const SizedBox(height: 20),
                      //Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              child: Text(
                                AppString.no,
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 45),
                                backgroundColor: AppColors.themeRed1,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                getx.Get.back();
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              child:  Text(
                               AppString.yes,
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(0, 45),
                                backgroundColor: AppColors.greenIconColor,
                                foregroundColor: AppColors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                if (Platform.isAndroid) {
                                  SystemNavigator.pop();
                                } else if (Platform.isIOS) {
                                  exit(0);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    ) ??
        false; //if showDialouge had returned null, then return false
  }

  /// Updates the selected index for the bottom navigation bar and refreshes the UI.
  /// Also retrieves the bubble count data to ensure the dashboard is updated.
  ///
  /// * `index`: The index of the selected navigation item.
  void changeBottomNavBar(int index) {
    selectedPosition.value = index;
    selectedIndex.value = index;
    update();
    getBubbleCount();
  }

}
