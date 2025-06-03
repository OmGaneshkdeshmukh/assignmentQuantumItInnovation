import 'dart:developer';
import 'package:get/get.dart';
import 'package:todoapp/db_helper.dart';
import 'package:todoapp/model/task_model.dart';

class TaskController extends GetxController {
  var allTasks = <Task>[].obs; // Master list
  var tasks = <Task>[].obs;    // Filtered list shown in UI

  @override
  void onInit() {
    super.onInit();
    loadTasks(); // Loads tasks from DB on startup
  }

  Future<void> loadTasks() async {
    final data = await DBHelper.fetchTasks();
    allTasks.assignAll(data);
    tasks.assignAll(allTasks);
    log("[Controller] Tasks loaded from DB: ${allTasks.length}");
  }

  Future<void> addTask(Task task) async {
    await DBHelper.insertTask(task);
    await loadTasks(); 
    tasks.add(task);
  }


void removeTask(int index) async {
  if (index >= 0 && index < tasks.length) {
    final taskToRemove = tasks[index];

    if (taskToRemove.id != null) {
      await DBHelper.deleteTask(taskToRemove.id!);
    }

    allTasks.remove(taskToRemove);
    tasks.removeAt(index);
    log("Task '${taskToRemove.title}' deleted");
  } else {
    log("Invalid index $index for deleting task");
  }
}


  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < tasks.length) {
      final oldTask = tasks[index];
      final allIndex = allTasks.indexOf(oldTask);
      if (allIndex != -1) {
        allTasks[allIndex] = updatedTask;
      }
      tasks[index] = updatedTask;
    } else {
      log("Invalid index $index for updating task");
    }
     tasks[index] = updatedTask;
  }

  void sortTasksByPriority() {
    allTasks.sort((a, b) => a.priority.compareTo(b.priority));
    tasks.assignAll(allTasks);
  }

  void sortTasksByDueDate() {
    allTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    tasks.assignAll(allTasks);
  }

  void sortTasksByCreation() {
    allTasks.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    tasks.assignAll(allTasks);
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      tasks.assignAll(allTasks);
    } else {
      final lower = query.toLowerCase();
      tasks.assignAll(allTasks.where((task) {
        return task.title.toLowerCase().contains(lower) ||
            task.description.toLowerCase().contains(lower);
      }).toList());
    }
  }
}
