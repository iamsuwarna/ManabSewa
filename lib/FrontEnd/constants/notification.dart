import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidInitializationSettings androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  void initialiseNotifications() async {
    // _configureLocalTimeZone();
    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
    List<PendingNotificationRequest> pendingNotifications =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print("Pending Notification ${pendingNotifications.length}");
  }

  // create the notification
  void showNotificationNow(int id) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'channelId',
      'channelName',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
      id,
      "Class Information",
      "Slide up to See class details",
      notificationDetails,
    );
  }

  void showNgoNotification(int id) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      '12',
      'kantipur',
      priority: Priority.high,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin.show(
      id,
      "Class Information",
      "Slide up to See class details",
      notificationDetails,
    );
  }

  // await flutterLocalNotificationsPlugin.show(
  //   0,
  //   'Donation Posted',
  //   '$donationType from $donorName to $ngo',
  //   platformChannelSpecifics,
  // );
}
