import 'package:flutter/material.dart';

import '../widgets/task_card.dart';
import '../widgets/tm_app_bar.dart';

class CancleTaskScreen extends StatefulWidget {
  const CancleTaskScreen({super.key});

  @override
  State<CancleTaskScreen> createState() => _CancleTaskScreenState();
}

class _CancleTaskScreenState extends State<CancleTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.separated(

            itemBuilder: (context,index){
              return TaskCard(status: 'Canceled', cardColor: Colors.red,);
            },
            separatorBuilder: (context,index){
              return SizedBox(height: 2,);
            },
            itemCount: 10),
      ),
    );
  }
}
