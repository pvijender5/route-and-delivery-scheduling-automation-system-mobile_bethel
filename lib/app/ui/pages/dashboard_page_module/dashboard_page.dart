/// `DashboardPage` is a `StatefulWidget` that represents the main dashboard screen.
/// It initializes location services, handles app lifecycle changes, and displays
/// different widgets based on the user's role. The class also manages a bottom
/// navigation bar for navigation between different sections of the dashboard.

// ignore_for_file: use_key_in_widget_constructors
import 'dart:async';

import 'package:bethel_farm/data/enums/user_role.dart';
import 'package:bethel_farm/modules/carrier_owner/load_board/load_board_ctrl.dart';
import 'package:bethel_farm/app/controllers/dashboard_module_controller/dashboard_controller.dart';
import 'package:bethel_farm/app/controllers/my_load_module_controller/my_load_driver_ctrl.dart';
import 'package:bethel_farm/modules/loader/pickup_orders/ctrl/pickup_order_list_ctrl.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:flutter/material.dart';
import 'package:here_sdk/consent.dart';
import 'package:here_sdk/location.dart';
import '../../../../../base/base_view.dart';
import '../../../../here_map_module/positioning/no_location_warning_widget.dart';
import '../../../../here_map_module/positioning/positioning.dart';
import '../../../../here_map_module/positioning/positioning_engine.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  PositioningEngine? _positioningEngine;
  OverlayEntry? _locationWarningOverlay;
  static const int _kLocationWarningDismissPeriod = 5;
  bool _didBackPressedAndPositionStopped = false;
  ConsentUserReply? _consentState;
  @override
  void initState() {
    super.initState();
    _positioningEngine = Provider.of<PositioningEngine>(context, listen: false);
    // _positioningEngine?.getLocationEngineStatusUpdates.listen(_checkLocationStatus);
    // _updateConsentState(_positioningEngine!);
    try {
      _positioningEngine?.initLocationEngine(context: context).then((value) {
        if (mounted) {
          // initPositioning(context: context, hereMapController: hereRouteController.hereMapController.value!);
          _updateConsentState(_positioningEngine!);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Stops the location engine when app is detached.
    if (state == AppLifecycleState.detached) {
      // This flag helps us to re-init the positioning when app is resumed.
      _didBackPressedAndPositionStopped = true;
    }
  }

  void _checkLocationStatus(LocationEngineStatus status) {
    if (status == LocationEngineStatus.engineStarted || status == LocationEngineStatus.alreadyStarted) {
      _dismissLocationWarningPopup();
      return;
    }
    // If we manually stopped the [_positioning], then no need to show the
    // warning dialog.
    if (status == LocationEngineStatus.engineStopped && _didBackPressedAndPositionStopped) {
      _dismissLocationWarningPopup();
      return;
    }

    if (_locationWarningOverlay == null) {
      _locationWarningOverlay = OverlayEntry(
        builder: (context) => NoLocationWarning(onPressed: () => _dismissLocationWarningPopup()),
      );

      Overlay.of(context).insert(_locationWarningOverlay!);
      Timer(Duration(seconds: _kLocationWarningDismissPeriod), _dismissLocationWarningPopup);
    }
  }

  void _dismissLocationWarningPopup() {
    _locationWarningOverlay?.remove();
    _locationWarningOverlay = null;
  }

  void _updateConsentState(PositioningEngine positioningEngine) {
    setState(() => _consentState = positioningEngine.userConsentState);
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0.0;
    return GetBuilder<DashboardController>(builder: (controller) {
      return WillPopScope(
        onWillPop: () async {
          return controller.showExitPopup(context);
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          //extendBody: true,
          //extendBodyBehindAppBar: true,
          body: SizedBox(
            height: MediaQuery.of(context).size.height * 0.95,
            child: (controller.userRole.value == UserRole.DRIVER.name)
                ? controller.driver[controller.selectedIndex.value]
                : (controller.userRole.value == UserRole.CARRIER_OWNER.name)
                    ? controller.carrierOwner[controller.selectedIndex.value]
                    : (controller.userRole.value == UserRole.LOADER.name)
                        ? controller.loaderWidgetArray[controller.selectedIndex.value]
                        : (controller.userRole.value == UserRole.MERCHANDISER.name)
                            ? controller.merchandiserWidgetArray[controller.selectedIndex.value]
                            : (controller.userRole.value == UserRole.SUB_DRIVER.name)
                                ? controller.subDriver[controller.selectedIndex.value]
                                : controller.non[controller.selectedIndex.value],
          ),
          bottomNavigationBar: isKeyboardOpen
              ? null
              : Container(
                  // height: 90,
                  // margin: const EdgeInsets.only(bottom: 5.0, top: 0.0, left: 5.0, right: 5.0),
                  margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                  // margin: EdgeInsets.all(5.0),
                  decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
                    ],
                  ),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                      child: Container(
                          // height: MediaQuery.of(context).size.height * 0.1,
                          child: BottomNavigationBar(
                              type: BottomNavigationBarType.fixed,
                              backgroundColor: Colors.black,
                              currentIndex: controller.selectedPosition.value,
                              onTap: (index) => controller.changeBottomNavBar(index),
                              selectedItemColor: Colors.white,
                              showSelectedLabels: true,
                              elevation: 0,
                              selectedLabelStyle:
                                  const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w900),
                              unselectedLabelStyle: const TextStyle(fontSize: 2, color: Colors.black),
                              // unselectedItemColor: Colors.grey,
                              items: (controller.userRole.value == UserRole.CARRIER_OWNER.name)
                                  ? <BottomNavigationBarItem>[
                                      BottomNavigationBarItem(
                                        icon: Container(
                                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                            child: controller.selectedPosition.value == 0
                                                ? Image.asset('assets/icons/home-active.png',
                                                    width: MediaQuery.of(context).size.height * 0.027,
                                                    height: MediaQuery.of(context).size.height * 0.027)
                                                : Image.asset('assets/icons/home-linear.png',
                                                    width: MediaQuery.of(context).size.height * 0.027,
                                                    height: MediaQuery.of(context).size.height * 0.027)),
                                        label: '.',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Container(
                                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                            child: controller.selectedPosition.value == 1
                                                ? Image.asset('assets/icons/search-active.png',
                                                    width: MediaQuery.of(context).size.height * 0.027,
                                                    height: MediaQuery.of(context).size.height * 0.027)
                                                : Image.asset('assets/icons/search-linear.png',
                                                    width: MediaQuery.of(context).size.height * 0.027,
                                                    height: MediaQuery.of(context).size.height * 0.027)),
                                        label: '.',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Stack(
                                          children: <Widget>[
                                            Container(
                                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                child: controller.selectedPosition.value == 2
                                                    ? Image.asset('assets/images/clipboard-filled.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)
                                                    : Image.asset('assets/images/clipboard-regular.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)),
                                            Positioned(
                                              right: 0,
                                              child: Obx(() =>
                                                  ((controller.bubbleCountResponse.value.carrierownerLoadboardCount ??
                                                              0) >
                                                          0)
                                                      ? Container(
                                                          padding: const EdgeInsets.all(1),
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          constraints: const BoxConstraints(
                                                            minWidth: 12,
                                                            minHeight: 12,
                                                          ),
                                                          child: Text(
                                                            '${(controller.bubbleCountResponse.value.carrierownerLoadboardCount ?? 0)}',
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 8,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        )
                                                      : Container()),
                                            )
                                          ],
                                        ),
                                        label: '.',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Stack(
                                          children: <Widget>[
                                            Container(
                                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                child: controller.selectedPosition.value == 3
                                                    ? Image.asset('assets/icons/truck-active.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)
                                                    : Image.asset('assets/icons/truck-linear.png',
                                                        width: MediaQuery.of(context).size.height * 0.032,
                                                        height: MediaQuery.of(context).size.height * 0.032)),
                                            Positioned(
                                              right: 0,
                                              child: Obx(() =>
                                                  ((controller.bubbleCountResponse.value.carrierownerMyloadCount ?? 0) >
                                                          0)
                                                      ? Container(
                                                          padding: const EdgeInsets.all(1),
                                                          decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                          constraints: const BoxConstraints(
                                                            minWidth: 12,
                                                            minHeight: 12,
                                                          ),
                                                          child: Text(
                                                            '${(controller.bubbleCountResponse.value.carrierownerMyloadCount ?? 0)}',
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 8,
                                                            ),
                                                            textAlign: TextAlign.center,
                                                          ),
                                                        )
                                                      : Container()),
                                            )
                                          ],
                                        ),
                                        label: '.',
                                      ),
                                      BottomNavigationBarItem(
                                        icon: Container(
                                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                            child: controller.selectedPosition.value == 4
                                                ? Image.asset('assets/icons/user-active.png',
                                                    width: MediaQuery.of(context).size.height * 0.027,
                                                    height: MediaQuery.of(context).size.height * 0.027)
                                                : Image.asset('assets/icons/user-linear.png',
                                                    width: MediaQuery.of(context).size.height * 0.027,
                                                    height: MediaQuery.of(context).size.height * 0.027)),
                                        label: '.',
                                      )
                                    ]
                                  : (controller.userRole.value == UserRole.LOADER.name)
                                      ? <BottomNavigationBarItem>[
                                          BottomNavigationBarItem(
                                            icon: Container(
                                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                child: controller.selectedPosition.value == 0
                                                    ? Image.asset('assets/icons/home-active.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)
                                                    : Image.asset('assets/icons/home-linear.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)),
                                            label: '.',
                                          ),
                                          BottomNavigationBarItem(
                                            icon: Container(
                                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                child: controller.selectedPosition.value == 1
                                                    ? Image.asset('assets/icons/search-active.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)
                                                    : Image.asset('assets/icons/search-linear.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)),
                                            label: '.',
                                          ),
                                          BottomNavigationBarItem(
                                            icon: Stack(
                                              children: <Widget>[
                                                Container(
                                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                    child: controller.selectedPosition.value == 2
                                                        ? Image.asset('assets/images/cart-fill-icon.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)
                                                        : Image.asset('assets/images/cart-border-icon.png',
                                                            width: MediaQuery.of(context).size.height * 0.032,
                                                            height: MediaQuery.of(context).size.height * 0.032)),
                                                Positioned(
                                                  right: 0,
                                                  child: Obx(() =>
                                                      ((controller.bubbleCountResponse.value.pickupcount ?? 0) > 0)
                                                          ? Container(
                                                              padding: const EdgeInsets.all(1),
                                                              decoration: BoxDecoration(
                                                                color: Colors.red,
                                                                borderRadius: BorderRadius.circular(6),
                                                              ),
                                                              constraints: const BoxConstraints(
                                                                minWidth: 12,
                                                                minHeight: 12,
                                                              ),
                                                              child: Text(
                                                                '${controller.bubbleCountResponse.value.pickupcount ?? 0}',
                                                                style: const TextStyle(
                                                                  color: Colors.white,
                                                                  fontSize: 8,
                                                                ),
                                                                textAlign: TextAlign.center,
                                                              ),
                                                            )
                                                          : Container()),
                                                )
                                              ],
                                            ),
                                            label: '.',
                                          ),
                                          // BottomNavigationBarItem(
                                          //   icon: Container(
                                          //       padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                          //       child: controller.selectedind.value == 2
                                          //           ? Image.asset('assets/images/box-filled.png',
                                          //           width: MediaQuery.of(context).size.height * 0.027,
                                          //           height: MediaQuery.of(context).size.height * 0.027)
                                          //           : Image.asset('assets/images/box-regular.png',
                                          //           width: MediaQuery.of(context).size.height * 0.027,
                                          //           height: MediaQuery.of(context).size.height * 0.027)),
                                          //   label: '.',
                                          // ),
                                          BottomNavigationBarItem(
                                            icon: Stack(
                                              children: <Widget>[
                                                Container(
                                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                    child: controller.selectedPosition.value == 3
                                                        ? Image.asset('assets/icons/truck-active.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)
                                                        : Image.asset('assets/icons/truck-linear.png',
                                                            width: MediaQuery.of(context).size.height * 0.032,
                                                            height: MediaQuery.of(context).size.height * 0.032)),
                                                Positioned(
                                                  right: 0,
                                                  child: Obx(
                                                    () =>
                                                        ((controller.bubbleCountResponse.value.deliverycount ?? 0) > 0)
                                                            ? Container(
                                                                padding: const EdgeInsets.all(1),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.red,
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                constraints: const BoxConstraints(
                                                                  minWidth: 12,
                                                                  minHeight: 12,
                                                                ),
                                                                child: Text(
                                                                  '${(controller.bubbleCountResponse.value.deliverycount ?? 0)}',
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 8,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              )
                                                            : Container(),
                                                  ),
                                                )
                                              ],
                                            ),
                                            label: '.',
                                          ),
                                          BottomNavigationBarItem(
                                            icon: Container(
                                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                child: controller.selectedPosition.value == 4
                                                    ? Image.asset('assets/icons/user-active.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)
                                                    : Image.asset('assets/icons/user-linear.png',
                                                        width: MediaQuery.of(context).size.height * 0.027,
                                                        height: MediaQuery.of(context).size.height * 0.027)),
                                            label: '.',
                                          )
                                        ]
                                      : (controller.userRole.value == UserRole.MERCHANDISER.name)
                                          ? <BottomNavigationBarItem>[
                                              BottomNavigationBarItem(
                                                icon: Container(
                                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                    child: controller.selectedPosition.value == 0
                                                        ? Image.asset('assets/icons/home-active.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)
                                                        : Image.asset('assets/icons/home-linear.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)),
                                                label: '.',
                                              ),
                                              BottomNavigationBarItem(
                                                icon: Container(
                                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                    child: controller.selectedPosition.value == 1
                                                        ? Image.asset('assets/icons/search-active.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)
                                                        : Image.asset('assets/icons/search-linear.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)),
                                                label: '.',
                                              ),
                                              BottomNavigationBarItem(
                                                icon: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                        child: controller.selectedPosition.value == 2
                                                            ? Image.asset('assets/icons/truck-active.png',
                                                                width: MediaQuery.of(context).size.height * 0.027,
                                                                height: MediaQuery.of(context).size.height * 0.027)
                                                            : Image.asset('assets/icons/truck-linear.png',
                                                                width: MediaQuery.of(context).size.height * 0.027,
                                                                height: MediaQuery.of(context).size.height * 0.027)),
                                                    Positioned(
                                                      right: 0,
                                                      child: Obx(
                                                        () => ((controller.bubbleCountResponse.value
                                                                        .merchandiserassignedshipmentcount ??
                                                                    0) >
                                                                0)
                                                            ? Container(
                                                                padding: const EdgeInsets.all(1),
                                                                decoration: BoxDecoration(
                                                                  color: Colors.red,
                                                                  borderRadius: BorderRadius.circular(6),
                                                                ),
                                                                constraints: const BoxConstraints(
                                                                  minWidth: 12,
                                                                  minHeight: 12,
                                                                ),
                                                                child: Text(
                                                                  '${(controller.bubbleCountResponse.value.merchandiserassignedshipmentcount ?? 0)}',
                                                                  style: const TextStyle(
                                                                    color: Colors.white,
                                                                    fontSize: 8,
                                                                  ),
                                                                  textAlign: TextAlign.center,
                                                                ),
                                                              )
                                                            : Container(),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                label: '.',
                                              ),
                                              BottomNavigationBarItem(
                                                icon: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                        child: controller.selectedPosition.value == 3
                                                            ? Image.asset('assets/icons/user-active.png',
                                                                width: MediaQuery.of(context).size.height * 0.027,
                                                                height: MediaQuery.of(context).size.height * 0.027)
                                                            : Image.asset('assets/icons/user-linear.png',
                                                                width: MediaQuery.of(context).size.height * 0.027,
                                                                height: MediaQuery.of(context).size.height * 0.027)),
                                                  ],
                                                ),
                                                label: '.',
                                              )
                                            ]
                                          : <BottomNavigationBarItem>[
                                              BottomNavigationBarItem(
                                                icon: Container(
                                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                    child: controller.selectedPosition.value == 0
                                                        ? Image.asset('assets/icons/home-active.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)
                                                        : Image.asset('assets/icons/home-linear.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)),
                                                label: '.',
                                              ),
                                              BottomNavigationBarItem(
                                                icon: Container(
                                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                    child: controller.selectedPosition.value == 1
                                                        ? Image.asset('assets/icons/search-active.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)
                                                        : Image.asset('assets/icons/search-linear.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)),
                                                label: '.',
                                              ),
                                              BottomNavigationBarItem(
                                                icon: Stack(
                                                  children: <Widget>[
                                                    Container(
                                                        padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                        child: controller.selectedPosition.value == 2
                                                            ? Image.asset('assets/icons/truck-active.png',
                                                                width: MediaQuery.of(context).size.height * 0.027,
                                                                height: MediaQuery.of(context).size.height * 0.027)
                                                            : Image.asset('assets/icons/truck-linear.png',
                                                                width: MediaQuery.of(context).size.height * 0.027,
                                                                height: MediaQuery.of(context).size.height * 0.027)),
                                                    Positioned(
                                                      right: 0,
                                                      child: Obx(() =>
                                                          ((controller.bubbleCountResponse.value.myloadcount ?? 0) > 0)
                                                              ? Container(
                                                                  padding: const EdgeInsets.all(1),
                                                                  decoration: BoxDecoration(
                                                                    color: Colors.red,
                                                                    borderRadius: BorderRadius.circular(6),
                                                                  ),
                                                                  constraints: const BoxConstraints(
                                                                    minWidth: 12,
                                                                    minHeight: 12,
                                                                  ),
                                                                  child: Text(
                                                                    "${controller.bubbleCountResponse.value.myloadcount ?? 0}",
                                                                    style: const TextStyle(
                                                                      color: Colors.white,
                                                                      fontSize: 8,
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                )
                                                              : Container()),
                                                    )
                                                  ],
                                                ),
                                                label: '.',
                                              ),
                                              BottomNavigationBarItem(
                                                icon: Container(
                                                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                    child: controller.selectedPosition.value == 3
                                                        ? Image.asset('assets/icons/user-active.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)
                                                        : Image.asset('assets/icons/user-linear.png',
                                                            width: MediaQuery.of(context).size.height * 0.027,
                                                            height: MediaQuery.of(context).size.height * 0.027)),
                                                label: '.',
                                              )
                                            ]))),
                ),
        ),
      );
    });
  }
}
