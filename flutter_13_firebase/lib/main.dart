import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_13_firebase/firebase_options.dart';
import 'package:flutter_13_firebase/notification_service.dart';

import 'flutter_local_notification.dart';
import 'login_page.dart';
import 'notification_demo.dart';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  await iniNotification();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'BD Vooting',
      home: LoginPage(),
    );
  }
}