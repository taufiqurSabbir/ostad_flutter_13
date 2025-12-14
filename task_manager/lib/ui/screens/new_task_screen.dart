import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/ui/widgets/snack_bae.dart';

import '../../data/models/task_status_count_model.dart';
import '../../data/utils/urls.dart';
import '../widgets/task_card.dart';
import '../widgets/task_count_by_status.dart';
import '../widgets/tm_app_bar.dart';
import 'add_new_task_screen.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getTaskStatusCountProgress = false;
  bool _getNewTaskProgress = false;

  List<TaskStatusCountModel> _taskStatusCountList = [];
  List<TaskModel> _newTaskList = [];

  Future<void> _getAllTaskCount() async {
    _getTaskStatusCountProgress = true;
    setState(() {});

    final ApiResponse response =
        await ApiCaller.getRequest(url: Urls.taskCountUrl);

    _getTaskStatusCountProgress = false;
    setState(() {});
    List<TaskStatusCountModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskStatusCountModel.formJson(jsonData));
      }
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
    _taskStatusCountList = list;
  }

  Future<void> _getAllNewTasks() async {
    _getNewTaskProgress = true;
    setState(() {});

    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.newTaskUrl);

    _getNewTaskProgress = false;
    setState(() {});
    List<TaskModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
    _newTaskList = list;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTaskCount();
    _getAllNewTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TMAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: SizedBox(
              height: 90,
              child: Visibility(
                visible: _getTaskStatusCountProgress == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _taskStatusCountList.length,
                  itemBuilder: (context, index) {
                    return TaskCountByStatus(
                      title: _taskStatusCountList[index].status,
                      count:  _taskStatusCountList[index].count,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      width: 4,
                    );
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: Visibility(
              visible: _getNewTaskProgress == false,
              replacement: Center(child: CircularProgressIndicator()),
              child: ListView.separated(
                itemCount: _newTaskList.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                   taskModel: _newTaskList[index],
                    cardColor: Colors.blue,
                    refreshParent: (){
                      _getAllNewTasks();
                      _getAllTaskCount();
                    },
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 4,
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewTaskScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
