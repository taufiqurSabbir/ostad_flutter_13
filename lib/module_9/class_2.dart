import 'package:flutter/material.dart';
class FList extends StatelessWidget {
  const FList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List view'),
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context,index){
          return Card(
            child: ListTile(
              title: Text('Taufiq'),
              subtitle: Text('0179294554562'),
              leading: Icon(Icons.phone),
              trailing: Icon(Icons.delete,color: Colors.red,),
            ),
          );
        },
      ),
    );
  }
}
