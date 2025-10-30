import 'package:flutter/material.dart';
import 'package:flutter_13/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'home.dart';
import 'module_11/class_2.dart';
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
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            title: 'Batch-13',
            home: ThemeTest(),
            initialRoute: 'res_pakg',
            routes: {
              'home': (context) => Home(),
              'btns': (context) => Buttongrp(),
              'login': (context) => LoginPage(),
              'Dashboard': (context) => Dashboard(),
              'list': (context) => FList(),
              'Stack': (context) => Class2Stack(),
              'widget': (context) => OwnWidget(),
              'res': (context) => Res(),
              'res_pakg': (context) => ResPKG(),
            },
          );
        });
  }
}
