import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

import 'flutter_local_notification.dart';

class NotificationDemo extends StatelessWidget {
  const NotificationDemo({super.key});

  Future instantNotification() async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails('instant_channel', 'instant',
          importance: Importance.max, priority: Priority.high),
    );

    await flutterLocalNotificationsPlugin.show(
        0, 'Order Confirmed ', 'Your order is Confirmed', details);
  }

  Future scheduleNotification() async {
    flutterLocalNotificationsPlugin.zonedSchedule(
      1,
      'Meeting Reminder',
      'Meeting in 10 min',
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 10)),
      NotificationDetails(
          android: AndroidNotificationDetails(
              'meeting_channel',
              'meeting',
              priority: Priority.high,
            importance: Importance.max
          )),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: null,
    );
  }

  Future dailyNotification() async {
    final now = DateTime.now();
    final scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
        (now.minute+1) % 60,
    );

   await flutterLocalNotificationsPlugin.zonedSchedule(3, 'Daily scheduled', 'scheduled', scheduledTime, NotificationDetails(
      android: AndroidNotificationDetails('scheduled_chl', 'scheduled')
    ), androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: instantNotification, child: Text('Instant')),
            ElevatedButton(
                onPressed: scheduleNotification, child: Text('10 sec')),
            ElevatedButton(
                onPressed: dailyNotification, child: Text('she sec'))
          ],
        ),
      ),
    );
  }
}
