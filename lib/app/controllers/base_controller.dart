/// [BaseController] is an abstract class that extends `GetxController`
/// and provides common functionality for managing state, handling API calls,
/// and controlling page behavior in the application.
///
/// This class includes methods for showing/hiding loading states, managing
/// error/success messages, and handling API responses. It also provides
/// utility methods for refreshing pages and fetching inventory data.


import 'dart:async';
import 'dart:convert';
import 'package:bethel_farm/data/network/exceptions/service_unavailable_exception.dart';
import 'package:bethel_farm/data/network/exceptions/json_format_exception.dart';
import 'package:bethel_farm/data/network/exceptions/unauthorize_exception.dart';
import 'package:bethel_farm/data/network/exceptions/not_found_exception.dart';
import 'package:bethel_farm/data/network/exceptions/network_exception.dart';
import 'package:bethel_farm/data/network/exceptions/api_exception.dart';
import 'package:bethel_farm/data/network/exceptions/app_exception.dart';
import 'package:bethel_farm/data/enums/page_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';


/// [BaseController]  the class is used for logic functionality.
abstract class BaseController extends GetxController {
  // final Logger logger = BuildConfig.instance.config.logger;
  // AppLocalizations get appLocalization => AppLocalizations.of(Get.context!)!;

  final logoutController = false.obs;
  final PreferenceManager _preferenceManager = Get.find(tag: (PreferenceManager).toString());
  //Reload the page
  final _refreshController = false.obs;
  RxList<InventoryData> inventoryList= <InventoryData>[].obs;
  refreshPage(bool refresh) => _refreshController(refresh);
  final Repository _repository = Get.isRegistered<Repository>()
      ? Get.find<Repository>()
      : Get.put(RepositoryImpl());
  //Controls page state
  final pageSateController = PageState.DEFAULT.obs;
  PageState get pageState => pageSateController.value;
  resetPageState() => pageSateController(PageState.DEFAULT);
  updatePageState(PageState state) => pageSateController(state);

  hideLoading() => resetPageState();
  showLoading() => updatePageState(PageState.LOADING);

  final _messageController = ''.obs;
  String get message => _messageController.value;
  showMessage(String msg) => _messageController(msg);

  final _errorMessageController = ''.obs;
  String get errorMessage => _errorMessageController.value;
  showErrorMessage(String msg) {
    _errorMessageController(msg);
    update();
  }

  final _successMessageController = ''.obs;
  String get successMessage => _messageController.value;
  showSuccessMessage(String msg) => _successMessageController(msg);

  /// Handles API calls with optional callbacks for success, error, start, and completion.
  /// Displays loading states and manages exceptions to show appropriate error messages.
  // ignore: long-parameter-list
  dynamic callDataService<T>(
    Future<T> future, {
    Function(Exception exception)? onError,
    Function(T response)? onSuccess,
    Function? onStart,
    Function? onComplete,
  }) async {
    Exception? _exception;
    onStart == null ? showLoading() : onStart();
    try {
      final T response = await future;
      if (onSuccess != null) onSuccess(response);
      onComplete == null ? hideLoading() : onComplete();
      return response;
    } on ServiceUnavailableException catch (exception) {
      hideLoading();
      _exception = exception;
      showErrorMessage(exception.message);
    } on UnauthorizedException catch (exception) {
      hideLoading();
      _exception = exception;
      showErrorMessage(exception.message);
    } on TimeoutException catch (exception) {
      hideLoading();
      _exception = exception;
      showErrorMessage(exception.message ?? 'Timeout exception');
    } on NetworkException catch (exception) {
      hideLoading();
      _exception = exception;
      showErrorMessage(exception.message);
    } on JsonFormatException catch (exception) {
      hideLoading();
      _exception = exception;
      showErrorMessage(exception.message);
    } on NotFoundException catch (exception) {
      hideLoading();
      _exception = exception;
      showErrorMessage(exception.message);
    } on ApiException catch (exception) {
      hideLoading();
      _exception = exception;
    } on AppException catch (exception) {
      hideLoading();
      _exception = exception;
      showErrorMessage(exception.message);
    } catch (error) {
      hideLoading();
      _exception = Exception("$error");
      debugPrint("LOG >>Controller>>>>>> $_exception");
    }
    if (onError != null) onError(_exception);
    onComplete == null ? hideLoading() : onComplete();
    hideLoading();
  }

  @override
  void onClose() {
    _messageController.close();
    _refreshController.close();
    pageSateController.close();
    super.onClose();
  }

  /// Fetching shipment inventory Details
  Future<ShipmentInventoryResponse> getShipmentInventory(int shipmentId) async {
    SmartDialog.showLoading();
        var inventoryService = _repository.getShipmentInventory(shipmentId);
        callDataService(inventoryService, onSuccess: _handleInventoryResponseSuccess);
        hideLoading();
        return inventoryService;
  }

  ///Fetching route shipment inventory Details
  Future<ShipmentInventoryResponse> getRouteShipmentInventory(int routeId) async {
    SmartDialog.showLoading();
    var inventoryService = _repository.getRouteShipmentInventory(routeId);
    callDataService(inventoryService, onSuccess: _handleInventoryResponseSuccess);
    hideLoading();
    return inventoryService;
  }

  _handleInventoryResponseSuccess(ShipmentInventoryResponse response) {

    /// If error while fetching API
    if (response.status == AppString.apiStatusError) {
      SmartDialog.dismiss();
      inventoryList.clear();
      // Utils.showErrorMessage(response.message.toString());
    } else {
      SmartDialog.dismiss();
      inventoryList.clear();
      inventoryList.value.addAll(response.data??[]);
      refresh();
      update();
      // Utils.showSuccessMessage(response.message.toString());
    }
  }
}
