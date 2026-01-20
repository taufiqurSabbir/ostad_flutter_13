
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class NotificationService{
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
   await Firebase.initializeApp();

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('permi ${settings.authorizationStatus}');

    String ? token = await _messaging.getToken();

    print('Device token: ${token}');


    FirebaseMessaging.onMessage.listen((RemoteMessage message){
      final context  = navigatorKey.currentContext!;
     showDialog(context: context, builder: (_)=>AlertDialog(
       title: Text(message.notification!.title ?? ''),
       content: Text(message.notification!.body ?? ''),
     ));
   });
  }


  Future<void>firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();

  }








}