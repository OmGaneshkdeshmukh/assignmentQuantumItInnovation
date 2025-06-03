// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//     );

//     await _notificationsPlugin.initialize(initSettings);
//     tz.initializeTimeZones(); // initialize timezones for scheduling
//   }

//   static Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//   }) async {
//     await _notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       const NotificationDetails(
//         android: AndroidNotificationDetails(
//           'task_channel_id',
//           'Task Reminders',
//           importance: Importance.max,
//           priority: Priority.high,
//         ),
//       ),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
// }

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter/material.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const InitializationSettings initSettings = InitializationSettings(
//       android: androidSettings,
//     );

//     await _notificationsPlugin.initialize(initSettings);

//     // ✅ Request notification permission (for Android 13+)
//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestPermission();
//   }

//   static Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//   }) async {
//     const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
//       'task_channel',
//       'Task Notifications',
//       importance: Importance.max,
//       priority: Priority.high,
//     );

//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidDetails);

//     await _notificationsPlugin.show(id, title, body, notificationDetails);
//   }

//   // You can also add a method to schedule notifications here
// }

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/main.dart';

class NotificationService {
  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Notifications',
          channelDescription: 'Test channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );

    //   await flutterLocalNotificationsPlugin.zonedSchedule(
    //     id,
    //     title,
    //     body,
    //     tz.TZDateTime.from(scheduledTime, tz.local),
    //     const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         'task_channel_id',
    //         'Task Notifications',
    //         channelDescription: 'Reminders for your tasks',
    //         importance: Importance.max,
    //         priority: Priority.high,
    //       ),
    //     ),
    //     uiLocalNotificationDateInterpretation:
    //     UILocalNotificationDateInterpretation.absoluteTime,
    // androidAllowWhileIdle: true,

    //   );
  }

  static Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
