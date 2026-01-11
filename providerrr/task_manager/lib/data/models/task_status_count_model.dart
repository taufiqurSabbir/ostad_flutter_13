import 'dart:convert';

class TaskStatusCountModel {
  final String status;
  final int count;

  TaskStatusCountModel({required this.status, required this.count});

  factory TaskStatusCountModel.formJson(Map<String,dynamic> jsonData){
    return TaskStatusCountModel(
    status: jsonData['_id'],
    count: jsonData['sum']);
  }

}