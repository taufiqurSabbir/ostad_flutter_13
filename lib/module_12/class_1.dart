import 'package:flutter/material.dart';
class StateClass extends StatefulWidget {
   StateClass({super.key});

  @override
  State<StateClass> createState() => _StateClassState();
}

class _StateClassState extends State<StateClass> {
  int num = 0;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(num.toString(),style: TextStyle(fontSize: 80,color: Colors.orange),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  IconButton(onPressed: (){
                    setState(() {
                      num++;
                      print(num);
                    });

                  }, icon: Icon(Icons.add)),

                  IconButton(onPressed: (){
                    num--;
                    print(num);
                    setState(() {

                    });
                  }, icon: Icon(Icons.minimize_sharp)),

                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
