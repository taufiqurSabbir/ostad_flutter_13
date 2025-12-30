import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../../providers/task_provider.dart';
import '../widgets/snack_bae.dart';
import '../widgets/task_card.dart';
import '../widgets/tm_app_bar.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }
  Future <void> loadData()async {
    final taskProvider = Provider.of<TaskProvider>(context,listen: false);
    Future.wait([
      taskProvider.fetchNewTaskByStatus('Progress'),
    ]);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: Consumer<TaskProvider>(
          builder: (context,taskProvider,child){
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView.separated(
              itemCount: taskProvider.progressTasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  taskModel: taskProvider.progressTasks[index],
                  cardColor: Colors.blue,
                  refreshParent: (){
                  loadData();
                  },
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 4,
                );
              },
            ),
          );
        }
      ),
    );
  }
}
