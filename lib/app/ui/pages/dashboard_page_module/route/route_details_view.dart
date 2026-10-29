/*
 * Copyright (C) 2020-2024 HERE Europe B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * SPDX-License-Identifier: Apache-2.0
 * License-Filename: LICENSE
 */

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:bethel_farm/core/app_text_styles/app_text_styles.dart';
import 'package:bethel_farm/here_map_module/common/extensions/error_handling/routing_error_extension.dart';
import 'package:bethel_farm/here_map_module/common/notifications/android_notifications.dart';
import 'package:bethel_farm/here_map_module/common/notifications/ios_notifications.dart';
import 'package:bethel_farm/here_map_module/common/notifications/notifications_manager.dart';
import 'package:bethel_farm/here_map_module/common/utils/navigation/location_provider_interface.dart';
import 'package:bethel_farm/here_map_module/common/utils/navigation/location_utils.dart';
import 'package:bethel_farm/here_map_module/common/utils/navigation/position_status_listener.dart';
import 'package:bethel_farm/modules/dashboard/route/route_detail_controller.dart';
import 'package:bethel_farm/here_map_module/navigation/bethel_navigation_progress.dart';
import 'package:bethel_farm/here_map_module/routing/waypoint_info.dart';
import 'package:bethel_farm/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/gestures.dart';
import 'package:here_sdk/mapview.dart';
import 'package:here_sdk/navigation.dart' as Navigation;
import 'package:here_sdk/routing.dart' as HereRouting;
import 'package:here_sdk/routing.dart' as Routing;
import 'package:here_sdk/transport.dart' as Transport;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ringtone_player/ringtone_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/app_colors/app_colors.dart';
import '../../../core/app_decoration/app_decoration.dart';
import '../../../core/app_dimens/app_dimens.dart';
import '../../../core/app_string/app_strings.dart';
import '../../../core/app_values/app_values.dart';
import '../../../core/widgets/elevated_container.dart';
import '../../../data/enums/user_role.dart';
import 'route_expand.dart';
import '../../loader/pickup_order_detail/view/notes_modal_bottom_sheet.dart';
import '../../../utils/exports.dart';
import '../../../utils/route_status_enum.dart';
import '../../../here_map_module/common/application_preferences.dart';
import '../../../here_map_module/common/custom_map_style_settings.dart';
import '../../../here_map_module/common/error_toast.dart';
import '../../../here_map_module/common/here_map_util.dart' as Util;
import '../../../here_map_module/common/here_map_util.dart';
import '../../../here_map_module/common/marquee_widget.dart';
import '../../../here_map_module/common/ui_style.dart';
import '../../../here_map_module/positioning/positioning.dart';
import '../../../here_map_module/positioning/positioning_engine.dart';
import '../../../here_map_module/route_preferences/route_preferences_model.dart';
import '../../../here_map_module/routing/route_poi_handler.dart';
import '../../../here_map_module/navigation/current_maneuver_widget.dart';
import '../../../here_map_module/navigation/maneuver_action_text_helper.dart';
import '../../../here_map_module/navigation/navigation_dialogs.dart' as Dialogs;
import '../../../here_map_module/navigation/navigation_speed_widget.dart';
import '../../../here_map_module/navigation/next_maneuver_widget.dart';
import '../../../here_map_module/navigation/rerouting_handler.dart';
import '../../../here_map_module/navigation/rerouting_indicator_widget.dart';

/// Navigation mode screen widget.
class RouteDetailScreen extends StatefulWidget {
  // static const String navRoute = "/navigation";

  /// Constructs a widget.
  RouteDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RouteDetailScreenState createState() => _RouteDetailScreenState();
}

