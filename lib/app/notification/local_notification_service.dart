import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:template/shared/resources/routes_manager.dart';

import '../../shared/resources/color_manager.dart';
import '../my_app.dart';

class LocalNotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
      '01', // id
      'High Importance Notifications', // title
      importance: Importance.high,
      playSound: true);

  Future<void> initialize() async {
    try {
      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: AndroidInitializationSettings("@mipmap/ic_launcher"),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestAlertPermission: true,
          requestBadgePermission: true,
        ),
      );

      NotificationAppLaunchDetails? notificationAppLaunchDetails =
          await notificationsPlugin.getNotificationAppLaunchDetails();

      if (notificationAppLaunchDetails != null &&
          notificationAppLaunchDetails.didNotificationLaunchApp) {
        // onTapLocalNotification(
        //     notificationAppLaunchDetails.notificationResponse!);
      }

      await notificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: onTapLocalNotification,
      );
    } catch (e) {
      debugPrint('Failed to initialize notifications: $e');
    }
  }

  void onTapLocalNotification(NotificationResponse notificationResponse) async {
    var payload = notificationResponse.payload??'';

    if ( payload.isNotEmpty) {
      await MyApp.navigatorKey.currentState?.pushNamed(Routes.chatRoomRoute,
          arguments: {'senderId': payload});
    }
  }

  Future<NotificationDetails> _notificationDetails() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(channel.id, channel.name,
            color: ColorManager.primary,
            playSound: true,
            icon: '@mipmap/ic_launcher');

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    return notificationDetails;
  }

  Future<void> showLocalNotifications({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      final platformChannelSpecifics = await _notificationDetails();
      await notificationsPlugin.show(
        id,
        title,
        body,
        platformChannelSpecifics,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Failed to show notification: $e');
    }
  }
}
