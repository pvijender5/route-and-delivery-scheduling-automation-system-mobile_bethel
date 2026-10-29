/// [SearchBinding] is a class that implements the [Bindings] interface from GetX.
///
/// This class is responsible for binding dependencies required for the search module.
/// It ensures that the [SearchViewController] is lazily instantiated and available for dependency injection.
///
/// Usage:
/// This class is typically used during the initialization phase of the application
/// to bind the [SearchViewController] to the search module.

import 'package:bethel_farm/app/controllers/search_module_controller/search_ctrl.dart';
import 'package:get/get.dart';


class SearchBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut<SearchViewController>(() => SearchViewController());
  }

}
