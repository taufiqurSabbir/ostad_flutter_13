import 'package:flutter/material.dart';

class GridV extends StatelessWidget {
  const GridV({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Grid view'),
      ),
      body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 25,
            mainAxisSpacing: 25
          ),
          itemCount: 20,
          itemBuilder: (context,index){
           return  Padding(
             padding: const EdgeInsets.all(8.0),
             child: Container(
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
           );
          }
      )


      // GridView.count(
      //     crossAxisCount: 3,
      //     padding: EdgeInsets.all(10),
      //     crossAxisSpacing: 10,
      //     mainAxisSpacing: 10,
      //     children: List.generate(
      //       10,
      //       (index) => Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Container(
      //             width: 150,
      //             height: 150,
      //             decoration: BoxDecoration(
      //                 // color: Colors.teal,
      //                 gradient: LinearGradient(
      //                     colors: [Colors.red, Colors.red],
      //                     begin: Alignment.topRight,
      //                     end: Alignment.bottomRight),
      //                 borderRadius: BorderRadius.circular(10),
      //                 boxShadow: [
      //                   BoxShadow(
      //                       color: Colors.black,
      //                       blurRadius: 10,
      //                       offset: Offset(0, 10)),
      //                   // BoxShadow(
      //                   //     color: Colors.red,
      //                   //     blurRadius: 10,
      //                   //     offset: Offset(10,0)
      //                   // )
      //                 ]),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Icon(
      //                   Icons.phone,
      //                   size: 50,
      //                   color: Colors.white,
      //                 ),
      //                 Text(
      //                   'Phone',
      //                   style: TextStyle(fontSize: 25, color: Colors.white),
      //                 )
      //               ],
      //             )),
      //       ),
      //     )),
    );
  }
}
