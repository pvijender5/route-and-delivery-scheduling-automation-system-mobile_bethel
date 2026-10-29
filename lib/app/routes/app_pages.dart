/// [AppPages] defines the application's navigation structure.
/// It contains the initial route and a list of all available routes
/// with their corresponding pages and bindings.

// ignore_for_file: constant_identifier_names, non_constant_identifier_names
import 'package:bethel_farm/modules/auth/change_pass/change_pass.dart';
import 'package:bethel_farm/modules/auth/change_pass/change_password_binding.dart';
import 'package:bethel_farm/modules/auth/forgot_pass/forgot_pass.dart';
import 'package:bethel_farm/modules/auth/forgot_pass/forgot_password_binding.dart';
import 'package:bethel_farm/app/bindings/login_binding.dart';
import 'package:bethel_farm/app/ui/pages/auth_module/login_view.dart';
import 'package:bethel_farm/app/bindings/otp_binding.dart';
import 'package:bethel_farm/app/ui/pages/auth_module/otp_screen.dart';
import 'package:bethel_farm/app/bindings/splash_binding.dart';
import 'package:bethel_farm/app/ui/pages/splash_view.dart';
import 'package:bethel_farm/modules/carrier_owner/load_board/load_board_binding.dart';
import 'package:bethel_farm/modules/carrier_owner/load_board/load_board_view.dart';
import 'package:bethel_farm/app/bindings/account_binding.dart';
import 'package:bethel_farm/app/ui/pages/account_module/account_page.dart';
import 'package:bethel_farm/modules/dashboard/account/carrier_owner_work_dairy/carrier_owner_work_dairy_binding.dart';
import 'package:bethel_farm/modules/dashboard/account/carrier_owner_work_dairy/carrier_sales_work_dairy.dart';
import 'package:bethel_farm/modules/dashboard/account/work_dairy/binding/work_dairy_binding.dart';
import 'package:bethel_farm/modules/dashboard/account/work_dairy/view/driver_work_dairy.dart';
import 'package:bethel_farm/app/bindings/dashboard_binding.dart';
import 'package:bethel_farm/app/ui/pages/dashboard_module/dashboard_page.dart';
import 'package:bethel_farm/app/bindings/my_load_binding.dart';
import 'package:bethel_farm/app/ui/pages/my_load_page_module/my_load_view.dart';
import 'package:bethel_farm/app/bindings/stop_details_binding.dart';
import 'package:bethel_farm/app/ui/pages/driver_page/stop_details_view.dart';
import 'package:bethel_farm/app/bindings/home_driver_binding.dart';
import 'package:bethel_farm/app/ui/pages/driver_page/home_driver.dart';
import 'package:bethel_farm/modules/driver/re_sequence_shipment/re_sequence_view.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/loader_route_details_view.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/route_details_binding.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/shipment_loading_details/stop_loading_binding.dart';
import 'package:bethel_farm/modules/loader/loader_route_detail/shipment_loading_details/stop_loading_view.dart';
import 'package:bethel_farm/modules/notifications/notifications_view.dart';
import 'package:bethel_farm/app/bindings/search_binding.dart';
import 'package:bethel_farm/app/ui/pages/search_page_module/search_page.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../../modules/notifications/notifications_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final ROUTES = [
    GetPage(name: _Paths.OTP, page: () => OtpScreen(), binding: OtpBinding()),
    GetPage(name: _Paths.LOGIN, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(name: _Paths.HOME, page: () => HomeDriverView(), binding: HomeBinding()),
    GetPage(name: _Paths.SEARCH, page: () => SearchPage(), binding: SearchBinding()),
    GetPage(name: _Paths.SPLASH, page: () => SplashScreen(), binding: SplashBinding()),
    GetPage(name: _Paths.ACCOUNT, page: () => AccountPage(), binding: AccountBinding()),
    GetPage(name: _Paths.DASHBOARD, page: () => DashboardPage(), binding: DashboardBinding()),
    GetPage(name: _Paths.LEADERBOARD, page: () => LoadBoardPage(), binding: LoadBoardBinding()),
    GetPage(name: _Paths.LOADER_ROUTE, page: () => LoaderDetail(), binding: RouteDetailsBindings()),
    GetPage(name: _Paths.STOP_ROUTE_DETAIL, page: () => CompleteDelivery(), binding: StopDetailsBindings()),
    GetPage(name: _Paths.STOP_LOADING_DETAIL, page: () => CompleteLoading(), binding: StopLoadingBindings()),
    GetPage(name: _Paths.FORGOT_PASSWORD, page: () => ForgotPassword(), binding: ForgotPasswordBinding()),
    GetPage(name: _Paths.CHANGE_PASSWORD, page: () => ChangePassword(), binding: ChangePasswordBinding()),
    GetPage(name: _Paths.DRIVER_WORK_DAIRY, page: () => DriverWorkDairy(), binding: DriverWorkDairyBinding()),
    GetPage(name: _Paths.CARRIER_OWNER_WORK_DAIRY, page: () => CO_WorkDairy(), binding: CO_WorkDairyBinding()),
    GetPage(name: _Paths.RE_SEQUENCE_SHIPMENTS, page: () => ReSequenceShipment(), binding: RouteDetailsBindings()),
    GetPage(name: _Paths.NOTIFICATION, page: () => NotificationsView(), binding: NotificationBinding()),
    GetPage(name: _Paths.MYLOADS, page: () => MyLoadPage(), binding: MyLoadBinding())

  ];
}
