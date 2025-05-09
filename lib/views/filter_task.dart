import 'package:flutter/material.dart';
import 'package:flutter_b11_api/models/task.dart';
import 'package:flutter_b11_api/provider/user_provider.dart';
import 'package:flutter_b11_api/services/task.dart';
import 'package:flutter_b11_api/views/create_task.dart';
import 'package:flutter_b11_api/views/get_completed_task.dart';
import 'package:flutter_b11_api/views/get_in_completed_task.dart';
import 'package:flutter_b11_api/views/update_task.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';

import '../models/task_list.dart';

class FilterTaskView extends StatefulWidget {
  const FilterTaskView({super.key});

  @override
  State<FilterTaskView> createState() => _FilterTaskViewState();
}

class _FilterTaskViewState extends State<FilterTaskView> {
  bool isLoading = false;

  TextEditingController searchController = TextEditingController();

  TaskListModel? taskListModel;

  DateTime? firstDate;
  DateTime? secondDate;

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Filter Task"),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now())
                            .then((val) {
                          firstDate = val;
                          setState(() {});
                        });
                      },
                      child: Text("Pick First Date")),
                  if (firstDate != null)
                    Text(DateFormat.yMMMMd().format(firstDate!))
                ],
              ),
              Column(
                children: [
                  TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                firstDate: DateTime(1990),
                                lastDate: DateTime.now())
                            .then((val) {
                          secondDate = val;
                          setState(() {});
                        });
                      },
                      child: Text("Pick Second Date")),
                  if (secondDate != null)
                    Text(DateFormat.yMMMMd().format(secondDate!))
                ],
              ),
            ],
          ),
          ElevatedButton(
              onPressed: () async {
                try {
                  isLoading = true;
                  setState(() {});
                  await TaskServices()
                      .getFilterTask(
                          token: userProvider.getToken()!.token.toString(),
                          firstDate: firstDate.toString(),
                          lastDate: secondDate.toString())
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
              child: Text("Filter Task")),
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
