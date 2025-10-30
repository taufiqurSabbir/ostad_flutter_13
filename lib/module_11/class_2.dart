import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResPKG extends StatelessWidget {
  const ResPKG({super.key});

  @override
  Widget build(BuildContext context) {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: orientation == Orientation.landscape ? Axis.horizontal : Axis.vertical,
          child: orientation == Orientation.landscape ?
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

                //width 200.r == min(200.w,200.h)

                width: 200.r,
                height: 100.r,
                color: Colors.blue,

              ),
              Row(
                children: [
                  Container(
                    width: 0.3.sw,
                    height: 200.h,
                    color: Colors.teal,
                    child: Text('My actual width ${0.5.sw}'
                        'My actual height: ${200.h}'
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 250,
                      maxWidth: 200,
                    ).hw,
                    color: Colors.orange,
                    child: Text('hello'),
                  ),
                ],
              ),

              Container(
                height: 150.h,
                width: 150.w,
                color: Colors.green,
              ),
              SizedBox(height: 20,),
              Container(
                height: 200,
                width: 200,
                color: Colors.red,
              ),
              Text('Hello Test',
                style: TextStyle(
                    fontSize: 25
                ),
              ),
              Text('Hello Test res',
                style: TextStyle(
                    fontSize: 25.sp
                ),
              )
            ],
          )  :
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(

                //width 200.r == min(200.w,200.h)

                width: 200.r,
                height: 100.r,
                color: Colors.blue,
                
              ),
              Row(
                children: [
                  Container(
                    width: 0.3.sw,
                    height: 200.h,
                    color: Colors.teal,
                    child: Text('My actual width ${0.5.sw}'
                    'My actual height: ${200.h}'
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 250,
                      maxWidth: 200,
                    ).hw,
                    color: Colors.orange,
                    child: Text('hello'),
                  ),
                ],
              ),

              Container(
                height: 150.h,
                width: 150.w,
                color: Colors.green,
              ),
              SizedBox(height: 20,),
              Container(
                height: 200,
                width: 200,
                color: Colors.red,
              ),
              Text('Hello Test',
              style: TextStyle(
                fontSize: 25
              ),
              ),
              Text('Hello Test res',
                style: TextStyle(
                    fontSize: 25.sp
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
