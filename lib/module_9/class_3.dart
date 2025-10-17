import 'package:flutter/material.dart';
import 'package:flutter_13/module_9/widget/city_card.dart';

import 'class_2_stack.dart';
import 'heropage.dart';

class OwnWidget extends StatelessWidget {
  const OwnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CityCard(
                    img:
                        'https://media.istockphoto.com/id/1347665170/photo/london-at-sunset.jpg?s=612x612&w=0&k=20&c=MdiIzSNKvP8Ct6fdgdV3J4FVcfsfzQjMb6swe2ybY6I=',
                    title: 'London',
                    rating: '4.8',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CityCard(
                    img:
                        'https://res.cloudinary.com/jerrick/image/upload/v1687258926/6491872d1f962c001de086fa.jpg',
                    title: 'Dhaka',
                    rating: '4.5',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CityCard(
                    img:
                        'https://static.toiimg.com/thumb/msid-52040615,width-748,height-499,resizemode=4,imgsize-167596/Burj-al-arab.jpg',
                    title: 'Dubai',
                    rating: '4.9',
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CityCard(
                    img:
                        'https://media.istockphoto.com/id/1347665170/photo/london-at-sunset.jpg?s=612x612&w=0&k=20&c=MdiIzSNKvP8Ct6fdgdV3J4FVcfsfzQjMb6swe2ybY6I=',
                    title: 'London',
                    rating: '4.8',
                  ),
                ],
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  Class2Stack(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1, 0);
                            const end = Offset.zero;
                            const curve = Curves.easeOut;
                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          }));
                },
                child: Text('Previous class')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HeroPage()));
                },
                child: Hero(
                  tag: 'previousClass',
                  child: Text('Previous class',
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
