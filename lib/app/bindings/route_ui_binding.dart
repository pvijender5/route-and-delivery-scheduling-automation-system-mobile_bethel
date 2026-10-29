/// [RouteUIBinding] is a class that implements the [Bindings] interface from GetX.
///
/// This class is responsible for binding dependencies required for the Route UI module.
/// It ensures that the [RouteDetailController] is lazily instantiated and available for dependency injection.
///
/// Usage:
/// This class is typically used during the initialization phase of the application
/// to bind the [RouteDetailController] to the Route UI module.
import 'package:bethel_farm/utils/exports.dart';

import '../controllers/dashboard_module_controller/route_detail_controller.dart';

class RouteUIBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<RouteDetailController>(() => RouteDetailController());
  }
}