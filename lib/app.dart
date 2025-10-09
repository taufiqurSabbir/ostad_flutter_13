import 'package:flutter/material.dart';

import 'home.dart';
import 'module_7/class_2_button.dart';
import 'module_8/class_1_input.dart';
import 'module_8/class_2.dart';
import 'module_8/class_3.dart';
import 'module_8/grid_v.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Batch-13',
      home: GridV(),
    );
  }
}
