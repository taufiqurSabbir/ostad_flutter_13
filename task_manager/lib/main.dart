import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/auth_provider.dart';
import 'package:task_manager/providers/network_provider.dart';

import 'app.dart';

void main(){
runApp(
       MultiProvider(providers: [
              ChangeNotifierProvider(create: (_)=> AuthProvider()),
              ChangeNotifierProvider(create: (_)=> NetworkProvider())
       ],
       child: TaskManagerApp(),
       ),
);
}