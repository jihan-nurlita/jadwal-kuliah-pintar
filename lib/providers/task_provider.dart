import 'package:flutter/material.dart';
import '../data/models/task_model.dart';
import '../data/services/hive_service.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get tasks => _tasks;

  List<TaskModel> get completedTasks => _tasks.where((element) => element.selesai).toList();
  List<TaskModel> get activeTasks => _tasks.where((element) => !element.selesai).toList();

  TaskProvider() {
    loadTasks();
  }

  Future<void> loadTasks() async {
    final rawList = await HiveService.getTasks();
    _tasks = rawList.map((e) => TaskModel.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> addTask(TaskModel item) async {
    _tasks.add(item);
    await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  Future<void> editTask(TaskModel updatedItem) async {
    final index = _tasks.indexWhere((e) => e.id == updatedItem.id);
    if (index != -1) {
      _tasks[index] = updatedItem;
      await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((e) => e.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(selesai: !_tasks[index].selesai);
      await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((e) => e.id == id);
    await HiveService.saveTasks(_tasks.map((e) => e.toJson()).toList());
    notifyListeners();
  }
}
