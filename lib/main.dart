/// The `BethelFarmApp` class represents the main application widget.
///
/// It initializes the app's state, observes lifecycle changes, and builds the
/// application's UI using `MultiProvider` for dependency injection and `GetMaterialApp`
/// for navigation and localization.
///
/// Key features:
/// - Observes app lifecycle states to handle foreground and background transitions.
/// - Provides localization support and theme configuration.
/// - Integrates Firebase and HERE SDK for app functionality.
/// - Uses `MultiProvider` to manage state and dependencies.

import 'package:bethel_farm/app/bindings/base_binding.dart';
import 'package:bethel_farm/data/local/preference_manager.dart';
import 'package:bethel_farm/core/utils/firebase_options.dart';
import 'package:bethel_farm/app/controllers/dashboard_module_controller/dashboard_controller.dart';
import 'package:bethel_farm/modules/notifications/notifications_controller.dart';
import 'package:bethel_farm/themes/app_themes.dart';
import 'package:bethel_farm/utils/exports.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/core.engine.dart';
import 'package:here_sdk/core.errors.dart';
import 'package:provider/provider.dart';

import 'here_map_module/common/application_preferences.dart';
import 'here_map_module/common/custom_map_style_settings.dart';
import 'here_map_module/positioning/positioning_engine.dart';
import 'here_map_module/route_preferences/route_preferences_model.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // getNotificationAndOtherData();
}

void _initializeHERESDK() async {
  // Initialize HERE SDK before accessing any functionality
  SdkContext.init(IsolateOrigin.main);

  // Set your credentials for the HERE SDK
  String accessKeyId = "";
  String accessKeySecret = "";
  SDKOptions sdkOptions = SDKOptions.withAccessKeySecretAndCachePath(accessKeyId, accessKeySecret, "cachePath");

  try {
    await SDKNativeEngine.makeSharedInstance(sdkOptions);
  } on InstantiationException {
    throw Exception("Failed to initialize the HERE SDK.");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initializeHERESDK();
  await Firebase.initializeApp(
    name: 'farmsync',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (kDebugMode) {
    print('Permission granted: ${settings.authorizationStatus}');
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('onMessage: $message');
    getNotificationAndOtherData();
  });
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const BethelFarmApp());
}

void getNotificationAndOtherData() async {
  PreferenceManager preferenceManager = Get.find(tag: (PreferenceManager).toString());
  var isLoggedIn = await preferenceManager.getString(PreferenceManager.isLoggedIn);
  if (isLoggedIn == "true") {
    Get.put(NotificationsController()).getNotifications();
    Get.put(DashboardController()).getBubbleCount();
  }
}

class BethelFarmApp extends StatefulWidget {
  const BethelFarmApp({super.key});

  @override
  State<BethelFarmApp> createState() => _BethelFarmAppState();
}

class _BethelFarmAppState extends State<BethelFarmApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    if (state == AppLifecycleState.resumed) {
      // App is in the foreground
      print('App is in the foreground');
      getNotificationAndOtherData();
    } else {
      // App is in the background
      print('App is in the background');
      getNotificationAndOtherData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => RecentSearchDataModel()),
        ChangeNotifierProvider(create: (context) => RoutePreferencesModel.withDefaults()),
        // ChangeNotifierProvider(create: (context) => MapLoaderController()),
        ChangeNotifierProvider(create: (context) => AppPreferences()),
        Provider(create: (context) => PositioningEngine()),
        ChangeNotifierProvider(create: (context) => CustomMapStyleSettings()),
      ],
      child: GetMaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'U'),
          ],
          onGenerateTitle: (BuildContext context) => "Farm Sync" /*AppLocalizations.of(context)!.appTitle*/,
          getPages: AppPages.ROUTES,
          builder: FlutterSmartDialog.init(),
          initialRoute: AppPages.INITIAL,
          initialBinding: BaseBinding(),
          debugShowCheckedModeBanner: false,
          darkTheme: AppThemes.light,
          theme: ThemeData(fontFamily: 'Poppins'),
          themeMode: ThemeMode.light),
    );
  }
}