class _RouteDetailScreenState extends State<RouteDetailScreen>
    with WidgetsBindingObserver, Positioning
    implements PositioningStatusListener, LocationListener {
  // List<Routing.Route> _routes = [];
  static const double _kInitDistanceToEarth = 1000; // meters
  // static const double _kSpeedFactor = 1.3;
  // static const int _kNotificationIntervalInMilliseconds = 500;
  static const double _kDistanceToShowNextManeuver = 500;
  static const double _kTopBarHeight = 100;
  // static const double _kBottomBarHeight = 130;
  static const double _kHereLogoOffset = 75;
  static const double _kPrincipalPointOffset = 160;
  // static const double kRouteCardHeight = 100;
  // This is example code and not for real use.
  // These values are usually country specific and may vary depending on the navigation segment.
  static const double _kDefaultSpeedLimitOffset = 1;
  static const double _kDefaultSpeedLimitBoundary = 50;

  final GlobalKey _mapKeys = GlobalKey();
  final GlobalKey expandRouteBottomBarKey = GlobalKey();

  DeviceLocationServicesStatusNotifier? _servicesStatusNotifier;
  LocationProviderInterface? _locationProvider;
  Location? _currentLocationForLocationStatus;

  late Routing.Route _currentRoute;

  // late HereMapController hereMapController;
  late MapMarker _startMarker;
  late MapMarker _finishMarker;

  late Navigation.VisualNavigator _visualNavigator;
  bool _navigationStarted = false;
  bool _canLocateUserPosition = true;
  bool _shouldMonitorPositioning = false;

  bool _soundEnabled = true;
  FlutterTts _flutterTts = FlutterTts();

  Navigation.SpeedWarningStatus _speedWarningStatus = Navigation.SpeedWarningStatus.speedLimitRestored;

  ReroutingHandler? _reroutingHandler;
  bool _reroutingInProgress = false;
  late NotificationsManager _notificationsManager;

  AppLifecycleState? _appLifecycleState;

  bool get _canShowNotification => _appLifecycleState == AppLifecycleState.paused;
  Routing.RoutingInterface? routingEngine;
  PositioningEngine? _positioningEngine;
  RoutePoiHandler? routePoiHandler;
  List<MapPolyline> routeMapRoutes = [];
  int selectedRouteIndex = 0;
  late int remainingDistanceInMetersText;
  late int remainingDurationInSecondsText;
  int? currentManeuverIndexText;
  int currentManeuverDistanceText = 0;
  int? nextManeuverIndexText;
  int nextManeuverDistanceText = 0;
  String? currentStreetNameText;
  double? currentSpeedLimitText;
  double? currentSpeedText;
  RouteDetailController hereRouteController = RouteDetailController.to;

  bool _didBackPressedAndPositionStopped = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _initialiseUserPositioning();
    // getRoutDetail();
    AppPreferences appPreferences = Provider.of<AppPreferences>(context, listen: false);
    routingEngine = appPreferences.useAppOffline ? HereRouting.OfflineRoutingEngine() : HereRouting.RoutingEngine();

    WidgetsBinding.instance.addObserver(this);
    _visualNavigator = Navigation.VisualNavigator();

    getRoutDetail();
    if (Platform.isIOS) {
      _notificationsManager = IosNotificationsManager();
      _configTextSpeakerForIOS();
    } else {
      _notificationsManager = AndroidNotificationsManager();
    }
    _notificationsManager.init();
  }

  getRoutDetail() async {
    await hereRouteController.getRouteDetails();
    // hereRouteController.update();
    // initiatePolyline();
  }

  @override
  void dispose() {
    routePoiHandler?.release();
    _locationProvider?.removeListeners();
    _locationProvider?.stop();
    _reroutingHandler?.release();
    _servicesStatusNotifier?.stop();
    _flutterTts.stop();
    WidgetsBinding.instance.removeObserver(this);
    WakelockPlus.disable();
    _notificationsManager.dismissNotification();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget? nextManeuverWidget = _reroutingInProgress || !_canLocateUserPosition ? null : _buildNextManeuver(context);
    PreferredSize? topBarWidget = _buildTopBar(context);
    double topOffset = MediaQuery.of(context).padding.top - UIStyle.popupsBorderRadius;
    final HereMapOptions options = HereMapOptions()..initialBackgroundColor = Theme.of(context).colorScheme.surface;
    options.renderMode = MapRenderMode.texture;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) async {
        if (!didPop && await Dialogs.askForExitFromNavigation(context)) {
          _stopNavigation();
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: hereRouteController.userRole.value == UserRole.MERCHANDISER.name
            ? null
            : _navigationStarted
                ? topBarWidget
                : AppBar(
                    leading: IconButton(
                        onPressed: () {
                          hereRouteController.route.value = null;
                          hereRouteController.wayPointsController.value = null;
                          _stopNavigation();
                          hereRouteController.update();
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.black,
                          size: 25,
                        )),
                    title: Text(AppString.routeDetails,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: Colors.black)),
                  ),
        body: Obx(
          () => Padding(
            padding: EdgeInsets.only(
              top: topBarWidget != null ? _kTopBarHeight + topOffset : 0,
            ),
            child: Stack(
              children: [
                (((hereRouteController.wayPointsController.value?.value ?? []).isNotEmpty) &&
                        hereRouteController.route.value != null)
                    ? HereMap(
                        key: _mapKeys,
                        options: options,
                        onMapCreated: (m) {
                          _onMapCreated(m);
                        },
                      )
                    : Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          "assets/images/map_loading.gif",
                          height: 50.0,
                          width: 50.0,
                        ),
                      ),
                shipmentsAndActions(),
                if (nextManeuverWidget != null) nextManeuverWidget,
                if (_navigationStarted) _buildNavigationControls(context),
              ],
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        // bottomNavigationBar: _navigationStarted
        //     ? Container(
        //   height: _kBottomBarHeight,
        //   child: NavigationProgress(
        //     routeLengthInMeters: _currentRoute.lengthInMeters,
        //     remainingDistanceInMeters: _remainingDistanceInMeters,
        //     remainingDurationInSeconds: _remainingDurationInSeconds,
        //   ),
        // )
        //     : null,
      ),
    );
  }

  Future<void> _configTextSpeakerForIOS() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      <IosTextToSpeechAudioCategoryOptions>[
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.duckOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );
  }

  Widget shipmentsAndActions() {
    return Stack(
      children: [
        Stack(
          children: [
            DraggableScrollableSheet(
              key: hereRouteController.sheet1,
              initialChildSize: 0.45,
              maxChildSize: 0.85,
              minChildSize: 0.12,
              expand: true,
              snap: true,
              snapSizes: const [0.12],
              controller: hereRouteController.controller.value,
              builder: (BuildContext context, ScrollController scrollController) {
                return DecoratedBox(
                  decoration: BoxDecoration(
                      color: AppColors.themeWhiteColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(AppDimen.circular30),
                          topRight: Radius.circular(AppDimen.circular30))),
                  child: CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///   Swipe up Linear line View
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context).size.height * 0.01,
                                          width: MediaQuery.of(context).size.width * 0.17,
                                          alignment: Alignment.center,
                                          color: Colors.grey[400],
                                          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01))
                                    ]),

                                ///   Note pad, Pause button and direction icon
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      ///   Note pad icon
                                      hereRouteController.subDriver == "yes"
                                          ? const SizedBox()
                                          : InkWell(
                                              onTap: () {
                                                if (hereRouteController.routeDetail.value?.id == null) {
                                                  // print('null');
                                                } else {
                                                  showModalBottomSheet<void>(
                                                      context: context,
                                                      backgroundColor: Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(AppDimen.circular20),
                                                              topRight: Radius.circular(AppDimen.circular20))),
                                                      builder: (context) {
                                                        return SizedBox(
                                                          height: 900,
                                                          width: MediaQuery.of(context).size.width,
                                                          child: NotesModalBottomSheet(
                                                            deliveryInstructions: hereRouteController
                                                                .routeDetail.value?.deliveryInstruction,
                                                            isDelivery: true,
                                                          ),
                                                        );
                                                      });
                                                }
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                                                  decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius: BorderRadius.circular(AppDimen.circular50)),
                                                  child: SvgPicture.asset("assets/icons/edit-notes.svg",
                                                      height: MediaQuery.of(context).size.width * 0.065,
                                                      color: AppColors.white))),

                                      SizedBox(width: MediaQuery.of(context).size.width * 0.08),

                                      ///   Pause Button icon
                                      (hereRouteController.userRole.value == UserRole.MERCHANDISER.name ||
                                              hereRouteController.subDriver == "yes")
                                          ? const SizedBox()
                                          : (hereRouteController.routeDetail.value?.isPaused == 1 ||
                                                  inTransitArrivedPassed(hereRouteController.routeDetail.value?.status))
                                              ? InkWell(
                                                  onTap: () {
                                                    if (statusToProceedInTransitOnTimeDelayPassed(
                                                        hereRouteController.routeDetail.value?.status)) {
                                                      hereRouteController.routeStatus.value = "";
                                                      hereRouteController.routePauseLog();
                                                      _initialiseUserPositioning();
                                                      _startPositioning(context);
                                                      checkDeviceBatteryStatus(context, isRealTimeNavigation: true);
                                                      _startNavigation();
                                                      hereRouteController.update();
                                                    } else if (inTransitArrivedPassed(
                                                        hereRouteController.routeDetail.value?.status)) {
                                                      hereRouteController.selectedReason.value = "pause for a break";
                                                      hereRouteController.reasonTextController?.value.text =
                                                          AppString.arrivedAtLocationForDelivery;
                                                      hereRouteController.routeStatus.value = IN_TRANSIT_ON_TIME;
                                                      hereRouteController.routePauseLog();
                                                      _initialiseUserPositioning();
                                                      _startPositioning(context);
                                                      checkDeviceBatteryStatus(context, isRealTimeNavigation: true);
                                                      _startNavigation();
                                                      hereRouteController.update();
                                                    } else if (hereRouteController.routeDetail.value?.status
                                                                ?.toLowerCase() ==
                                                            DELIVERED &&
                                                        hereRouteController.routeDetail.value?.isPaused == 1) {
                                                      hereRouteController.selectedReason.value = "pause for a break";
                                                      hereRouteController.reasonTextController?.value.text =
                                                          AppString.arrivedAtLocationForDelivery;
                                                      bool allDelivered = hereRouteController.stepperData.every(
                                                          (element) =>
                                                              isAllDeliveredPassed(element.content['deliveryStatus']) ||
                                                              isUnDeliveredPassed(element.content['deliveryStatus']));
                                                      // element.content['deliveryStatus'] == "delivered" ||
                                                      // element.content['deliveryStatus'] == "undelivered");
                                                      if (allDelivered) {
                                                        hereRouteController.routeStatus.value = DELIVERED;
                                                      } else {
                                                        hereRouteController.routeStatus.value = IN_TRANSIT_ON_TIME;
                                                      }

                                                      print(hereRouteController.reasonTextController?.value.text);
                                                      hereRouteController.routePauseLog();
                                                      _initialiseUserPositioning();
                                                      _startPositioning(context);
                                                      checkDeviceBatteryStatus(context, isRealTimeNavigation: true);
                                                      _startNavigation();
                                                      hereRouteController.update();
                                                    }
                                                  },
                                                  child: SvgPicture.asset("assets/icons/route-play-icon.svg",
                                                      height: MediaQuery.of(context).size.height * 0.10))
                                              : disablePauseActionPassed(
                                                      hereRouteController.routeDetail.value?.status ?? "")
                                                  ? SvgPicture.asset(
                                                      "assets/icons/route-pause-icon-disable.svg",
                                                      height: MediaQuery.of(context).size.height * 0.10,
                                                    )
                                                  : hereRouteController.subDriver == "yes"
                                                      ? SizedBox()
                                                      : InkWell(
                                                          onTap: () {
                                                            _showPopupRoutePauseLog(context, hereRouteController);
                                                          },
                                                          child: SvgPicture.asset(
                                                            "assets/icons/route-pause-icon.svg",
                                                            height: MediaQuery.of(context).size.height * 0.10,
                                                          ),
                                                        ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.08,
                                      ),

                                      ///   Direction icon
                                      hereRouteController.subDriver == "yes"
                                          ? const SizedBox()
                                          : InkWell(
                                              onTap: () async {
                                                hereRouteController.controller.value.jumpTo(0.12);
                                                if (hereRouteController.userRole.value != UserRole.MERCHANDISER.name) {
                                                  // Animate the camera to the new position
                                                  // controller.isSheetOpen.value = !controller.isSheetOpen.value;

                                                  if (shouldProceedBackgroundLocation(
                                                      hereRouteController.routeDetail.value?.status)) {
                                                    await hereRouteController.lastKnownLocation;
                                                    _enableTracking(true);
                                                  } else {
                                                    hereRouteController.hereMapController.value?.camera
                                                        .lookAtPointWithMeasure(
                                                      _currentRoute.geometry.vertices.first,
                                                      MapMeasure(MapMeasureKind.distance, _kInitDistanceToEarth),
                                                    );
                                                    hereRouteController.hereMapController.refresh();
                                                  }
                                                } else {
                                                  hereRouteController.hereMapController.value?.camera
                                                      .lookAtPointWithMeasure(
                                                    _currentRoute.geometry.vertices.first,
                                                    MapMeasure(MapMeasureKind.distance, _kInitDistanceToEarth),
                                                  );
                                                  hereRouteController.hereMapController.refresh();
                                                }
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                                                  decoration: BoxDecoration(
                                                      color: Colors.blueAccent,
                                                      borderRadius: BorderRadius.circular(AppDimen.circular50)),
                                                  child: SvgPicture.asset("assets/icons/direction-fill.svg",
                                                      height: MediaQuery.of(context).size.width * 0.065,
                                                      color: AppColors.white)))
                                    ]),
                              ],
                            ),

                            /// Used for display expand Route details UI
                            Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              width: MediaQuery.of(context).size.width * 0.88,
                              margin: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.003,
                                  right: MediaQuery.of(context).size.width * 0.003,
                                  top: MediaQuery.of(context).size.width * 0.02),
                              child: SingleChildScrollView(
                                child: Obx(
                                  () => Column(
                                    children: [
                                      RouteExpand(),
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                      (hereRouteController.userRole.value != UserRole.MERCHANDISER.name &&
                                              hereRouteController.subDriver != "yes")
                                          ? buildCompleteDeliveryButton(context)
                                          : const SizedBox().marginZero,
                                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                      (hereRouteController.userRole.value != UserRole.MERCHANDISER.name &&
                                              hereRouteController.subDriver != "yes")
                                          ? SizedBox(height: MediaQuery.of(context).size.height * 0.1)
                                          : const SizedBox(height: 0.0),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        hereRouteController.isLoading.value
            ? Center(
                child: ElevatedContainer(
                    padding: EdgeInsets.all(AppValues.margin),
                    child: const CircularProgressIndicator(color: AppColors.colorPrimary)))
            : Container(),
      ],
    );
  }

  Widget buildCompleteDeliveryButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async {
            ///For just testing purpose i am using this 2 linee of code, it will be call based on condition
            // controller.controller.value.jumpTo(0.12);
            // controller.route=route;
            // Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            //   return BethelNavigationScreen();
            // }));

            // controller.wayPointsController.value=wayPointsController;
            // controller.startRoute(controller.routeDetail.value?.id ?? 0); ///For just testing purpose i am using this 2 linee of code, it will be call based on condition
            if (statusToProceedInTransitOnTimeDelayPassed(hereRouteController.routeDetail.value?.status)) {
              null;
            } else if (inTransitArrivedPassed(hereRouteController.routeDetail.value?.status)) {
              hereRouteController.selectedReason.value = "pause for a break";
              hereRouteController.reasonTextController?.value.text = AppString.arrivedAtLocationForDelivery;
              bool allDelivered = hereRouteController.stepperData.every((element) =>
                  isAllDeliveredPassed(element.content['deliveryStatus']) ||
                  isUnDeliveredPassed(element.content['deliveryStatus']));
              // element.content['deliveryStatus'] == "delivered" ||
              // element.content['deliveryStatus'] == "undelivered");
              if (allDelivered) {
                hereRouteController.routeStatus.value = DELIVERED;
              } else {
                hereRouteController.routeStatus.value = IN_TRANSIT_ON_TIME;
              }
              hereRouteController.update();
              print(hereRouteController.reasonTextController?.value.text);
              hereRouteController.routePauseLog();
            } else if (isAllDeliveredPassed(hereRouteController.routeDetail.value?.status) &&
                hereRouteController.routeDetail.value?.isPaused == 1) {
              hereRouteController.selectedReason.value = "pause for a break";
              hereRouteController.reasonTextController?.value.text = AppString.arrivedAtLocationForDelivery;
              hereRouteController.update();
              print(hereRouteController.reasonTextController?.value.text);
              hereRouteController.routePauseLog();
            } else if (isAllDeliveredPassed(hereRouteController.routeDetail.value?.status)) {
              var completeRouteResp =
                  await hereRouteController.completeDelivery(hereRouteController.routeDetail.value?.id ?? 0);
              if (completeRouteResp?.data != null) {
                if (completeRouteResp?.status == AppString.apiStatusError) {
                } else {
                  // hereRouteController.route.value = null;
                  hereRouteController.wayPointsController.value = null;
                  hereRouteController.update();
                  // hereRouteController.routeDetail.value = null;
                  // hereRouteController.controller.value.jumpTo(0.12);
                  // hereRouteController.update();
                  _stopNavigation();
                  Navigator.pop(context);
                }
              }
            } else if (isLoadedPassed(hereRouteController.routeDetail.value?.status)) {
              hereRouteController.controller.value.jumpTo(0.12);

              var startRouteResp = await hereRouteController.startRoute(hereRouteController.routeDetail.value?.id ?? 0);
              if (startRouteResp?.data != null) {
                if (startRouteResp?.status == AppString.apiStatusError) {
                } else {
                  _initialiseUserPositioning();
                  _startPositioning(context);
                  checkDeviceBatteryStatus(context, isRealTimeNavigation: true);
                  _startNavigation();
                }
              }
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            // height: MediaQuery.of(context).size.height * 0.06,
            alignment: Alignment.center,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: (statusToProceedInTransitOnTimeDelayPassed(hereRouteController.routeDetail.value?.status))
                    ? AppColors.darkGreyIconColor
                    : (inTransitArrivedPassed(hereRouteController.routeDetail.value?.status))
                        ? Colors.lightBlue
                        : (isAllDeliveredPassed(hereRouteController.routeDetail.value?.status) &&
                                hereRouteController.routeDetail.value?.isPaused == 1)
                            ? Colors.lightBlue
                            : (isAllDeliveredPassed(hereRouteController.routeDetail.value?.status) &&
                                    hereRouteController.routeDetail.value?.isPaused == 0)
                                ? AppColors.themeGreen1Color
                                : (isCompletedPassed(hereRouteController.routeDetail.value?.status))
                                    ? AppColors.darkGreyIconColor
                                    : AppColors.themeGreen1Color,
                borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular50))),
            child: Text(
                (statusToProceedInTransitOnTimeDelayPassed(hereRouteController.routeDetail.value?.status))
                    ? AppString.startRouteStops
                    : (inTransitArrivedPassed(hereRouteController.routeDetail.value?.status))
                        ? AppString.resumeRouteStops
                        : (isAllDeliveredPassed(hereRouteController.routeDetail.value?.status) &&
                                hereRouteController.routeDetail.value?.isPaused == 1)
                            ? AppString.resumeRouteStops
                            : (isAllDeliveredPassed(hereRouteController.routeDetail.value?.status) &&
                                    hereRouteController.routeDetail.value?.isPaused == 0)
                                ? AppString.completeRouteStops
                                : AppString.startRouteStops,
                style: AppTextStyles(context).completeDeliveryButtonTextStyle),
          ),
        ),
      ],
    );
  }

  void _showPopupRoutePauseLog(BuildContext context, RouteDetailController controller) async {
    return showDialog(
        context: context,
        builder: (context) {
          return Obx(
            () => Material(
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.03,
                        right: MediaQuery.of(context).size.height * 0.03,
                        top: MediaQuery.of(context).size.height * 0.025,
                        bottom: MediaQuery.of(context).size.height * 0.025,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular20)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///   Sort By and cross icon
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ///   Sort By
                              Text("${AppString.breakPauseRoute} :",
                                  style: AppTextStyles(context).bold4TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.045, textColor: AppColors.black)),

                              ///   Icon
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.close, size: MediaQuery.of(context).size.width * 0.07),
                              )
                            ],
                          ),

                          ///   For Gap
                          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

                          ///   Shipment / Delivery Date
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: ListView(
                              children: (controller.breakDown)
                                  .map((timeValue) => RadioListTile<String>(
                                        activeColor: Colors.black,
                                        groupValue: controller.selectedReason.value,
                                        title: Text(
                                          timeValue,
                                          style: AppTextStyles(context).bold4TextStyle(
                                              fontSize: MediaQuery.of(context).size.width * 0.045,
                                              textColor: AppColors.black),
                                        ),
                                        value: timeValue,
                                        onChanged: (val) {
                                          controller.selectedReason.value = val ?? "Breakdown";
                                        },
                                      ))
                                  .toList(),
                            ),
                          ),

                          ///   For gap
                          SizedBox(height: MediaQuery.of(context).size.height * 0.015),

                          ///   Pickup time
                          Row(
                            children: [
                              Text(AppString.note,
                                  style: AppTextStyles(context).bold4TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.045,
                                    textColor: AppColors.black,
                                  )),
                              Text(" ( ${AppString.optional} )",
                                  style: AppTextStyles(context).bold4TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.035,
                                    textColor: AppColors.black,
                                  )),
                            ],
                          ),

                          ///   For Gap
                          SizedBox(height: MediaQuery.of(context).size.height * 0.035),

                          /// Username input box
                          TextFormField(
                              textInputAction: TextInputAction.next,
                              textAlignVertical: TextAlignVertical.center,
                              style: AppTextStyles(context).title,
                              decoration: AppDecorations.emailInputDecorations(AppString.enterText, context),
                              onChanged: (text) {},
                              autofocus: false,
                              controller: controller.reasonTextController?.value),

                          ///   For Gap
                          SizedBox(height: MediaQuery.of(context).size.height * 0.035),

                          ///   Apply Button and Cancel Button.
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ///   Apply Button
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  height: MediaQuery.of(context).size.height * 0.055,
                                  decoration: BoxDecoration(
                                      color: AppColors().green1,
                                      borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                                  child: MaterialButton(
                                    child: Text(AppString.save,
                                        style: AppTextStyles(context).bold4TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.045,
                                            textColor: AppColors.white)),
                                    onPressed: () {
                                      controller.routePauseLog();
                                      controller.update();
                                      Navigator.pop(context);
                                      _stopNavigation();
                                    },
                                  ),
                                ),

                                ///   Clear Button
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.35,
                                  height: MediaQuery.of(context).size.height * 0.055,
                                  decoration: BoxDecoration(
                                      color: AppColors().red1,
                                      borderRadius: BorderRadius.all(Radius.circular(AppDimen.circular10))),
                                  child: MaterialButton(
                                    child: Text(AppString.cancel,
                                        style: AppTextStyles(context).bold4TextStyle(
                                            fontSize: MediaQuery.of(context).size.width * 0.045,
                                            textColor: AppColors.white)),
                                    onPressed: () {
                                      controller.reasonTextController?.value.text = "";
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _onMapCreated(HereMapController newHereMapController) {
    hereRouteController.hereMapController.value = newHereMapController;
    hereRouteController.hereMapController.refresh();

    if (hereRouteController.route.value != null) {
      remainingDistanceInMetersText = hereRouteController.route.value!.lengthInMeters;
      remainingDurationInSecondsText = hereRouteController.route.value!.duration.inSeconds;
      hereRouteController.remainingDurationInSeconds?.value = remainingDurationInSecondsText;
      _currentRoute = hereRouteController.route.value!;
    }
    _reroutingHandler = ReroutingHandler(
      visualNavigator: _visualNavigator,
      wayPoints: hereRouteController.wayPointsController.value?.value ?? [],
      preferences: context.read<RoutePreferencesModel>(),
      onBeginRerouting: () {
        if (mounted) {
          setState(() => _reroutingInProgress = true);
        }
        _showNotification();
      },
      onNewRoute: _onNewRoute,
      offline: Provider.of<AppPreferences>(context, listen: false).useAppOffline,
    );
    if (hereRouteController.wayPointsController.value != null) {
      hereRouteController.wayPointsController.value?.addListener(() {
        beginRouting();

        if (mounted) {
          setState(() {});
        }
      });
    }
    CustomMapStyleSettings customMapStyleSettings = Provider.of<CustomMapStyleSettings>(context, listen: false);

    mapSceneLoadSceneCallback(MapError? error) async {
      if (error != null) {
        print('Map scene not loaded. MapError: ${error.toString()}');
        return;
      }

      newHereMapController.camera.lookAtPointWithMeasure(
        _currentRoute.geometry.vertices.first,
        MapMeasure(MapMeasureKind.distance, _kInitDistanceToEarth),
      );

      newHereMapController.setWatermarkLocation(
        Anchor2D.withHorizontalAndVertical(0, 1),
        Point2D(
          -newHereMapController.watermarkSize.width / 2,
          -newHereMapController.watermarkSize.height / 2,
        ),
      );

      Util.setTrafficLayersVisibilityOnMap(context, newHereMapController);

      _addRouteToMap();
      initiatePolyline();
      _addGestureListeners();
    }

    Util.loadMapScene(customMapStyleSettings, newHereMapController, mapSceneLoadSceneCallback);
  }

  initiatePolyline() async {
    if (hereRouteController.hereMapController.value != null) {
      if (hereRouteController.userRole.value == UserRole.MERCHANDISER.name) {
        hereRouteController.addMapMarker(hereRouteController.wayPointsController.value!.currentLocation);
      }
      routePoiHandler = RoutePoiHandler(
        hereMapController: hereRouteController.hereMapController.value!,
        wayPointsController: hereRouteController.wayPointsController.value!,
        onGetText: (place) => Util.makeDistanceString(context, place.distanceInMeters),
        offline: Provider.of<AppPreferences>(context, listen: false).useAppOffline,
      );
      beginRouting();

      if (hereRouteController.routeDetail.value?.isPaused == 0 &&
          shouldProceedBackgroundLocation(hereRouteController.routeDetail.value?.status)) {
        if (hereRouteController.userRole.value != UserRole.MERCHANDISER.name) {
          _shouldMonitorPositioning = true;
          _initialiseUserPositioning();
          _startPositioning(context);
          checkDeviceBatteryStatus(context, isRealTimeNavigation: true);
          _startNavigation();
        } else {
          // if(hereRouteController.userRole.value==UserRole.MERCHANDISER.name){
          //   hereRouteController.addMapMarker(hereRouteController.wayPointsController.value!.currentLocation);
          // }
          _initialiseUserPositioning();
          _startPositioning(context);
        }
      }
    }
  }

  // Widget _createWidget(String label, Color backgroundColor) {
  //   return Container(
  //     padding: EdgeInsets.all(8),
  //     decoration: BoxDecoration(
  //       color: backgroundColor,
  //       border: Border.all(color: Colors.black),
  //     ),
  //     child: GestureDetector(
  //       child: Text(
  //         label,
  //         style: TextStyle(fontSize: 12.0),
  //       ),
  //       onTap: () {
  //         print("Tapped on " + label);
  //         _dismissWayPointPopup();
  //       },
  //     ),
  //   );
  // }

  beginRouting() {
    RoutePreferencesModel preferences = Provider.of<RoutePreferencesModel>(context, listen: false);
    preferences.truckOptions.routeOptions.optimizeWaypointsOrder = true;
    routingEngine?.calculateTruckRoute(
        hereRouteController.wayPointsController.value!.value, preferences.truckOptions, onRoutingEnd);
  }

  onRoutingEnd(HereRouting.RoutingError? error, List<HereRouting.Route>? routes) {
    if (routes == null || routes.isEmpty) {
      if (error != null) {
        print('Routing failed. Error: ${error.toString()}');
        if (mounted) {
          // ErrorToaster.makeToast(
          //   context,
          //   error.errorMessage(AppLocalizations.of(context)!),
          // );
        }
      }
      return;
    }

    routePoiHandler?.clearPlaces();
    selectedRouteIndex = 0;
    // routesTabController?.dispose();

    hereRouteController.routesList.value = routes;

    hereRouteController.route.value = routes.first;

    // tabBarViewKey = GlobalKey();
    // routesTabController = TabController(
    //   length: routesList.length,
    //   vsync: this,
    // );
    // routesTabController?.addListener(() => updateSelectedRoute());

    _drawRoutesToMap();

    routePoiHandler?.updatePoiForRoute(hereRouteController.routesList.value[0]);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _zoomToRoutes());
  }

  _drawRoutesToMap() {
    _clearMapRoutes();

    for (int i = 0; i < hereRouteController.routesList.value.length; ++i) {
      _drawRouteToMap(hereRouteController.routesList.value[i], i == selectedRouteIndex);
    }
  }

  _drawRouteToMap(HereRouting.Route route, bool selected) {
    MapPolyline routeMapPolyline = MapPolyline.withRepresentation(
      route.geometry,
      mapRouteRepresentation(selected: selected),
    );
    routeMapPolyline.drawOrder = selected ? 1 : 0;
    hereRouteController.hereMapController.value?.mapScene.addMapPolyline(routeMapPolyline);
    routeMapRoutes.add(routeMapPolyline);
    if (mounted) {
      setState(() {});
    }
  }

  _clearMapRoutes() {
    for (var route in routeMapRoutes) {
      hereRouteController.hereMapController.value?.mapScene.removeMapPolyline(route);
    }
    routeMapRoutes.clear();
  }

  // updateSelectedRoute() {
  //   routeMapRoutes[selectedRouteIndex].setRepresentation(mapRouteRepresentation(selected: false));
  //   routeMapRoutes[selectedRouteIndex].drawOrder = 0;
  //   routeMapRoutes[routesTabController?.index??0].setRepresentation(mapRouteRepresentation());
  //   routeMapRoutes[routesTabController?.index??0].drawOrder = 1;
  //
  //   selectedRouteIndex = routesTabController?.index??0;
  //
  //   _zoomToRoutes();
  //   routePoiHandler?.updatePoiForRoute(routesList[selectedRouteIndex]);
  // }

  _zoomToRoutes() {
    List<GeoCoordinates> bounds = [];

    for (int i = 0; i < hereRouteController.routesList.value.length; ++i) {
      GeoBox geoBox = hereRouteController.routesList.value[i].boundingBox;
      bounds.add(geoBox.northEastCorner);
      bounds.add(geoBox.southWestCorner);
    }

    if (expandRouteBottomBarKey.currentContext != null) {
      final RenderBox bottomBarBox = expandRouteBottomBarKey.currentContext!.findRenderObject() as RenderBox;
      final GeoBox? geoBox = GeoBox.containingGeoCoordinates(bounds);

      if (geoBox == null) {
        return;
      }

      hereRouteController.hereMapController.value?.zoomGeoBoxToLogicalViewPort(
        geoBox: geoBox,
        viewPort: Rect.fromLTRB(
          0,
          MediaQuery.of(context).padding.top,
          bottomBarBox.size.width,
          MediaQuery.of(context).size.height - bottomBarBox.size.height,
        ).deflate(UIStyle.locationMarkerSize.toDouble()),
      );
    }
    if (mounted) {
      setState(() => enableMapUpdate = false);
    }
  }

  // void _dismissWayPointPopup() {
  //   if ((hereRouteController.hereMapController.value?.widgetPins ?? []).isNotEmpty) {
  //     hereRouteController.hereMapController.value?.widgetPins.first.unpin();
  //   }
  // }

  void _addGestureListeners() {
    hereRouteController.hereMapController.value?.gestures.tapListener = TapListener((Point2D touchPoint) async {
      // GeoCoordinates? coordinates = hereRouteController.hereMapController.value?.viewToGeoCoordinates(touchPoint);
      //
      // String? address =await getCoordinatesPlace(coordinates!.latitude,coordinates!.longitude);
      // // _dismissWayPointPopup();
      // Future.delayed(Duration(seconds: 1),(){
      //   _dismissWayPointPopup();
      // });
      // hereRouteController.hereMapController.value
      //     ?.pinWidget(_createWidget(address??"", Color.fromARGB(150, 0, 194, 138)), coordinates!);
      hereRouteController.hereMapController.value?.pickMapItems(touchPoint, 2, (pickResult) {
        if (pickResult!.markers.contains(hereRouteController.mapTruckMarker)) {
          print("Marker tapped!");
        }
      });
    });

    hereRouteController.hereMapController.value?.gestures.doubleTapListener =
        DoubleTapListener((origin) => _enableTracking(false));
    hereRouteController.hereMapController.value?.gestures.panListener =
        PanListener((state, origin, translation, velocity) => _enableTracking(false));
    hereRouteController.hereMapController.value?.gestures.pinchRotateListener = PinchRotateListener(
        (state, pinchOrigin, rotationOrigin, twoFingerDistance, rotation) => _enableTracking(false));
    hereRouteController.hereMapController.value?.gestures.twoFingerPanListener =
        TwoFingerPanListener((state, origin, translation, velocity) => _enableTracking(false));
    hereRouteController.hereMapController.value?.gestures.twoFingerTapListener =
        TwoFingerTapListener((origin) => _enableTracking(false));
  }

  void _enableTracking(bool enable) {
    if (mounted) {
      setState(() {
        _visualNavigator.cameraBehavior = enable ? Navigation.FixedCameraBehavior() : null;
      });
    }
  }

  void _addRouteToMap() {
    int markerSize =
        ((hereRouteController.hereMapController.value?.pixelScale ?? 0) * UIStyle.locationMarkerSize).round();
    for (int i = 0; i < (hereRouteController.wayPointsController.value?.value ?? []).length; i++) {
      WayPointInfo item = (hereRouteController.wayPointsController.value?.value ?? [])[i];

      if (isLoadedPassed(hereRouteController.routeDetail.value?.status)) {
        if (i == 0) {
          _startMarker = Util.createMarkerWithImagePathIndex(
            item.coordinates,
            "assets/images/warehouse_map_icon.png",
            "",
            markerSize,
            markerSize,
            drawOrder: UIStyle.waypointsMarkerDrawOrder,
          );
          hereRouteController.hereMapController.value?.mapScene.addMapMarker(_startMarker);
        } else if (i == ((hereRouteController.wayPointsController.value?.value ?? []).length - 1)) {
          _startMarker = Util.createMarkerWithImagePathIndex(
            item.coordinates,
            "assets/images/warehouse_map_icon.png",
            "",
            markerSize,
            markerSize,
            drawOrder: UIStyle.waypointsMarkerDrawOrder,
          );
          hereRouteController.hereMapController.value?.mapScene.addMapMarker(_startMarker);
        } else {
          _startMarker = Util.createMarkerWithImagePathIndex(
            item.coordinates,
            "assets/map_marker_big.svg",
            (i).toString(),
            markerSize,
            markerSize,
            drawOrder: UIStyle.waypointsMarkerDrawOrder,
          );
          hereRouteController.hereMapController.value?.mapScene.addMapMarker(_startMarker);
        }
      } else {
        if (i > 0 && i < ((hereRouteController.wayPointsController.value?.value ?? []).length - 1)) {
          _startMarker = Util.createMarkerWithImagePathIndex(
            item.coordinates,
            "assets/map_marker_big.svg",
            i.toString(),
            markerSize,
            markerSize,
            drawOrder: UIStyle.waypointsMarkerDrawOrder,
          );
          hereRouteController.hereMapController.value?.mapScene.addMapMarker(_startMarker);
        } else if (i == ((hereRouteController.wayPointsController.value?.value ?? []).length - 1)) {
          _startMarker = Util.createMarkerWithImagePathIndex(
            item.coordinates,
            "assets/images/warehouse_map_icon.png",
            "",
            markerSize,
            markerSize,
            drawOrder: UIStyle.waypointsMarkerDrawOrder,
          );
          hereRouteController.hereMapController.value?.mapScene.addMapMarker(_startMarker);
        }
      }
    }

    _zoomToWholeRoute();
  }

  void _zoomToWholeRoute() {
    final BuildContext? context = _mapKeys.currentContext;
    if (context != null) {
      hereRouteController.hereMapController.value
          ?.zoomToLogicalViewPort(geoBox: hereRouteController.route.value!.boundingBox, context: context);
    }
  }

  void _startNavigation() {
    hereRouteController.hereMapController.value?.mapScene.removeMapMarker(_startMarker);

    _visualNavigator.startRendering(hereRouteController.hereMapController.value!);

    _setupListeners();
    _setupVoiceTextMessages();

    _visualNavigator.route = _currentRoute;
    if (mounted) {
      setState(() {
        _navigationStarted = true;
      });
    }
  }

  ///NOTE:This function will be use for change location indicator, that is not working for now, we will check this
  // LocationIndicator _createCustomLocationIndicator() {
  //   // Place the files in the "assets" directory as specified in pubspec.yaml.
  //   // Adjust file name and path as appropriate for your project.
  //   String pedGeometryFile = "assets/custom_location_indicator_pedestrian.obj";
  //   String pedTextureFile = "assets/custom_location_indicator_pedestrian.png";
  //   MapMarker3DModel pedestrianMapMarker3DModel = MapMarker3DModel.withTextureFilePath(pedGeometryFile, pedTextureFile);
  //
  //   String navGeometryFile = "assets/custom_location_indicator_navigation.obj";
  //   String navTextureFile = "assets/custom_location_indicator_navigation.png";
  //   MapMarker3DModel navigationMapMarker3DModel = MapMarker3DModel.withTextureFilePath(navGeometryFile, navTextureFile);
  //
  //   LocationIndicator locationIndicator = LocationIndicator();
  //   double scaleFactor = 3;
  //
  //   // Note: For this example app, we use only simulated location data.
  //   // Therefore, we do not create a custom LocationIndicator for
  //   // .pedestrianInactive and .navigationInactive.
  //   // If set with a gray texture model, the type can be switched by calling locationIndicator.isActive = false
  //   // when the GPS accuracy is weak or no location was found.
  //   locationIndicator.setMarker3dModel(pedestrianMapMarker3DModel, scaleFactor, LocationIndicatorMarkerType.pedestrian);
  //   locationIndicator.setMarker3dModel(navigationMapMarker3DModel, scaleFactor, LocationIndicatorMarkerType.navigation);
  //   return locationIndicator;
  // }

  void _setupListeners() {
    try {
      _visualNavigator.routeProgressListener = Navigation.RouteProgressListener((routeProgress) {
        try {
          List<Navigation.SectionProgress> sectionProgressList = routeProgress.sectionProgress;

          int? currentManeuverIndex;
          int currentManeuverDistance = 0;
          int? nextManeuverIndex;
          int nextManeuverDistance = 0;

          List<Navigation.ManeuverProgress> nextManeuverList = routeProgress.maneuverProgress;
          if (nextManeuverList.isNotEmpty) {
            currentManeuverIndex = nextManeuverList.first.maneuverIndex;
            currentManeuverDistance = nextManeuverList.first.remainingDistanceInMeters;

            if (nextManeuverList.length > 1) {
              nextManeuverIndex = nextManeuverList[1].maneuverIndex;
              nextManeuverDistance = nextManeuverList[1].remainingDistanceInMeters;
            }
          }
          if (mounted) {
            setState(() {
              remainingDistanceInMetersText = sectionProgressList.last.remainingDistanceInMeters;
              remainingDurationInSecondsText = sectionProgressList.last.remainingDuration.inSeconds;
              hereRouteController.remainingDurationInSeconds?.value = remainingDurationInSecondsText;
              currentManeuverIndexText = currentManeuverIndex;
              currentManeuverDistanceText = currentManeuverDistance;
              nextManeuverIndexText = nextManeuverIndex ?? 0;
              nextManeuverDistanceText = nextManeuverDistance;
            });
          }
        } catch (e) {
          e.printError();
        }
      });

      _visualNavigator.navigableLocationListener = Navigation.NavigableLocationListener((location) {
        try {
          if (currentSpeedText != location.originalLocation.speedInMetersPerSecond) {
            if (mounted) {
              setState(() {
                currentSpeedText = location.originalLocation.speedInMetersPerSecond;
              });
            }
          }
        } catch (e) {
          e.printError();
        }
      });

      _visualNavigator.roadTextsListener = Navigation.RoadTextsListener((roadTexts) {
        try {
          if (currentStreetNameText != roadTexts.names.getDefaultValue()) {
            if (mounted) {
              setState(() => currentStreetNameText = roadTexts.names.getDefaultValue());
            }
          }
        } catch (e) {
          e.printError();
        }
      });

      if (_currentRoute.requestedTransportMode != Transport.TransportMode.pedestrian) {
        _visualNavigator.speedLimitListener = Navigation.SpeedLimitListener((speedLimit) {
          if (currentSpeedLimitText != speedLimit.effectiveSpeedLimitInMetersPerSecond()) {
            if (mounted) {
              setState(() => currentSpeedLimitText = speedLimit.effectiveSpeedLimitInMetersPerSecond());
            }
          }
        });

        final Navigation.SpeedLimitOffset offset = Navigation.SpeedLimitOffset()
          ..lowSpeedOffsetInMetersPerSecond = _kDefaultSpeedLimitOffset
          ..highSpeedOffsetInMetersPerSecond = _kDefaultSpeedLimitOffset
          ..highSpeedBoundaryInMetersPerSecond = _kDefaultSpeedLimitBoundary;
        _visualNavigator.speedWarningOptions = Navigation.SpeedWarningOptions(offset);
        _visualNavigator.speedWarningListener = Navigation.SpeedWarningListener((status) {
          if (status == Navigation.SpeedWarningStatus.speedLimitExceeded && _soundEnabled) {
            RingtonePlayer.play(android: Android.notification, ios: Ios.triTone);
          }
          if (mounted) {
            setState(() => _speedWarningStatus = status);
          }
        });
      }
      _visualNavigator.destinationReachedListener = Navigation.DestinationReachedListener(() {
        try {
          _stopNavigation();
          Navigator.pop(context);
          // Navigator.of(context).popUntil((route) {
          //   return route.settings.name == 'RoutingScreen';
          // });
        } catch (e) {
          e.printError();
        }
      });

      _visualNavigator.routeDeviationListener = _reroutingHandler;
      _visualNavigator.milestoneStatusListener = _reroutingHandler;
    } catch (e) {
      e.printError();
    }
    // Notifies truck drivers on road restrictions ahead. Called whenever there is a change.
    _visualNavigator.truckRestrictionsWarningListener =
        Navigation.TruckRestrictionsWarningListener((List<Navigation.TruckRestrictionWarning> list) {
      // The list is guaranteed to be non-empty.
      for (Navigation.TruckRestrictionWarning truckRestrictionWarning in list) {
        if (truckRestrictionWarning.distanceType == Navigation.DistanceType.ahead) {
          print("TruckRestrictionWarning ahead in: ${truckRestrictionWarning.distanceInMeters} meters.");
          SmartDialog.showToast(
              "${AppString.truckRestrictionAheadIn}: ${truckRestrictionWarning.distanceInMeters} ${AppString.meters}.");
          if (truckRestrictionWarning.timeRule != null &&
              !truckRestrictionWarning.timeRule!.appliesTo(DateTime.now())) {
            // For example, during a specific time period of a day, some truck restriction warnings do not apply.
            // If truckRestrictionWarning.timeRule is null, the warning applies at anytime.
            print("Note that this truck restriction warning currently does not apply.");
          }
        } else if (truckRestrictionWarning.distanceType == Navigation.DistanceType.reached) {
          print("A restriction has been reached.");
        } else if (truckRestrictionWarning.distanceType == Navigation.DistanceType.passed) {
          // If not preceded by a "reached"-notification, this restriction was valid only for the passed location.
          print("A restriction just passed.");
        }

        // One of the following restrictions applies ahead, if more restrictions apply at the same time,
        // they are part of another TruckRestrictionWarning element contained in the list.
        if (truckRestrictionWarning.weightRestriction != null) {
          Navigation.WeightRestrictionType type = truckRestrictionWarning.weightRestriction!.type;
          int value = truckRestrictionWarning.weightRestriction!.valueInKilograms;
          print("TruckRestriction for weight (kg): ${type.toString()}: $value");
          SmartDialog.showToast("${AppString.truckRestrictionsForWeight}: ${type.toString()}: $value");
        } else if (truckRestrictionWarning.dimensionRestriction != null) {
          // Can be either a length, width or height restriction of the truck. For example, a height
          // restriction can apply for a tunnel. Other possible restrictions are delivered in
          // separate TruckRestrictionWarning objects contained in the list, if any.
          Navigation.DimensionRestrictionType type = truckRestrictionWarning.dimensionRestriction!.type;
          int value = truckRestrictionWarning.dimensionRestriction!.valueInCentimeters;
          print("TruckRestriction for dimension: ${type.toString()}: $value");
          SmartDialog.showToast("${AppString.truckRestrictionsForDimension}: ${type.toString()}: $value");
        } else {
          print("TruckRestriction: General restriction - no trucks allowed.");
          SmartDialog.showToast(AppString.truckRestrictionsAsGeneral);
        }
      }
    });
  }

  void _setupVoiceTextMessages() async {
    try {
      await _flutterTts.setLanguage("en-US");

      _visualNavigator.eventTextListener = Navigation.EventTextListener((Navigation.EventText eventText) {
        if (eventText.type == Navigation.TextNotificationType.maneuver) {
          if (_soundEnabled) {
            _flutterTts.speak(eventText.text);
          }

          if (_appLifecycleState == AppLifecycleState.paused && currentManeuverIndexText != null) {
            Routing.Maneuver? maneuver = _visualNavigator.getManeuver(currentManeuverIndexText!);

            if (maneuver != null) {
              _notificationsManager.showNotification(_buildManeuverNotificationBody(maneuver, text: eventText.text));
            }
          }
        }
      });
    } catch (e) {
      print(e);
    }
  }

  NotificationBody _buildManeuverNotificationBody(Routing.Maneuver maneuver, {String? text}) {
    return NotificationBody(
      title: _getRemainingTimeString(),
      body: text ?? maneuver.getActionText(context),
      imagePath: maneuver.action.imagePath,
      presentSound: !_soundEnabled,
    );
  }

  NotificationBody _buildNavigationStatusNotificationBody() {
    return NotificationBody(
      title: _navigationStatus() ?? _getRemainingTimeString(),
      body: '',
      imagePath: '',
      presentSound: !_soundEnabled,
    );
  }

  String _getRemainingTimeString() {
    String arrivalInfo = AppLocalizations.of(context)!.arrivalTimeTitle +
        ": " +
        DateFormat.Hm().format(DateTime.now().add(Duration(seconds: remainingDurationInSecondsText)));
    return arrivalInfo;
  }

  void _stopNavigation() {
    _visualNavigator.route = null;
    _servicesStatusNotifier?.stop();
    _visualNavigator.stopRendering();
    _locationProvider?.removeListeners();
    _locationProvider?.stop();
    _notificationsManager.dismissNotification();
    if (mounted) {
      setState(() {
        _navigationStarted = false;
      });
    }
  }

  void _onNewRoute(Routing.Route? newRoute) {
    if (newRoute == null) {
      // rerouting failed
      if (mounted) {
        setState(() => _reroutingInProgress = false);
      }
      return;
    }

    _visualNavigator.route = null;

    _currentRoute = newRoute;
    remainingDistanceInMetersText = _currentRoute.lengthInMeters;
    remainingDurationInSecondsText = _currentRoute.duration.inSeconds;
    hereRouteController.remainingDurationInSeconds?.value = remainingDurationInSecondsText;
    currentManeuverIndexText = null;
    nextManeuverIndexText = null;
    currentManeuverDistanceText = 0;
    _visualNavigator.route = _currentRoute;
    _finishMarker.coordinates = newRoute.geometry.vertices.last;
    if (mounted) {
      setState(() => _reroutingInProgress = false);
    }
    _showNotification();
  }

  void _showNotification() {
    // if navigation is not started yet or app is not in background,
    // we will not show notification.
    // we will cancel notification that displayed already.
    if (!_navigationStarted || !_canShowNotification) {
      _notificationsManager.dismissNotification();
      return;
    }
    if (_navigationStatus() != null) {
      _notificationsManager.showNotification(_buildNavigationStatusNotificationBody());
    } else if (currentManeuverIndexText != null) {
      final Routing.Maneuver? maneuver = _visualNavigator.getManeuver(currentManeuverIndexText!);
      if (maneuver != null) {
        _notificationsManager.showNotification(_buildManeuverNotificationBody(maneuver));
      }
    }
  }

  String? _navigationStatus() {
    if (_shouldMonitorPositioning && !_canLocateUserPosition) {
      return AppLocalizations.of(context)!.locationWaitingForPositioning;
    } else if (_reroutingInProgress) {
      return AppLocalizations.of(context)!.navigationStatusRerouting;
    } else if (currentManeuverIndexText == null) {
      return AppLocalizations.of(context)!.navigationStatusWaitingForManeuvers;
    } else {
      return null;
    }
  }

  PreferredSize? _buildTopBar(BuildContext context) {
    if (!_navigationStarted) {
      return null;
    }

    Widget child;
    if (_navigationStatus() != null) {
      child = ReroutingIndicator(title: _navigationStatus()!);
    } else {
      Routing.Maneuver? maneuver = _visualNavigator.getManeuver(currentManeuverIndexText!);
      if (maneuver == null) {
        return null;
      }

      child = CurrentManeuver(
        action: maneuver.action,
        distance: currentManeuverDistanceText,
        text: maneuver.getActionText(context),
      );
    }

    return PreferredSize(
      preferredSize: Size.fromHeight(_kTopBarHeight),
      child: AppBar(
        shape: UIStyle.bottomRoundedBorder(),
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.white,
                size: 25,
              )),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        flexibleSpace: SafeArea(
          child: Row(
            children: [
              Expanded(flex: 1, child: child),
              BethelNavigationProgress(
                routeLengthInMeters: _currentRoute.lengthInMeters,
                remainingDistanceInMeters: remainingDistanceInMetersText,
                remainingDurationInSeconds: remainingDurationInSecondsText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildNextManeuver(BuildContext context) {
    if (currentManeuverDistanceText > _kDistanceToShowNextManeuver || _reroutingInProgress) {
      return null;
    }

    Routing.Maneuver? maneuver =
        nextManeuverIndexText != null ? _visualNavigator.getManeuver(nextManeuverIndexText!) : null;
    if (maneuver == null) {
      return null;
    }

    Routing.ManeuverAction action = maneuver.action;
    String text = maneuver.getActionText(context);

    return Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Theme.of(context).colorScheme.secondaryContainer,
        shape: UIStyle.bottomRoundedBorder(),
        elevation: 2,
        child: Padding(
          padding: EdgeInsets.only(
            top: UIStyle.popupsBorderRadius,
          ),
          child: NextManeuver(
            action: action,
            distance: nextManeuverDistanceText,
            text: text,
          ),
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // if (_visualNavigator.cameraBehavior == null)
        //   Padding(
        //     padding: EdgeInsets.only(bottom: UIStyle.contentMarginLarge),
        //     child: FloatingActionButton(
        //       heroTag: null,
        //       child: Icon(
        //         Icons.videocam,
        //       ),
        //       backgroundColor: Theme.of(context).colorScheme.surface,
        //       onPressed: () {
        //         _enableTracking(true);
        //       },
        //     ),
        //   ),
        FloatingActionButton(
          heroTag: null,
          child: Icon(
            _soundEnabled ? Icons.volume_up : Icons.volume_off,
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          onPressed: () async {
            await _flutterTts.stop();
            if (mounted) {
              setState(() => _soundEnabled = !_soundEnabled);
            }
          },
        ),
        Container(
          height: UIStyle.contentMarginLarge,
        ),
        // FloatingActionButton(
        //   heroTag: null,
        //   child: Icon(
        //     Icons.close,
        //     color: UIStyle.stopNavigationButtonIconColor,
        //   ),
        //   backgroundColor: UIStyle.stopNavigationButtonColor,
        //   onPressed: () async {
        //     if (await Dialogs.askForExitFromNavigation(context)) {
        //       _stopNavigation();
        //       Navigator.pop(context);
        //       // Navigator.of(context).popUntil((route) {
        //       //   return route.settings.name == 'RoutingScreen';
        //       // });
        //     }
        //   },
        // ),
      ],
    );
  }

  void _setupLogoAndPrincipalPointPosition() {
    final int margin = currentStreetNameText != null
        ? (_kHereLogoOffset * (hereRouteController.hereMapController.value?.pixelScale ?? 0)).truncate()
        : 0;

    hereRouteController.hereMapController.value?.setWatermarkLocation(
      Anchor2D.withHorizontalAndVertical(0.5, 1),
      Point2D(0, -((hereRouteController.hereMapController.value?.watermarkSize.height ?? 0) / 2) - margin),
    );

    hereRouteController.hereMapController.value?.camera.principalPoint = Point2D(
        (hereRouteController.hereMapController.value?.viewportSize.width ?? 0) / 2,
        (hereRouteController.hereMapController.value?.viewportSize.height ?? 0) -
            _kPrincipalPointOffset * (hereRouteController.hereMapController.value?.pixelScale ?? 0));
  }

  Widget _buildNavigationControls(BuildContext context) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    _setupLogoAndPrincipalPointPosition();

    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(UIStyle.contentMarginLarge, 50, UIStyle.contentMarginLarge,
            UIStyle.contentMarginLarge + UIStyle.popupsBorderRadius),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (currentSpeedText != null)
              NavigationSpeed(
                currentSpeed: currentSpeedText!,
                speedLimit: currentSpeedLimitText,
                speedWarningStatus: _speedWarningStatus,
              ),
            if (currentStreetNameText == null) Spacer(),
            if (currentStreetNameText != null)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: UIStyle.contentMarginLarge,
                    right: UIStyle.contentMarginLarge,
                  ),
                  child: Material(
                    elevation: 2,
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(UIStyle.bigButtonHeight),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: UIStyle.contentMarginMedium,
                        right: UIStyle.contentMarginMedium,
                      ),
                      child: Container(
                        height: UIStyle.bigButtonHeight,
                        child: Center(
                          child: MarqueeWidget(
                            child: Text(
                              currentStreetNameText!,
                              style: TextStyle(
                                fontSize: UIStyle.hugeFontSize,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_navigationStarted) {
      return;
    }
    _appLifecycleState = state;

    if (state == AppLifecycleState.paused) {
      // start notifications.
      _showNotification();
      _visualNavigator.stopRendering();
    }
    // Stops the location engine when app is detached.
    if (state == AppLifecycleState.detached) {
      // This flag helps us to re-init the positioning when app is resumed.
      _didBackPressedAndPositionStopped = true;
      stopPositioning();
    }
    if (state == AppLifecycleState.resumed) {
      _notificationsManager.dismissNotification();
      _didBackPressedAndPositionStopped = false;
      SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) => _visualNavigator.startRendering(hereRouteController.hereMapController.value!),
      );
      if (hereRouteController.userRole.value == UserRole.MERCHANDISER.name) {
        _positioningEngine?.initLocationEngine(context: context).then((value) {
          if (mounted) {
            initPositioning(context: context, hereMapController: hereRouteController.hereMapController.value!);
          }
        });
      }
    }
    if (state == AppLifecycleState.detached) {
      _notificationsManager.dismissNotification();
      _stopNavigation();
      // Navigator.of(context).popUntil((route) {
      //   return route.settings.name == 'RoutingScreen';
      // });
    }
  }

  @override
  void didDevicePositioningStatusUpdated({
    required bool isPositioningAvailable,
    required bool hasPermissionsGranted,
  }) {
    if (mounted) {
      setState(() {
        _canLocateUserPosition = isPositioningAvailable && hasPermissionsGranted;
        _startPositioning(context);
      });
    }
  }

  void _initialiseUserPositioning() {
    _servicesStatusNotifier = DeviceLocationServicesStatusNotifier();
    _servicesStatusNotifier!.start(this);
    _servicesStatusNotifier!.canLocateUserPositioning().then((value) {
      if (mounted) {
        setState(() => _canLocateUserPosition = value);
      }
    });
  }

  Future<void> _startPositioning(
    BuildContext context, {
    bool simulated = false,
    Navigation.LocationSimulatorOptions? options,
  }) async {
    _locationProvider = createLocationProvider(
      route: hereRouteController.route.value,
      simulated: simulated,
      simulatorOptions: options,
    );
    _locationProvider?.addListener(this);
    _locationProvider?.addListener(_visualNavigator);
    _locationProvider?.start();
  }

  @override
  void onLocationUpdated(Location location) {
    if (_currentLocationForLocationStatus == null) {
      _currentLocationForLocationStatus = location;
      // hereRouteController.currentLocationHeading?.value = location;
      _servicesStatusNotifier?.onLocationReceived(location);
    }
  }
}

extension _ManeuverImagePath on Routing.ManeuverAction {
  String get imagePath {
    final String subDir = PlatformDispatcher.instance.platformBrightness == Brightness.light ? "dark" : "light";
    return "assets/maneuvers/$subDir/png/${toString().split(".").last}.png";
  }
}
