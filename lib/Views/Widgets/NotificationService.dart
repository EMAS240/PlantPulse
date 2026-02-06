import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart'; // ضروري لاستخدام الترجمة

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize Notifications
  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
  }

  // Show Welcome Notification (with translation support)
  Future<void> showWelcomeNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      final AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'welcome_channel', // Channel ID
        'welcome'.tr, // Channel name (translated)
        channelDescription: 'welcome_notification_description'.tr,
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: BigPictureStyleInformation(
          DrawableResourceAndroidBitmap("@mipmap/icon"), // اسم صورة الأيقونة
          contentTitle: 'welcome'.tr,
          summaryText: 'welcome_notification_body'.tr,
        ),
      );

      final NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await flutterLocalNotificationsPlugin.show(
        id: 0,
        title: 'welcome'.tr,
        body: 'welcome_notification_body'.tr,
        notificationDetails: platformChannelSpecifics,
      );

      await prefs.setBool('isFirstLaunch', false);
    }
  }
}
