import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();



Future<void>iniNotification() async {
  tz.initializeTimeZones();

  AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  DarwinInitializationSettings iosSetting = DarwinInitializationSettings();

  InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: iosSetting
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveBackgroundNotificationResponse:notificationTapBckground
  );
}


@pragma('vm:entry-point')
void notificationTapBckground(NotificationResponse response){
  print('Notification clicked');
}