import 'package:flutter/material.dart';

class Class3 extends StatelessWidget {
  const Class3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Grid view'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                      // color: Colors.teal,
                      gradient: LinearGradient(
                          colors: [Colors.red, Colors.red],
                          begin: Alignment.topRight,
                          end: Alignment.bottomRight),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black,
                            blurRadius: 10,
                            offset: Offset(0, 10)),
                        // BoxShadow(
                        //     color: Colors.red,
                        //     blurRadius: 10,
                        //     offset: Offset(10,0)
                        // )
                      ]),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.phone,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        'Phone',
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      )
                    ],
                  )),
            ],
          ),
        ));
  }
}
