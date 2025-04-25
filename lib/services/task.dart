import 'dart:convert';
import 'dart:developer';

import 'package:flutter_b11_api/models/task.dart';
import 'package:flutter_b11_api/models/task_list.dart';
import 'package:http/http.dart' as http;

class TaskServices {
  String baseUrl = "https://todo-nu-plum-19.vercel.app/";

  ///Create Task
  Future<TaskModel> createTask(
      {required String token, required String description}) async {
    try {
      http.Response response = await http.post(Uri.parse('${baseUrl}todos/add'),
          headers: {'Content-Type': 'application/json', 'Authorization': token},
          body: jsonEncode({"description": description}));

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Get All Tasks
  Future<TaskListModel> getAllTask(String token) async {
    try {
      http.Response response = await http.get(Uri.parse('${baseUrl}todos/get'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Get Completed Tasks
  Future<TaskListModel> getCompletedTask(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse('${baseUrl}todos/completed'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Get InCompleted Tasks
  Future<TaskListModel> getInCompletedTask(String token) async {
    try {
      http.Response response = await http.get(
          Uri.parse('${baseUrl}todos/incomplete'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Update Task
  Future<bool> updateTask(
      {required String token,
      required String description,
      required String taskID}) async {
    log(taskID.toString());
    log(token.toString());
    try {
      http.Response response = await http
          .patch(Uri.parse('${baseUrl}todos/update/$taskID'), headers: {
        'Authorization': token,
        'Content-Type': 'application/json'
      },
      body: jsonEncode({
        'description':description,
        'complete':false
      }));
      log(response.request!.url.toString());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Search Task
  Future<TaskListModel> searchTask(
      {required String token, required String searchKey}) async {
    try {
      http.Response response = await http.get(
          Uri.parse('uri?keywords=$searchKey'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Filter Task
  Future<TaskListModel> getFilterTask(
      {required String token,
      required String firstDate,
      required String lastDate}) async {
    try {
      http.Response response = await http.get(
          Uri.parse('uri?startDate=$firstDate&endDate=$lastDate'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TaskListModel.fromJson(jsonDecode(response.body));
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  ///Delete Task
  Future<bool> deleteTask(
      {required String token, required String taskID}) async {
    try {
      http.Response response = await http.delete(
          Uri.parse('${baseUrl}todos/delete/$taskID'),
          headers: {'Authorization': token});

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        throw response.reasonPhrase.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
