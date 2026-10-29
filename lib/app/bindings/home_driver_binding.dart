/// [HomeBinding] is a class that implements the [Bindings] interface from GetX.
///
/// This class is responsible for binding dependencies required for the home driver module.
/// It ensures that the [HomeDriverController] is lazily instantiated and available for dependency injection.
///
/// Usage:
/// This class is typically used during the initialization phase of the application
/// to bind the [HomeDriverController] to the home driver module.

import 'package:bethel_farm/app/controllers/dashboard_module_controller/home_driver_ctrl.dart';
import 'package:get/get.dart';


class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeDriverController>(() => HomeDriverController());
  }
}
