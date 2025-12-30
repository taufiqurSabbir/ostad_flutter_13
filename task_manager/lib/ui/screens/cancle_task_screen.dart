import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/models/task_model.dart';
import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';
import '../../providers/task_provider.dart';
import '../widgets/snack_bae.dart';
import '../widgets/task_card.dart';

class CancleTaskScreen extends StatefulWidget {
  const CancleTaskScreen({super.key});

  @override
  State<CancleTaskScreen> createState() => _CancleTaskScreenState();
}

class _CancleTaskScreenState extends State<CancleTaskScreen> {



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  Future <void> loadData()async {
    final taskProvider = Provider.of<TaskProvider>(context,listen: false);
    Future.wait([
      taskProvider.fetchNewTaskByStatus('Cancelled'),
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
                itemCount: taskProvider.cancelledTasks.length,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: taskProvider.cancelledTasks[index],
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
