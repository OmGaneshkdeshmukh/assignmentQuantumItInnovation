//Author : Omganesh K.Deshmukh
//Date :03/04/2025
//This Screen Represent the Main File.

// Importing Flutter material package for UI components
import 'package:flutter/material.dart';

// Importing Flutter local notifications package to handle notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Importing GetX packages for state management and routing
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

// Importing timezone package for handling timezone-related tasks
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// Importing the task controller and home screen UI
import 'package:todoapp/controller/task_controller.dart';
import 'package:todoapp/view/home_screen.dart';

// Creating an instance of FlutterLocalNotificationsPlugin to handle notifications
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Ensure Flutter widgets are initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize and register TaskController with GetX dependency injection
  Get.put(TaskController());

  // Initialize timezone data and set the local timezone for scheduling notifications correctly
  tz.initializeTimeZones();
  final String timeZoneName = tz.local.name;
  tz.setLocalLocation(tz.getLocation(timeZoneName));

  // Android-specific notification settings using app launcher icon
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // General initialization settings for all platforms (only Android here)
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Initialize the notification plugin with the specified settings
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Define an Android notification channel for task reminders with high importance
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'task_channel_id',
    'Task Notifications',
    description: 'Reminders for your tasks',
    importance: Importance.max,
  );

  // Create the notification channel on Android devices
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Code to request notification permissions (commented out)
  // If permissions are denied, it logs a message
  /*
  if (await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestPermission() !=
      true) {
    print("Notification permission not granted");
  }
  */
  // Run the app using GetMaterialApp with the HomeScreen as the start screen
  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}
