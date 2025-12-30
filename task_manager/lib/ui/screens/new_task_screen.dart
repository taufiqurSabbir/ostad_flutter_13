import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/providers/task_provider.dart';
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




  Future <void> loadData()async {
    final taskProvider = Provider.of<TaskProvider>(context,listen: false);
    Future.wait([
    taskProvider.fetchTaskStatusCount(),
    taskProvider.fetchNewTaskByStatus('New'),
    ]);

  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: TMAppBar(),
      body: Consumer<TaskProvider>(
        builder: (context,taskProvider,child) {
          return Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(3),
                child: SizedBox(
                  height: 90,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: taskProvider.taskStatusCount.length,
                    itemBuilder: (context, index) {
                      final counts = taskProvider.taskStatusCount;

                      return TaskCountByStatus(
                        title: counts[index].status,
                        count:  counts[index].count,
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
              Expanded(
                child: ListView.separated(
                  itemCount: taskProvider.newTasks.length,

                  itemBuilder: (context, index) {

                    return TaskCard(
                     taskModel: taskProvider.newTasks[index],
                      cardColor: Colors.blue,
                      refreshParent: () async {
                       await loadData();
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 4,
                    );
                  },
                ),
              )
            ],
          );
        }
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
