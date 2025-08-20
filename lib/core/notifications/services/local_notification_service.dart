import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/push_notification_model.dart';

/// Service to handle local notifications using flutter_local_notifications plugin
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final List<Function(String?)> _onNotificationTapListeners = [];

  /// Initialize local notification service
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onDidReceiveNotificationResponse,
    );
  }

  /// Show a notification
  Future<void> showNotification(PushNotificationModel notification) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: notification.payload,
    );
  }

  /// Handle notification response when tapped
  void _onDidReceiveNotificationResponse(NotificationResponse response) {
    final String? payload = response.payload;

    // Notify listeners
    for (var listener in _onNotificationTapListeners) {
      listener(payload);
    }
  }

  /// Add notification tap listener
  void addOnNotificationTapListener(Function(String?) listener) {
    _onNotificationTapListeners.add(listener);
  }

  /// Remove notification tap listener
  void removeOnNotificationTapListener(Function(String?) listener) {
    _onNotificationTapListeners.remove(listener);
  }

  /// Get pending notification requests
  Future<List<PendingNotificationRequest>>
      getPendingNotificationRequests() async {
    return await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
  }

  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
