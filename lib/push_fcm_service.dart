import 'dart:async';

// import 'package:firebase_messaging/firebase_messaging.dart';

class FCM {
  // late final FirebaseMessaging _firebaseMessaging;
  final streamCtlr = StreamController<String>.broadcast();

  static Future<dynamic> onBackgroundMessage(
      Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      // final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      // final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  // Future<dynamic> onBackgroundMessageHandler(RemoteMessage message) async {
  //   print('on Background $message');
  // }

  setNotifications() {
    // _firebaseMessaging.configure(
    //   onMessage: (message) async {
    //     print("onMessage: $message");
    //     streamCtlr.sink.add(message['data']['msg']);
    //   },
    //   onBackgroundMessage: onBackgroundMessage,
    //   onLaunch: (message) async {
    //     print("onLaunch: $message");
    //   },
    //   onResume: (message) async {
    //     print("onResume: $message");
    //   },
    // );

    // final token = _firebaseMessaging
    //     .getToken()
    //     .then((value) => print("Jeton de cles : $value"));
  }

  dispose() {
    streamCtlr.close();
  }
}
