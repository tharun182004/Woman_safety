import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:the_app/User_app/Main Page Items/location/location_functionality.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
        null,
        [
          NotificationChannel(
            channelKey: "SOS_notification",
            channelName: "SOS_notification",
            channelDescription: "Hello world",
            importance: NotificationImportance.Max,
            channelShowBadge: true,
            onlyAlertOnce: false,
            playSound: true,
            defaultPrivacy: NotificationPrivacy.Public,
          )
        ],
        channelGroups: [
          NotificationChannelGroup(
              channelGroupKey: "High_important_channel",
              channelGroupName: "Group 1")
        ],
        debug: true);

    await AwesomeNotifications().isNotificationAllowed().then((isAlowed) async {
      if (!isAlowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    await AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint("tapped on the action button");
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      Position? position = await getCurrentLocation();
      if (position != null) {
        debugPrint(
            "Fetched Location: Latitude: ${position.latitude}, Longitude: ${position.longitude}");
        // Further action with the location (e.g., send to server, show on UI)
      } else {
        debugPrint("Failed to fetch location.");
      }
    }
  }

  static Future<void> createSOSNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 1,
        channelKey: 'SOS_notification',
        title: 'SOS Alert',
        body: 'Tap the button to send the location',
        payload: {"navigate": "true"},
        displayOnBackground: true,
        displayOnForeground: true,
        locked: true,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'action_1',
          label: 'Take Action',
          autoDismissible: false,
          enabled: true,
        ),
      ],
    );
  }
}
