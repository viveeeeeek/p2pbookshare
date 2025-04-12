// Package imports:
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:p2pbookshare/core/constants/app_route_constants.dart';
import 'package:http/http.dart' as http;
import 'package:p2pbookshare/core/constants/model_constants.dart';
import 'package:p2pbookshare/services/firebase/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  var logger = Logger();

  /// Get the device token
  Future<String> getDeviceToken() async {
    const _deviceTokenKey = 'device_token';
    const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
    FirebaseUserService _userServices = FirebaseUserService();

    String? deviceToken = await _secureStorage.read(key: _deviceTokenKey);
    if (deviceToken != null && deviceToken.isNotEmpty) {
      final _fetchUserDeviceToken = await _userServices
          .getUserDeviceToken(FirebaseAuth.instance.currentUser!.uid);
      if (_fetchUserDeviceToken != deviceToken) {
        await _userServices.updateUserDeviceToken(
            FirebaseAuth.instance.currentUser!.uid, deviceToken);
      }
      logger.d(
          'Device Token fetched from Flutter Secured Storage & it matches token stored in firebase:\n$deviceToken');
      return deviceToken;
    } else {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _secureStorage.write(key: _deviceTokenKey, value: token);
        _userServices.updateUserDeviceToken(
            FirebaseAuth.instance.currentUser!.uid, token);
        logger.d(
            'Device Token saved to Flutter Secured Storage & User document in Firebase:\n$token');
      }
      return token!;
    }
  }

  /// Check if the token is refreshed if yes assign the new token
  // void isTokenrefreshed() {
  //   _firebaseMessaging.onTokenRefresh.listen((event) {
  //     logger.d('Token Refreshed: $event');
  //   });
  // }
  // void isTokenRefreshed() {
  //   _firebaseMessaging.onTokenRefresh.listen((event) async {
  //     String newToken = await getDeviceToken();
  //     logger.d('Token Refreshed: $newToken');

  //     // Get the current user's ID from Firebase Authentication
  //     String? userId = FirebaseAuth.instance.currentUser?.uid;
  //     if (userId != null) {
  //       // Update the device token in the user document in Firestore
  //       await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(userId)
  //           .update({
  //         'deviceToken': newToken,
  //       });
  //     } else {
  //       logger.e('No user signed in. Unable to update device token.');
  //     }
  //   });
  // }

  /// Initialize the local notifications
  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@drawable/ic_launcher_monochrome');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  /// Show the notification
  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      message.notification!.android!.channelId.toString(),
      message.notification!.android!.channelId.toString(),
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      priority: Priority.high,
      importance: Importance.high,
      ticker: 'ticker',
    );
    const DarwinNotificationDetails iOSNotificationDetails =
        DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound:
                true); // We wont be needing this as ios handles itself for firebase notifications

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iOSNotificationDetails);

    // Show the notification with payload when the app is in foreground
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  /// Initialize the firebase messaging
  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d(
          'Got a message!\n Title: ${message.notification!.title}\n Body: ${message.notification!.body}\n Data type: ${message.data['type']}\n Data chatroomId: ${message.data['chatroomId']}');
      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
      }
    });
  }

  Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    logger.d('Handling a message: ${message.notification!.title}');

    if (message.data['type'] == 'chat') {
      context.pushNamed(
        AppRouterConstants.chatView,
        pathParameters: {
          'receiverId': message.data[UserConstants.userUid],
          'receiverName': message.data[UserConstants.displayName],
          'chatRoomId': message.data[ChatRoomConfig.chatRoomId],
          'receiverimgUrl': message.data[UserConstants.profilePictureUrl],
          'bookId': message.data[ChatRoomConfig.bookId],
        },
      );
    } else if (message.data['type'] == 'notification') {
      // Handle the notification message
    }
  }

  Future<void> setupInteractMessage(BuildContext context) async {
    // Handle messages when the app is in terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null && context.mounted) {
      handleMessage(context, initialMessage);
    }

    // Handle messages when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {
      handleMessage(context, event);
    });
  }

  Future<void> sendChatNotification(
      String title,
      String body,
      String accessToken,
      String targetDeviceToken,
      String chatRoomId,
      String receiverId,
      String receiverName,
      String receiverimgUrl,
      String bookId) async {
    final firebaseProjectId = dotenv.get('FIREBASAE_PROJECT_ID');
    final fcmNotificationEndpoint =
        'https://fcm.googleapis.com/v1/projects/$firebaseProjectId/messages:send';

    /// Add authorization,content-type and host headers
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Host': 'fcm.googleapis.com'
    };

    final fcmNotificationBody = {
      "message": {
        "token": targetDeviceToken,
        "notification": {"body": body, "title": title},
        "data": {
          "type": "chat",
          ChatRoomConfig.chatRoomId: chatRoomId,
          UserConstants.userUid: FirebaseAuth.instance.currentUser!.uid,
          UserConstants.displayName: receiverName,
          UserConstants.profilePictureUrl: receiverimgUrl,
          ChatRoomConfig.bookId: bookId
        }
      }
    };

    try {
      await http.post(Uri.parse(fcmNotificationEndpoint),
          headers: headers, body: jsonEncode(fcmNotificationBody));
    } catch (e) {
      // Handle the exception here
      logger.d('Exception occurred: $e');
    }
  }

  /// Method check if app is launched for first time and subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    const _firstTimeLaunchKey = 'first_time_launch';
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool? firstTimeLaunch = prefs.getBool(_firstTimeLaunchKey);
    if (firstTimeLaunch == null || !firstTimeLaunch) {
      prefs.setBool(_firstTimeLaunchKey, false);
      _firebaseMessaging.subscribeToTopic(topic);
      logger.i('Subscribed to topic: $topic');
    }
  }
}
