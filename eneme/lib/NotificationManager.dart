import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification plugin
  Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Schedule a notification
  Future<void> scheduleNotification(DateTime scheduledTime) async {
    tz.initializeTimeZones();
    var androidDetails = const AndroidNotificationDetails(
      'channel_id', 
      'channel_name', 
      channelDescription: 'channel_description',
      importance: Importance.high,
      priority: Priority.high,
    );

    var platformDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, 
      'Helloo Darius', 
      'It\'s time for your scheduled task!', 
      tz.TZDateTime.from(scheduledTime, tz.local), 
      platformDetails, 
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
