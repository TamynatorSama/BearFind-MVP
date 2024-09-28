import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';




Future<String> deviceInfo()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    return deviceInfo.deviceInfo.then((value) {
      String encodedValue = jsonEncode(value.data);
        return base64Encode(encodedValue.codeUnits);
    });
  }

  
class PushNotificationHandler {
  static late FirebaseMessaging messaging;
  static late Stream<RemoteMessage> foregroundMessages;

  static initMessaging() async {
    messaging = FirebaseMessaging.instance;
    foregroundMessages = FirebaseMessaging.onMessage;

    foregroundMessages.listen(_fcmForegroundHandler);
    // print(await generateDeviceToken());
    // print("device");

    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  }

  @pragma('vm:entry-point')
  static Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    print("onBackgroundMessage: ${message.data}");
    await handleNotifications(payload: message.data);
  }

  //handle fcm notification when app is open
  static Future<void> _fcmForegroundHandler(RemoteMessage message) async {
    print("onMessage: ${message.data}");
    await handleNotifications(payload: message.data);
  }

  static handleNotifications({required Map<String, dynamic> payload}) async {
    // await AwesomeNotificationsHelper.showNotification(
    //   title: payload["topic"] ?? "Login Successful",
    //   body:
    //       payload["message"] ?? "You have just logged in to your MonieTracka acct",
    //   // bigPicture: payload["image"] ?? "",
    //   // payload: Map<String, String>.from(payload),
    // );
  }

  static Future<String?> generateDeviceToken() async {
    return await messaging.getToken();
  }
}


