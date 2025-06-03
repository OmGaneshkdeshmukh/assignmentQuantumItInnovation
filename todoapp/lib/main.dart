// // main.dart
// import 'package:flutter/material.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:todoapp/controller/notification_service.dart';
// import 'view/home_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await NotificationService.initialize();
//   runApp(ToDoApp());
// }


// class ToDoApp extends StatelessWidget {
//   const ToDoApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'ToDo List',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: const HomeScreen(),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// import 'package:todoapp/view/home_screen.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // Timezone initialization
//   tz.initializeTimeZones();
//   final String timeZoneName = tz.local.name;
//   tz.setLocalLocation(tz.getLocation(timeZoneName));

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);

//  runApp(
//     const GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: HomeScreen(),
//     ),
//   );
// }



import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/view/home_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();
  final String timeZoneName = tz.local.name;
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // ✅ Create Android notification channel
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'task_channel_id',
    'Task Notifications',
    description: 'Reminders for your tasks',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // ✅ Request permission and handle denial
  // if (await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.requestPermission() !=
  //     true) {
  //   print("Notification permission not granted");
  // }

  // ✅ Optionally test a notification after permission granted
  await flutterLocalNotificationsPlugin.show(
    0,
    'Test Notification',
    'This is a test notification',
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel_id',
        'Task Notifications',
        channelDescription: 'Test notification channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}


