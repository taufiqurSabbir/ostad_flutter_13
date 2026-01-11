import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/widgets/snack_bae.dart';

import '../../data/services/api_caller.dart';
import '../../data/utils/urls.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({
    super.key, required this.taskModel, required this.cardColor, required this.refreshParent,
  });

  final TaskModel taskModel;
  final Color cardColor;
  final VoidCallback refreshParent;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _changeStatusInProgress = false;
  bool _deleteLoading = false;

  Future<void> _changeStatus(String status) async {
    _changeStatusInProgress = true;
    setState(() {});

    final ApiResponse response =
    await ApiCaller.getRequest(url: Urls.changeStatus(widget.taskModel.id, status));

    _changeStatusInProgress = false;
    setState(() {});

    if (response.isSuccess) {
     widget.refreshParent();
     Navigator.pop(context);
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }

  Future<void> deleteTask() async {
    _deleteLoading = true;
    setState(() {

    });
    final ApiResponse response =await ApiCaller.getRequest(url: Urls.deleteTaskUrl(widget.taskModel.id));
    _deleteLoading = false;
    setState(() {

    });
    if(response.isSuccess){
      widget.refreshParent();
      showSnackBarMessage(context, 'Task Deleted');
    }else{
      showSnackBarMessage(context, response.errorMessage.toString());
    }
  }


  @override
  Widget build(BuildContext context) {


    void _showChangeStatusDialog(){
      showDialog(context: context, builder: (contex){
        return AlertDialog(
          title: Text('Change Status'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                onTap: (){
                  _changeStatus('New');
                },
                title: Text('New'),
                trailing: widget.taskModel.status == 'New'   ? Icon(Icons.done) : null,
              ),

              ListTile(
                onTap: (){
                  _changeStatus('Progress');
                },
                title: Text('Progress'),
                trailing: widget.taskModel.status == 'Progress'   ? Icon(Icons.done) : null,
              ),

              ListTile(
                onTap: (){
                  _changeStatus('Cancelled');
                },
                title: Text('Cancelled'),
                trailing: widget.taskModel.status == 'Cancelled'   ? Icon(Icons.done) : null,
              ),

              ListTile(
                onTap: (){
                  _changeStatus('Completed');
                },
                title: Text('Completed'),
                trailing: widget.taskModel.status == 'Completed'   ? Icon(Icons.done) : null,
              )
            ],
          ),
        );
      });
    }





    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        color: Colors.white,
        child: ListTile(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(widget.taskModel.title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontSize: 18
          ),
          ),
          subtitle: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.taskModel.description),
              Text('Date: ${widget.taskModel.createdDate}'),
              Row(
                children: [
                  Chip(
                    label: Text(widget.taskModel.status),
                    backgroundColor: widget.cardColor,
                    labelStyle: TextStyle(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                  ),
                  Spacer(),
                  IconButton(
                      onPressed: () {
                        _showChangeStatusDialog();

                      },
                      icon: Icon(
                        Icons.edit_note_rounded,
                        color: Colors.green,
                      )),
                  IconButton(
                      onPressed: () {
                        deleteTask();
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
