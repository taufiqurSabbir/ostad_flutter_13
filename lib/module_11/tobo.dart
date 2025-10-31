import 'package:flutter/material.dart';

class Todo extends StatefulWidget {
  const Todo({super.key});

  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  TextEditingController taskController = TextEditingController();
  List<String> tasks = [];

  addTask() {
    final task = taskController.text;
    if (task.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();
      });
    } else {}
  }

  updateTask(String value, int index) {
    if (value.isNotEmpty) {
      setState(() {
        tasks[index] = value;
      });
    } else {}
  }

  deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  editTask(int index) {
    final controller = TextEditingController(text: tasks[index]);

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Edit Task'),
              content: TextField(
                controller: controller,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('cancle')),
                ElevatedButton(
                    onPressed: () {
                      updateTask(controller.text, index);
                      Navigator.pop(context);
                    },
                    child: Text('update'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo app'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: taskController,
                  decoration: InputDecoration(labelText: 'Enter task'),
                )),
                ElevatedButton(
                    onPressed: addTask,
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(tasks[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                editTask(index);
                              },
                              icon: Icon(Icons.edit)),
                          IconButton(
                              onPressed: () {
                                deleteTask(index);
                              },
                              icon: Icon(Icons.delete)),
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
