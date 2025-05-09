import 'package:flutter/material.dart';
import 'package:flutter_b11_api/models/task.dart';
import 'package:flutter_b11_api/provider/user_provider.dart';
import 'package:flutter_b11_api/services/task.dart';
import 'package:flutter_b11_api/views/create_task.dart';
import 'package:flutter_b11_api/views/filter_task.dart';
import 'package:flutter_b11_api/views/get_completed_task.dart';
import 'package:flutter_b11_api/views/get_in_completed_task.dart';
import 'package:flutter_b11_api/views/search_task.dart';
import 'package:flutter_b11_api/views/update_task.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../models/task_list.dart';

class GetAllTaskView extends StatefulWidget {
  const GetAllTaskView({super.key});

  @override
  State<GetAllTaskView> createState() => _GetAllTaskViewState();
}

class _GetAllTaskViewState extends State<GetAllTaskView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return LoadingOverlay(
      isLoading: isLoading,
      progressIndicator: CircularProgressIndicator(),
      color: Colors.transparent,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Get All Task"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GetInCompletedTaskView()));
                },
                icon: Icon(Icons.incomplete_circle)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GetCompletedTaskView()));
                },
                icon: Icon(Icons.circle)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SearchTaskView()));
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FilterTaskView()));
                },
                icon: Icon(Icons.filter)),
          ],
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
              .getAllTask(userProvider.getToken()!.token.toString()),
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
                        title: Text(
                            taskListModel.tasks![i].description.toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateTaskView(
                                              model: taskListModel.tasks![i])));
                                },
                                icon: Icon(Icons.edit)),
                            IconButton(
                                onPressed: () async {
                                  try {
                                    isLoading = true;
                                    setState(() {});
                                    await TaskServices()
                                        .deleteTask(
                                            token: userProvider
                                                .getToken()!
                                                .token
                                                .toString(),
                                            taskID: taskListModel.tasks![i].id
                                                .toString())
                                        .then((val) {
                                      isLoading = false;
                                      setState(() {});
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Task has been deleted successfully')));
                                      setState(() {});
                                    });
                                  } catch (e) {
                                    isLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(e.toString())));
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                          ],
                        ),
                      );
                    });
          },
        ),
      ),
    );
  }
}
