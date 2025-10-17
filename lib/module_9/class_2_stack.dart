import 'package:flutter/material.dart';
import 'package:flutter_13/module_9/widget/city_card.dart';

class Class2Stack extends StatelessWidget {
  const Class2Stack({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stack'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CityCard(img: 'https://media.istockphoto.com/id/1347665170/photo/london-at-sunset.jpg?s=612x612&w=0&k=20&c=MdiIzSNKvP8Ct6fdgdV3J4FVcfsfzQjMb6swe2ybY6I=', title: 'London', rating: '4.8',),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Container(
                  color: Colors.red,
                  height: 200,
                  width: 200,
                ),
                Positioned(
                  bottom: 50,
                  left: 10,
                  right: 10,
                  top: 10,
                  child: Container(
                    color: Colors.green,
                    height: 150,
                    width: 180,
                  ),
                ),
                Positioned(
                  top: 20,
                  right: 20,
                  bottom: 20,
                  child: Container(
                    color: Colors.purple,
                    height: 100,
                    width: 150,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(
                      "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D"),
                ),
                Positioned(
                  bottom: 15,
                  right: 5,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

