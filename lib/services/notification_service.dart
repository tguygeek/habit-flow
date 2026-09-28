import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

/// Service for managing local notifications using [FlutterLocalNotificationsPlugin].
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize the notification service.
  /// Must be called before using any other methods.
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone support
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    const DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    _isInitialized = true;
  }

  /// Schedule a reminder notification at [reminderHour]:[reminderMinute]
  /// Repeats every hour until the task is marked as done.
  Future<void> scheduleReminder({
    required String habitId,
    required String habitName,
    required int reminderHour,
    required int reminderMinute,
  }) async {
    if (!_isInitialized) await initialize();

    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);

    // Calculate today's reminder time
    DateTime reminderDateTime =
        today.add(Duration(hours: reminderHour, minutes: reminderMinute));

    // If the time has already passed today, schedule for tomorrow
    if (reminderDateTime.isBefore(now)) {
      reminderDateTime = reminderDateTime.add(const Duration(days: 1));
    }

    // Schedule notifications every hour starting from reminderDateTime until 23:59
    // Use hashCode to generate a stable notification ID from habitId
    final int baseNotificationId = habitId.hashCode.abs() % 900000 + 100000;

    DateTime currentTime = reminderDateTime;
    // Calculate endOfDay using the same day as reminderDateTime (not today's date)
    final DateTime endOfDay = DateTime(
      reminderDateTime.year,
      reminderDateTime.month,
      reminderDateTime.day,
      23,
      59,
    );

    int hourCounter = 0;
    while (currentTime.isBefore(endOfDay)) {
      final int id = baseNotificationId + hourCounter;
      final String title = hourCounter == 0
          ? 'Time for your habit!'
          : 'Reminder: Complete your habit!';

      await _zonedScheduleNotification(
        id: id,
        title: title,
        body: habitName,
        scheduledTime: currentTime,
      );

      currentTime = currentTime.add(const Duration(hours: 1));
      hourCounter++;
    }
  }

  /// Schedule a completion notification (sent when task is done before deadline)
  Future<void> scheduleCompletionNotification({
    required String habitId,
    required String habitName,
  }) async {
    if (!_isInitialized) await initialize();

    final int baseId = habitId.hashCode.abs() % 900000 + 100000;

    await _zonedScheduleNotification(
      id: baseId,
      title: 'Great job!',
      body: 'You completed $habitName on time!',
      scheduledTime: DateTime.now().add(const Duration(seconds: 1)),
    );
  }

  /// Cancel all notifications for a specific habit
  Future<void> cancelReminders(String habitId) async {
    if (!_isInitialized) await initialize();

    final int baseId = habitId.hashCode.abs() % 900000 + 100000;

    // Cancel up to 24 hourly notifications
    for (int i = 0; i < 24; i++) {
      await _flutterLocalNotificationsPlugin.cancel(baseId + i);
    }
  }

  Future<void> _zonedScheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'habit_flow_reminders',
      'Habit Reminders',
      channelDescription: 'Notifications to remind you to complete your habits',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    final tz.TZDateTime tzScheduledTime = tz.TZDateTime.from(
      scheduledTime,
      tz.local,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzScheduledTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAndAllowWhileIdle,
        uiLocalNotificationDateInterpretationOptions:
            UILocalNotificationDateInterpretationOptions.absoluteTime,
      );
    } catch (e) {
      // Fallback if timezone-aware scheduling fails
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
      );
    }
  }
}
