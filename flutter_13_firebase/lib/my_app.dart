import 'package:flutter/material.dart';
import 'package:flutter_13_firebase/votting_page.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BD Vooting',
      home: VottingPage(),
    );
  }
}
