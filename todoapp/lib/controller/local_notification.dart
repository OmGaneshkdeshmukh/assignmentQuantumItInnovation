//Author : Omganesh K.Deshmukh
//Date :03/04/2025
//This Screen Represent the Notification Controller .

// Import the flutter_local_notifications package to handle local notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// Import the permission_handler package to request and check permissions at runtime
import 'package:permission_handler/permission_handler.dart';
// Import the rxdart package to use BehaviorSubject for handling notification tap events
import 'package:rxdart/rxdart.dart';


class LocalNotification {
  // Instance of FlutterLocalNotificationsPlugin to manage notifications
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // BehaviorSubject to stream payload data when notification is tapped
  static final onClickNotification = BehaviorSubject<String>();

  // Called when user taps on the notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // Initialization method to set up notification settings
  static Future init() async {
    // Request notification permission for Android 13+ (API 33+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // Android-specific initialization settings using default app icon
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS-specific initialization settings (Darwin = iOS/macOS)
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    // Linux-specific initialization settings
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');

    // Combine all platform settings into one InitializationSettings object
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      linux: initializationSettingsLinux,
    );

    // Initialize plugin with the settings and notification tap handlers
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap, // Foreground tap
      onDidReceiveBackgroundNotificationResponse: onNotificationTap, // Background tap
    );
  }

  /// Function to show a simple notification with title, body, and payload
  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    // Define Android notification channel and details
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'your channel id', // Channel ID
          'your channel name', // Channel name shown to user
          channelDescription: 'your channel description', // Optional description
          importance: Importance.max, // High importance = Heads-up notification
          priority: Priority.high, // High priority
          ticker: 'ticker', // Status bar ticker text
        );

    // Combine platform-specific details into one
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    // Show the notification immediately
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
