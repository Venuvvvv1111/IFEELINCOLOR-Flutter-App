import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ifeelin_color/firebase_options.dart';
import 'package:ifeelin_color/screens/common_screens/no_internet_screen/no_internet_screen.dart';
import 'package:ifeelin_color/utils/Route/app_routes.dart';
import 'package:ifeelin_color/utils/Route/route_helper.dart';
import 'package:ifeelin_color/utils/constants/user_data.dart';

import 'package:ifeelin_color/utils/helpers/custom_colors.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> screenNavigatorKey =
    GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@drawable/ic_notification');

  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings();

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'IFEELINCOLOR', // id
    'IFEELINCOLOR', // name

    importance: Importance.defaultImportance,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init('user_data');
  await GetStorage.init();
  // Get.put(UserInfo());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  initializeNotifications();

  await FirebaseMessaging.instance
      .requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: true,
    sound: true,
  )
      .then((settings) {
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print("User granted permission");
      }
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      if (kDebugMode) {
        print("User denied permission");
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print("User granted provisional permission");
      }
    }
  }).catchError((e) {
    if (kDebugMode) {
      print("Error requesting permission: $e");
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.instance.getToken().then((token) {
    if (kDebugMode) {
      print("FCM Token: $token");
    }
  });

  /*await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );*/
  if (Platform.isIOS) {
    FirebaseMessaging.instance.getAPNSToken().then((apnsToken) {
      if (kDebugMode) {
        print('APNs Token: $apnsToken');
      }
    });
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    // Handle errors gracefully
    if (kDebugMode) {
      print(details.toString());
    }
  };
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const MyApp());
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('before _firebaseMessagingBackgroundHandler');
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    print('after _firebaseMessagingBackgroundHandler');
    print(message);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isOnline;
  @override
  void initState() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'IFEELINCOLOR', // id
        'IFEELINCOLOR', // name
        // description
        importance: Importance.high,
      );

      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title,
          message.notification!.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: '@drawable/ic_notification',
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print("App opened from notification: ${message.data}");
      }
      if (message.notification != null) {
        // Handle notification tap when the app is in background or terminated
      }
    });
    super.initState();
    // initConnectivity();
  }

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Couldn\'t check connectivity status $e');
      }
      return;
    }

    if (!mounted) {
      return;
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');

    if (_connectionStatus.contains(ConnectivityResult.none)) {
      if (kDebugMode) {
        print('no connectivity ');
      }
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "no connection")));
      // Navigator.pushNamed(context, AppRoutes.noInternet);
      navigatorKey.currentState
          ?.push(MaterialPageRoute(builder: (_) => const NoInternetScreen()));
    }
  }

  final RouteObserver<PageRoute> routeObserver = RouteLogger();
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: GetMaterialApp(
        navigatorKey: navigatorKey,
        navigatorObservers: [routeObserver],
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter.generateRoute,
        theme: themdata(context),
      ),
    );
  }

  ThemeData themdata(BuildContext context) {
    return ThemeData(
      textTheme: const TextTheme(
        // Display Text Styles
        displayLarge: TextStyle(fontSize: 48.0, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 36.0, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),

        // Headline Text Styles
        headlineLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),

        // Title Text Styles
        titleLarge: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        titleSmall: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),

        // Body Text Styles
        bodyLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal),
        bodyMedium: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
        bodySmall: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),

        // Label Text Styles
        labelLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        labelMedium: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal),
        labelSmall: TextStyle(fontSize: 10.0, fontWeight: FontWeight.normal),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        foregroundColor: whiteColor,
        backgroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        textStyle: Theme.of(context).textTheme.titleSmall,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      )),
      colorScheme: ColorScheme.fromSeed(seedColor: whiteColor),
      useMaterial3: true,
    );
  }
}

class RouteLogger extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (kDebugMode) {
      print('Popped route: ${route.settings.name}');
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (kDebugMode) {
      print('Pushed route: ${route.settings.name}');
    }
  }
}
