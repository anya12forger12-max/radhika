import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:radhika/services/storage_service.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static const int _id3DaysBefore = 1001;
  static const int _id2DaysBefore = 1002;
  static const int _idDayOf = 1003;

  static final NotificationService instance = NotificationService._();
  NotificationService._();

  bool get isInitialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } catch (e) {
      debugPrint('Failed to load local timezone, using UTC: $e');
      tz.setLocalLocation(tz.UTC);
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
      macOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {}

  Future<void> showPeriodReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    await _showNotification(
      id: id,
      title: title,
      body: body,
    );
  }

  Future<void> showDailyReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    await _showNotification(
      id: id,
      title: title,
      body: body,
    );
  }

  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'radhika_reminders',
      'Period Reminders',
      channelDescription: 'Notifications for period predictions and reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _plugin.show(id, title, body, details);
  }

  Future<void> schedulePeriodReminder({
    required int daysBefore,
    required DateTime predictedDate,
  }) async {
    final reminderDate =
        predictedDate.subtract(Duration(days: daysBefore));
    final now = DateTime.now();

    if (reminderDate.isBefore(now)) return;

    final title = 'Period Reminder';
    final body = daysBefore == 0
        ? 'Your period is expected to start today.'
        : 'Your period is expected in $daysBefore day'
            '${daysBefore > 1 ? 's' : ''}.';

    const androidDetails = AndroidNotificationDetails(
      'radhika_reminders',
      'Period Reminders',
      channelDescription: 'Notifications for period predictions and reminders',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );

    await _plugin.zonedSchedule(
      _idFor(daysBefore),
      title,
      body,
      tz.TZDateTime.from(reminderDate, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  int _idFor(int daysBefore) {
    switch (daysBefore) {
      case 3:
        return _id3DaysBefore;
      case 2:
        return _id2DaysBefore;
      default:
        return _idDayOf;
    }
  }

  Future<void> cancelPeriodReminders() async {
    await _plugin.cancel(_id3DaysBefore);
    await _plugin.cancel(_id2DaysBefore);
    await _plugin.cancel(_idDayOf);
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> reschedulePeriodReminders({
    required ReminderPreferences prefs,
    required DateTime predictedDate,
  }) async {
    if (!_initialized) return;
    try {
      await cancelPeriodReminders();
      if (!prefs.anyEnabled) return;
      if (prefs.remind3DaysBefore) {
        await schedulePeriodReminder(
            daysBefore: 3, predictedDate: predictedDate);
      }
      if (prefs.remind2DaysBefore) {
        await schedulePeriodReminder(
            daysBefore: 2, predictedDate: predictedDate);
      }
      if (prefs.remindDayOf) {
        await schedulePeriodReminder(
            daysBefore: 0, predictedDate: predictedDate);
      }
    } catch (e) {
      debugPrint('Failed to reschedule period reminders: $e');
    }
  }

  Future<bool> requestPermissions() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      await ios.requestPermissions(alert: true, badge: true, sound: true);
    }
    return true;
  }
}
