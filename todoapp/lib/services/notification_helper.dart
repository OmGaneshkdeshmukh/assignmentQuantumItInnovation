import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<bool> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    if (Platform.version.contains('13')) {
      // Android 13+ requires runtime permission
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        status = await Permission.notification.request();
      }
      return status.isGranted;
    }
    return true; // No runtime permission required before Android 13
  } else if (Platform.isIOS) {
    final iosPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    final macPlugin = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            MacOSFlutterLocalNotificationsPlugin>();
    return await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true) ?? 
           await macPlugin?.requestPermissions(alert: true, badge: true, sound: true) ?? 
           true;
  }

  return true; // Other platforms (Web, Linux, etc.)
}
