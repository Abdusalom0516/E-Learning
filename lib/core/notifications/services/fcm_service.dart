import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

import '../models/push_notification_model.dart';
import 'local_notification_service.dart';

/// Service to handle Firebase Cloud Messaging (FCM) operations
class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final LocalNotificationService _localNotificationService;
  final List<Function(PushNotificationModel)> _onNotificationReceivedListeners =
      [];

  FCMService(this._localNotificationService);

  /// Initialize FCM service
  /// Initialize FCM service with improved error handling
  Future<void> initialize() async {
    await _requestPermissions();
    await _setupForegroundNotifications();
    await _setupBackgroundAndTerminatedNotifications();
    await _setupOnMessageOpenedApp();

    try {
      // Get FCM token with error handling
      String? token = await getToken();
      if (token != null) {
        debugPrint('FCM Token: $token');
      } else {
        debugPrint('Failed to get FCM token - notifications may be limited');
      }
    } catch (e) {
      debugPrint('Error during FCM initialization: $e');
      // Continue execution even if token retrieval fails
    }

    // Listen for token refreshes
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      // TODO: Send this token to your server
    });
  }

  /// Request notification permissions
  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('FCM permission status: ${settings.authorizationStatus}');
  }

  /// Setup handling of foreground notifications
  Future<void> _setupForegroundNotifications() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');

        final notification = PushNotificationModel(
          title: message.notification?.title ?? 'New Notification',
          body: message.notification?.body ?? '',
          payload: json.encode(message.data),
        );

        // Show local notification
        _localNotificationService.showNotification(notification);

        // Notify listeners
        _notifyListeners(notification);
      }
    });
  }

  /// Setup handling of background and terminated notifications
  Future<void> _setupBackgroundAndTerminatedNotifications() async {
    // Check if app was opened from a terminated state
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  }

  /// Setup handling of notifications when app is opened
  Future<void> _setupOnMessageOpenedApp() async {
    // Handle when the app is opened from a background state
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  /// Handle received message
  void _handleMessage(RemoteMessage message) {
    debugPrint('Handling FCM message: ${message.messageId}');

    if (message.notification != null) {
      final notification = PushNotificationModel(
        title: message.notification?.title ?? 'New Notification',
        body: message.notification?.body ?? '',
        payload: json.encode(message.data),
      );

      // Notify listeners
      _notifyListeners(notification);

      // TODO: Navigate to specific screen based on data if needed
      // Example:
      // if (message.data.containsKey('type')) {
      //   if (message.data['type'] == 'chat') {
      //     // Navigate to chat screen
      //   }
      // }
    }
  }

  /// Subscribe to a topic
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  /// Get the FCM token
  /// Get the FCM token with improved iOS support
  Future<String?> getToken() async {
    try {
      if (Platform.isIOS) {
        // For iOS, first check APNS token explicitly
        final apnsToken = await _firebaseMessaging.getAPNSToken();

        if (apnsToken == null) {
          debugPrint('APNS token is null, iOS push notifications may not work');

          // iOS simulator doesn't support push notifications
          if (Platform.isIOS && !await _isPhysicalDevice()) {
            debugPrint(
                'Running on iOS simulator - push notifications are not fully supported');
            return 'simulator-token-not-available';
          }

          // On physical devices, wait a bit and try again
          await Future.delayed(const Duration(seconds: 1));
          final retryApnsToken = await _firebaseMessaging.getAPNSToken();

          if (retryApnsToken == null) {
            debugPrint('APNS token still null after retry');
            return null;
          }
        }
      }

      // Now try to get FCM token
      return await _firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Check if the app is running on a physical device
  Future<bool> _isPhysicalDevice() async {
    try {
      // This is a simplified check - in production, use a package like 'device_info_plus'
      // to more accurately determine if the device is physical
      return !bool.fromEnvironment('dart.vm.product');
    } catch (e) {
      return false;
    }
  }

  /// Add a notification received listener
  void addOnNotificationReceivedListener(
      Function(PushNotificationModel) listener) {
    _onNotificationReceivedListeners.add(listener);
  }

  /// Remove a notification received listener
  void removeOnNotificationReceivedListener(
      Function(PushNotificationModel) listener) {
    _onNotificationReceivedListeners.remove(listener);
  }

  /// Notify listeners of a new notification
  void _notifyListeners(PushNotificationModel notification) {
    for (var listener in _onNotificationReceivedListeners) {
      listener(notification);
    }
  }
}

/// Firebase message handler for background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Need to initialize Firebase before using it
  await Firebase.initializeApp();

  debugPrint('Handling background message: ${message.messageId}');

  // Initialize FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Show notification if there is a notification payload
  if (message.notification != null) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: json.encode(message.data),
    );
  }
}
