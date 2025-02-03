import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> showPersistentSOSNotification() async {
  try {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'persistent_sos_channel', // ID
      'Persistent SOS Notifications', // Name
      channelDescription: 'Persistent notification for SOS feature',
      importance: Importance.max,
      priority: Priority.high,
      ongoing: true,
      visibility:
          NotificationVisibility.public, // Makes the notification persistent
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'sos_action', // Unique action ID
          'Send SOS', // Button text
        ),
      ],
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
/*
    await flutterLocalNotificationsPlugin.show(
      1, // Unique notification ID
      'Emergency SOS Active', // Title
      'Tap to send your location in case of danger', // Body
      platformChannelSpecifics,
    );
    */
  } on Exception catch (e) {
    // TODO
    print("Failed to display notification: $e");
  }
}
