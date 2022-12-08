import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../get_storage_services/get_storage_service.dart';

class AppNotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      // 'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true);

  static void showMsgHandler() {
    print('call when app in fore ground');
    try {
      FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
        RemoteNotification? notification = message!.notification;

        print('msg data of noti   ${message.data}');
        showMsgNormal(notification!, message);
      });
    } on FirebaseException catch (e) {
      print('notification 6 ${e.message}');
    }
  }

  /// handle notification when app in fore ground..///close app

  static void getInitialMsg() {
    print('handle notification when app in fore ground..///close app');
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        print('------RemoteMessage message------$message');

        if (message != null) {
          //  FlutterRingtonePlayer.stop();

        }
      },
    );
  }

  static void showMsgNormal(
      RemoteNotification notification, RemoteMessage msg) {
    print('MESSAGE NORMAL SHOW');
    try {
      //var data = jsonDecode(notification.body!);
      String screen = jsonEncode(msg.data);
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel', // id
              'High Importance Notifications', // title
              importance: Importance.high,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: IOSNotificationDetails(),
          ),
          payload: screen);
    } on FirebaseException catch (e) {
      print('notification 3 ${e.message}');
    }
  }

  // ///background notification handler..  when app in background
  // Future<dynamic> notificationTap(paylode) async {
  //   if (paylode == "Notification_screen") {
  //     Get.to(() => BottomNavScreen(
  //           index: 3,
  //         ));
  //   }
  // }

  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    try {
      print('background notification handler..');
      await Firebase.initializeApp();
      print('Handling a background message ${message.messageId}');
      RemoteNotification? notification = message.notification;
      // print(
      //     '--------split body ${notification!.body.toString().split(' ').first}');
      // var data = jsonDecode(notification.body!);
      //showMsgNormal(notification!);

      // if (data['msg'].toString().contains('Following You') ||
      //     data['channelName'].toString().contains('streaming')) {
      //   print('ShowNormalMassage2');
      // } else {}
    } on FirebaseException catch (e) {
      print('notification 1 ${e.message}');
    }
  }

  ///call when click on notification back

  static void onMsgOpen() {
    print('call when click on notification back');
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        print('listen->${message.data}');

        if (message != null) {
          print("action======2=== ${message.data['click_action']}");
        }
      },
    );
  }

  ///call when app in fore ground
  static Future getFcmToken() async {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      String? token = await firebaseMessaging.getToken();

      // log('--------get fcm pref ${GetStorageServices.getFcmToken()}');
      log("=========fcm-token===$token");
      await GetStorageServices.setFcm(token!);

      return token;
    } catch (e) {
      return null;
    }
  }
}
