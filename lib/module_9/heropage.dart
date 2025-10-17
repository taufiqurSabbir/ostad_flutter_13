import 'package:flutter/material.dart';
class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Hero(
          tag: 'previousClass',
          child: Text('Previous class',
          style: TextStyle(
            fontSize: 40
          ),
          ),
        ),
      ),
    );

  }
}
