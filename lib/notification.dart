import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

import 'notification_messages.dart';

Future<void> messageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  Data notificationMessage = Data.fromJson(message.data);
  debugPrint('notification from background : ${notificationMessage.title}');
}

void firebaseMessagingListener() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    Data notificationMessage = Data.fromJson(message.data);
    debugPrint('notification from foreground : ${notificationMessage.title}');
  });
}

Future<void> sendNotification() async {
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  Dio dio = Dio();

  var token = await getDeviceToken();
  debugPrint('device token : $token');

  final data = {
    "data": {
      "message": "Accept Ride Request",
      "title": "This is Ride Request",
    },
    "to": token
  };

  dio.options.headers['Content-Type'] = 'application/json';
  dio.options.headers["Authorization"] = 'key=AAAAtpWFSOQ:APA91bFWlPxrzF0zFh_lHkBJQ31uSKJ7vX9buEVr3PEbKwfTePLR3Zbx4G1odrE6XWA4VXeF42PgbJZrvMRRjoUytOBgzGNi1CoMB6fy197gdlNH3uPdsSrg8ni_eWR3VCDVTsDfWxG5';

  try {
    final response = await dio.post(postUrl, data: data);

    if (response.statusCode == 200) {
      debugPrint('Request Sent To Driver');
    } else {
      debugPrint('notification sending failed');
    }
  } catch (e) {
    debugPrint('exception $e');
  }
}

Future<String?> getDeviceToken() async {
  return await FirebaseMessaging.instance.getToken();
}
