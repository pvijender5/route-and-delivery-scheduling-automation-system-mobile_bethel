/// [LocalSourceBindings] is a class that implements the [Bindings] interface from GetX.
///
/// This class is responsible for binding dependencies required for local sources.
/// It ensures that the [PreferenceManager] is lazily instantiated and available for dependency injection.
///
/// Usage:
/// This class is typically used during the initialization phase of the application
/// to bind the [PreferenceManager] to the local source module.

import 'package:bethel_farm/data/local/preference_manager.dart';
import 'package:bethel_farm/data/local/preference_manager_impl.dart';
import 'package:get/get.dart';


/// [Bindings] This class is extends Binding.
class LocalSourceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferenceManager>(() => PreferenceManagerImpl(), tag: (PreferenceManager).toString(), fenix: true);
  }
}
