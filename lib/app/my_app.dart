import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:template/app/service_locator.dart';
import 'package:template/app/singlton.dart';

import '../shared/resources/routes_manager.dart';
import '../shared/resources/theme_manager.dart';
import 'notification/local_notification_service.dart';

class MyApp extends StatefulWidget {
  //to create singleton instance of MyApp
  //need to create name constructor
  MyApp._internal();
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: 'Main Navigator');
  factory MyApp() =>
      MyApp._internal(); //this to help to create singleton instance

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
      getToken();
    initLocalNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        // designSize: const Size(400, 860),
        minTextAdapt: true,
        splitScreenMode: true,
        useInheritedMediaQuery: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            navigatorObservers: [FlutterSmartDialog.observer],
            builder: FlutterSmartDialog.init(),
            theme: getAppTheme(),
            onGenerateRoute: RouteGenerator.getRoute,
            initialRoute: Routes.splashRoute,
          );
        });
  }



    void getToken() async {
    await Firebase.initializeApp();
    Singleton().fcmToken = await locator<FirebaseMessaging>() .getToken() ?? '';

    if (Singleton().fcmToken.isNotEmpty) {
      debugPrint('TOKEN FCM: ${Singleton().fcmToken}');
    }
  }

  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      playSound: true);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void initLocalNotification() async {
    await Firebase.initializeApp();
    // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    _requestNotificationPermission();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // reservation order floor

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      if (message.data['body'] != null) {
        // notificationData =
        //     NotificationData.fromJson(json.decode(message.data['body']));

        String senderId=message.data['senderId'] ?? '';

        LocalNotificationService().showLocalNotifications(
            id: message.hashCode,
            title:message.data['title'],
            body: message.data['body'],
            payload: senderId);
      }
      debugPrint(message.data.toString());
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {});
  }

  // get permsion for notification
  Future<void> _requestNotificationPermission() async {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });
  }
}
