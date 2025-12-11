import 'package:flutter/material.dart';
import 'package:task_manager/data/services/api_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../widgets/snack_bae.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TMAppBar(),
      body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                const SizedBox(height: 80,),
                Text('Add new Task',
                style: Theme.of(context).textTheme.titleLarge
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: titleController,
                  decoration: InputDecoration(
                    hintText: 'Title'
                  ),
                  validator: (String ? value){
                    if(value == null || value.isEmpty){
                      return 'please enter title';
                    }
                
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: descriptionController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Description'
                  ),
                
                  validator: (String ? value){
                    if(value == null || value.isEmpty){
                      return 'please enter description';
                    }
                
                    return null;
                  },
                ),
                const SizedBox(height: 20,),
                FilledButton(onPressed: (){
                  if(_formKey.currentState!.validate()){
                    addNewTask();
                  }
                }, child: Icon(Icons.arrow_circle_right_outlined))
                        ],
                      ),
              ),
            ),
          )),



    );

  }

  bool _addTaskProgress = false;

  Future<void>addNewTask()async {
    _addTaskProgress = true;
    setState(() {

    });

    Map<String,dynamic>requestBody = {

      "title": titleController.text,
      "description":descriptionController.text,
      "status":"New"

    };

    final ApiResponse response =await ApiCaller.postRequest(
        url: Urls.createTaskUrl,
    body: requestBody,
    );

    _addTaskProgress = false;

    setState(() {

    });


    if(response.isSuccess){
      _clearField();
      showSnackBarMessage(context,'New task added');


    }else{
      showSnackBarMessage(context,response.errorMessage!);
    }

  }



  _clearField(){
    titleController.clear();
    descriptionController.clear();
  }

}
