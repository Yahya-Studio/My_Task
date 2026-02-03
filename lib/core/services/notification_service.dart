import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();
    // Default to local timezone, can be configured
    // tz.setLocalLocation(tz.getLocation('Africa/Cairo'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          linux: LinuxInitializationSettings(
            defaultActionName: 'Open notification',
          ),
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification tap
      },
    );

    await _requestPermissions();
  }

  static Future<void> _requestPermissions() async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) return;
    await Permission.notification.request();
    await Permission.scheduleExactAlarm.request();
  }

  static Future<void> scheduleTaskNotifications({
    required int taskId,
    required String title,
    required DateTime dueTime,
  }) async {
    // Notification ID scheme:
    // TaskID * 10 + 0 = Exact due time
    // TaskID * 10 + 1 = 30 mins before

    final now = DateTime.now();

    // 1. Notification at exact due time
    if (dueTime.isAfter(now)) {
      await _scheduleNotification(
        id: taskId * 10,
        title: 'Task Due: $title',
        body: 'Your task is due now!',
        scheduledTime: dueTime,
      );
    }

    // 2. Notification 30 mins before
    final reminderTime = dueTime.subtract(const Duration(minutes: 30));
    if (reminderTime.isAfter(now)) {
      await _scheduleNotification(
        id: taskId * 10 + 1,
        title: 'Upcoming Task: $title',
        body: '30 minutes remaining for your task.',
        scheduledTime: reminderTime,
      );
    }
  }

  static Future<void> cancelTaskNotifications(int taskId) async {
    await _notificationsPlugin.cancel(taskId * 10);
    await _notificationsPlugin.cancel(taskId * 10 + 1);
  }

  static Future<void> _scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel_id',
          'Task Notifications',
          channelDescription: 'Notifications for task reminders',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
