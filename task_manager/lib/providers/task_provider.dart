import 'package:flutter/cupertino.dart';
import 'package:task_manager/core/enums/api_state.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/models/task_status_count_model.dart';

import '../data/services/api_caller.dart';
import '../data/utils/urls.dart';

class TaskProvider extends ChangeNotifier{
  List<TaskModel> _newTasks = [];
  List<TaskModel> _progressTasks = [];
  List<TaskModel> _completedTasks = [];
  List<TaskModel> _cancelledTasks = [];

  List<TaskStatusCountModel> _taskStatusCount = [];

  ApiState _taskListState = ApiState.initial;
  ApiState _taskCountState = ApiState.initial;

  String ? _errorMessage;

  List<TaskModel> get newTasks => _newTasks;
  List<TaskModel> get progressTasks => _progressTasks;
  List<TaskModel> get completedTasks => _completedTasks;
  List<TaskModel> get cancelledTasks => _cancelledTasks;

  List<TaskStatusCountModel> get taskStatusCount => _taskStatusCount;


  Future<void> fetchTaskStatusCount()async {
    _taskCountState = ApiState.loading;
    notifyListeners();

    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.taskCountUrl);

    if(response.isSuccess){
      _taskStatusCount = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        _taskStatusCount.add(TaskStatusCountModel.formJson(jsonData));
      }
      _taskCountState = ApiState.success;
      _errorMessage = null;
    }else{

      _taskCountState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Failed to fetch task Count';

    }

    notifyListeners();

  }


  Future<void> fetchNewTaskByStatus(String status)async {
    _taskListState = ApiState.loading;
    notifyListeners();

    String url;

    switch(status){
      case ('New'):
        url = Urls.newTaskUrl;
        break;
      case 'Progress' :
        url = Urls.progressTaskUrl;
        break;
      case 'Completed'  :
        url = Urls.completedTaskUrl;
        break;
      case 'Cancelled'  :
        url = Urls.CancelledTaskUrl;
        break;
      default:
        url = Urls.newTaskUrl;
    }

    final ApiResponse response =
    await ApiCaller.getRequest(url: url);

    if(response.isSuccess){
   List<TaskModel> tasks = [];
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        tasks.add(TaskModel.fromJson(jsonData));
      }
   switch(status){
     case ('New'):
       _newTasks = tasks;
       break;
     case 'Progress' :
       _progressTasks = tasks;
       break;
     case 'Completed'  :
       _completedTasks = tasks;
       break;
     case 'Cancelled'  :
       _cancelledTasks = tasks;
       break;
     default:
       _newTasks = tasks;
   }


      _taskListState = ApiState.success;
      _errorMessage = null;
    }else{

      _taskCountState = ApiState.error;
      _errorMessage = response.errorMessage ?? 'Failed to fetch task';

    }

    notifyListeners();

  }

}