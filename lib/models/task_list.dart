// To parse this JSON data, do
//
//     final taskListModel = taskListModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter_b11_api/models/task.dart';

TaskListModel taskListModelFromJson(String str) => TaskListModel.fromJson(json.decode(str));

String taskListModelToJson(TaskListModel data) => json.encode(data.toJson());

class TaskListModel {
  final List<Task>? tasks;
  final int? totalPages;
  final int? currentPage;
  final int? count;

  TaskListModel({
    this.tasks,
    this.totalPages,
    this.currentPage,
    this.count,
  });

  factory TaskListModel.fromJson(Map<String, dynamic> json) => TaskListModel(
    tasks: json["tasks"] == null ? [] : List<Task>.from(json["tasks"]!.map((x) => Task.fromJson(x))),
    totalPages: json["totalPages"],
    currentPage: json["currentPage"],
    count: json["count"],
  );

  Map<String, dynamic> toJson() => {
    "tasks": tasks == null ? [] : List<dynamic>.from(tasks!.map((x) => x.toJson())),
    "totalPages": totalPages,
    "currentPage": currentPage,
    "count": count,
  };
}
