import 'package:flutter/material.dart';
import 'package:flutter_13/theme/app_theme.dart';

import 'home.dart';
import 'module_11/res.dart';
import 'module_7/class_2_button.dart';
import 'module_8/class_1_input.dart';
import 'module_8/class_2.dart';
import 'module_8/class_3.dart';
import 'module_8/dashboard.dart';
import 'module_8/grid_v.dart';
import 'module_9/class_2.dart';
import 'module_9/class_2_stack.dart';
import 'module_9/class_3.dart';
import 'module_9/theme_test.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // theme: ThemeData(
      //
      //   primaryColor: Colors.deepPurple,
      //   primarySwatch: Colors.deepPurple,
      //
      //   // scaffoldBackgroundColor: Colors.grey.shade400,
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.orange,
      //       foregroundColor: Colors.blue,
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(10)
      //       )
      //     )
      //   ),
      //   inputDecorationTheme: InputDecorationTheme(
      //     border: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(5),
      //     ),
      //     enabledBorder: OutlineInputBorder(
      //       borderRadius: BorderRadius.circular(5),
      //       borderSide: BorderSide(color: Colors.grey,width: 2),
      //     ),
      //
      //       focusedBorder: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(5),
      //         borderSide: BorderSide(color: Colors.orange,width: 2),
      //       ),
      //       hintStyle: TextStyle(
      //       color: Colors.grey
      //   )
      //   ),
      //
      //   textTheme: TextTheme(
      //     headlineLarge: TextStyle(
      //       fontSize: 18,
      //       fontWeight: FontWeight.bold
      //     )
      //   ),
      //
      // ),
      // darkTheme: ThemeData.dark().copyWith(
      //   primaryColor: Colors.purple,
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //       style: ElevatedButton.styleFrom(
      //           backgroundColor: Colors.purple,
      //           foregroundColor: Colors.white,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(10)
      //           )
      //       )
      //   ),
      // ),
      themeMode: ThemeMode.light,
      title: 'Batch-13',
      home: ThemeTest(),
      initialRoute: 'res',
      routes: {
        'home' : (context)=>Home(),
        'btns': (context)=>Buttongrp(),
        'login': (context)=>LoginPage(),
        'Dashboard': (context)=>Dashboard(),
        'list': (context)=>FList(),
        'Stack': (context)=>Class2Stack(),
        'widget': (context)=>OwnWidget(),
        'res': (context)=>Res(),
      },
    );
  }
}
