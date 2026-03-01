import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static StreamController<NotificationResponse> streamController =
  StreamController();
  static void onTap(NotificationResponse notificationResponse) {
    // log(notificationResponse.id!.toString());
    // log(notificationResponse.payload!.toString());
    streamController.add(notificationResponse);
    // Navigator.push(context, route);
  }

  static Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap, settings:settings ,
    );
  }

  //basic Notification
  static void showBasicNotification(RemoteMessage message) async {
    BigPictureStyleInformation? bigPictureStyleInformation;

    final imageUrl = message.notification?.android?.imageUrl;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      try {
        final http.Response image = await http.get(Uri.parse(imageUrl));
        bigPictureStyleInformation = BigPictureStyleInformation(
          ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(image.bodyBytes),
          ),
          largeIcon: ByteArrayAndroidBitmap.fromBase64String(
            base64Encode(image.bodyBytes),
          ),
        );
      } catch (e) {
        print("Image load failed: $e");
      }
    }

    AndroidNotificationDetails android = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: bigPictureStyleInformation,
      playSound: true,
    );

    NotificationDetails details = NotificationDetails(android: android);

    await flutterLocalNotificationsPlugin.show(
      id: 1,
    title:   message.notification?.title,
     body:  message.notification?.body,
    notificationDetails:  details,
    );
  }

}