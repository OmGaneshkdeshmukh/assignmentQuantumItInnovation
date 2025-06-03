import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:todoapp/controller/task_controller.dart';
import 'package:todoapp/view/home_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TaskController()); 
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


