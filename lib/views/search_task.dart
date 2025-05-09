import 'package:flutter/material.dart';
import 'package:flutter_b11_api/models/task.dart';
import 'package:flutter_b11_api/provider/user_provider.dart';
import 'package:flutter_b11_api/services/task.dart';
import 'package:flutter_b11_api/views/create_task.dart';
import 'package:flutter_b11_api/views/get_completed_task.dart';
import 'package:flutter_b11_api/views/get_in_completed_task.dart';
import 'package:flutter_b11_api/views/update_task.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../models/task_list.dart';

class SearchTaskView extends StatefulWidget {
  const SearchTaskView({super.key});

  @override
  State<SearchTaskView> createState() => _SearchTaskViewState();
}

class _SearchTaskViewState extends State<SearchTaskView> {
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  TaskListModel? taskListModel;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Search Task"),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            onSubmitted: (val) async {
              try {
                isLoading = true;
                setState(() {});
                await TaskServices()
                    .searchTask(
                        token: userProvider.getToken()!.token.toString(),
                        searchKey: val)
                    .then((val) {
                  taskListModel = val;

                  isLoading = false;
                  setState(() {});
                });
              } catch (e) {
                isLoading = false;
                setState(() {});
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(e.toString())));
              }
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                prefixIcon: Icon(Icons.search)),
          ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          if (taskListModel != null)
            Expanded(
              child: ListView.builder(
                  itemCount: taskListModel!.tasks!.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Icon(Icons.task),
                      title:
                          Text(taskListModel!.tasks![i].description.toString()),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UpdateTaskView(
                                            model: taskListModel!.tasks![i])));
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
                                          taskID: taskListModel!.tasks![i].id
                                              .toString())
                                      .then((val) {
                                    isLoading = false;
                                    setState(() {});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
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
                  }),
            ),
        ],
      ),
    );
  }
}
