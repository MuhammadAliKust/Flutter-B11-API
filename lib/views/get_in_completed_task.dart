import 'package:flutter/material.dart';
import 'package:flutter_b11_api/models/task.dart';
import 'package:flutter_b11_api/provider/user_provider.dart';
import 'package:flutter_b11_api/services/task.dart';
import 'package:flutter_b11_api/views/create_task.dart';
import 'package:provider/provider.dart';

import '../models/task_list.dart';

class GetInCompletedTaskView extends StatelessWidget {
  const GetInCompletedTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get In Completed Task"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTaskView()));
        },
        child: Icon(Icons.add),
      ),
      body: FutureProvider.value(
        value: TaskServices()
            .getInCompletedTask(userProvider.getToken()!.token.toString()),
        initialData: TaskListModel(),
        builder: (context, child) {
          TaskListModel taskListModel = context.watch<TaskListModel>();
          return taskListModel.tasks == null
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: taskListModel.tasks!.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.task),
                      title:
                          Text(taskListModel.tasks![i].description.toString()),
                    );
                  });
        },
      ),
    );
  }
}
