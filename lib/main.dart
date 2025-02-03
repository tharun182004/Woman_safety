import 'package:flutter/material.dart';

import 'token_check.dart';

void main() async {
  /*
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  // Initialize notification service
  await NotificationService.initializeNotification();

  await NotificationService.createSOSNotification();

  // Initialize background service
  //await initializeService();
  */

  runApp(MyApp());
  //FlutterBackgroundService().invoke('setasforeground');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //showPersistentSOSNotification();
    return MaterialApp(
      home: CheckToken(),
    );
  }
}
