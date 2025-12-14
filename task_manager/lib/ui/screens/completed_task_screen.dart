import 'package:flutter/material.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../widgets/snack_bae.dart';
import '../widgets/task_card.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {

  List<TaskModel> _completedTaskList = [];
  bool _isloading = false;


  Future<void> _getAllTasks() async {
    _isloading = true;
    setState(() {});

    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.completedTaskUrl);

    _isloading = false;
    setState(() {});
    List<TaskModel> list = [];
    if (response.isSuccess) {
      for (Map<String, dynamic> jsonData in response.responseData['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
    _completedTaskList = list;
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAllTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Visibility(
          visible: _isloading == false,
            replacement: Center(child: CircularProgressIndicator()),
          child: ListView.separated(
            itemCount: _completedTaskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                taskModel: _completedTaskList[index],
                cardColor: Colors.blue,
                refreshParent: (){
                  _getAllTasks();
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
      ),
    );
  }
}
