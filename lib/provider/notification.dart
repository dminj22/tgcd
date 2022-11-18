import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationProvider extends ChangeNotifier {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  notificationRequestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  /// ForeGround Notification
  foregroundNotification() {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    print("ForeBackGround Initiate>>>>>>>>>>>>>>>>>>>");
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
        print(
            'Message also contained a notification: ${message.notification!.title}');
        print('Message also contained a notification: ${message.data}');
      }
    });
  }

  ///Background Notification

}


Future<void> _firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {
  await Firebase.initializeApp();
}

backgroundNotification() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}