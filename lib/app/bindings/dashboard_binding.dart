/// [DashboardBinding] is a class that implements the [Bindings] interface from GetX.
///
/// This class is responsible for binding dependencies required for the dashboard module.
/// It ensures that the [DashboardController] is lazily instantiated and available for dependency injection.
///
/// Usage:
/// This class is typically used during the initialization phase of the application
/// to bind the [DashboardController] to the dashboard module.

import 'package:bethel_farm/app/controllers/dashboard_module_controller/dashboard_controller.dart';
import 'package:get/instance_manager.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
  }
}
