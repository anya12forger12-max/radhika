import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:radhika/models/reminder.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  static final NotificationService instance = NotificationService._();
  NotificationService._();

  Future<void> init() async {
    if (_initialized) return;

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

    final delay = reminderDate.difference(now);
    await Future.delayed(delay, () async {
      await showPeriodReminder(
        id: daysBefore,
        title: 'Period Reminder',
        body: daysBefore == 0
            ? 'Your period is expected to start today.'
            : 'Your period is expected in $daysBefore day${daysBefore > 1 ? 's' : ''}.',
      );
    });
  }

  Future<void> cancelNotification(int id) async {
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
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
