import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'models/push_notification_model.dart';
import 'services/fcm_service.dart';
import 'services/local_notification_service.dart';

/// Main class to handle all notification operations
class NotificationHandler {
  late final FCMService _fcmService;
  late final LocalNotificationService _localNotificationService;

  /// Initialize notification services
  Future<bool> initialize() async {
    try {
      // Setup local notifications first
      _localNotificationService = LocalNotificationService();
      await _localNotificationService.initialize();

      // Setup FCM service
      _fcmService = FCMService(_localNotificationService);
      await _fcmService.initialize();

      // Register background message handler
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      return true;
    } catch (e) {
      debugPrint('Error initializing notification services: $e');
      // Continue with app initialization even if notifications fail
      return false;
    }
  }

  /// Get FCM token with error handling
  Future<String?> getFCMToken() async {
    try {
      return await _fcmService.getToken();
    } catch (e) {
      debugPrint('Error in getFCMToken: $e');
      return 'Error: $e';
    }
  }

  /// Show a local notification
  Future<void> showLocalNotification(PushNotificationModel notification) async {
    await _localNotificationService.showNotification(notification);
  }

  /// Subscribe to a FCM topic
  Future<void> subscribeToTopic(String topic) async {
    await _fcmService.subscribeToTopic(topic);
  }

  /// Unsubscribe from a FCM topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _fcmService.unsubscribeFromTopic(topic);
  }

  /// Add listener for notification received
  void addOnNotificationReceivedListener(
      Function(PushNotificationModel) listener) {
    _fcmService.addOnNotificationReceivedListener(listener);
  }

  /// Remove listener for notification received
  void removeOnNotificationReceivedListener(
      Function(PushNotificationModel) listener) {
    _fcmService.removeOnNotificationReceivedListener(listener);
  }

  /// Add listener for notification tap
  void addOnNotificationTapListener(Function(String?) listener) {
    _localNotificationService.addOnNotificationTapListener(listener);
  }

  /// Remove listener for notification tap
  void removeOnNotificationTapListener(Function(String?) listener) {
    _localNotificationService.removeOnNotificationTapListener(listener);
  }
}

/// Global notification handler instance
final notificationHandler = NotificationHandler();
