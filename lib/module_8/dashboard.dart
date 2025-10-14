import 'package:flutter/material.dart';

class Dashboard extends StatelessWidget {
   Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(args['phone'].toString(),style: TextStyle(
          fontSize: 50,
          color: Colors.blue
        ),),

      ),
    );
  }
}
