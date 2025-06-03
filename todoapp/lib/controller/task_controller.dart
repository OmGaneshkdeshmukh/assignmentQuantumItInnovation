//Author : Omganesh K. Deshmukh
//Date : 03/06/2025
// This class serves as the controller for managing Task objects.
// It handles the business logic related to task operations such as
// adding new tasks, updating existing tasks, deleting tasks, and retrieving
// task lists. This controller acts as an intermediary between the UI and the data layer.

import 'dart:developer'; // For logging messages to the console
import 'package:get/get.dart'; // GetX package for state management
import 'package:todoapp/db_helper.dart'; // Database helper for task operations (CRUD)
import 'package:todoapp/model/task_model.dart'; // Task model representing task structure


class TaskController extends GetxController {
  // Reactive list of all tasks from the database
  var allTasks = <Task>[].obs; 

  // Reactive list used in the UI, can be filtered or sorted from allTasks
  var tasks = <Task>[].obs;    

  @override
  void onInit() {
    super.onInit();
    loadTasks(); // Load tasks from the database when the controller is initialized
  }

  // Loads all tasks from the database and populates both allTasks and tasks
  Future<void> loadTasks() async {
    final data = await DBHelper.fetchTasks();
    allTasks.assignAll(data); // Master list updated
    tasks.assignAll(allTasks); // UI list updated
    log("[Controller] Tasks loaded from DB: ${allTasks.length}");
  }

  // Adds a new task to the database and reloads tasks
  Future<void> addTask(Task task) async {
    await DBHelper.insertTask(task); // Save task to DB
    await loadTasks(); // Refresh lists from DB
    tasks.add(task); // Add to UI list
  }

  // Removes a task from the database and both lists by index
  void removeTask(int index) async {
    if (index >= 0 && index < tasks.length) {
      final taskToRemove = tasks[index];

      if (taskToRemove.id != null) {
        await DBHelper.deleteTask(taskToRemove.id!); // Delete from DB
      }

      allTasks.remove(taskToRemove); // Remove from master list
      tasks.removeAt(index); // Remove from UI list
      log("Task '${taskToRemove.title}' deleted");
    } else {
      log("Invalid index $index for deleting task");
    }
  }

  // Updates a task in both task lists based on its index
  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < tasks.length) {
      final oldTask = tasks[index];
      final allIndex = allTasks.indexOf(oldTask);
      if (allIndex != -1) {
        allTasks[allIndex] = updatedTask; // Update in master list
      }
      tasks[index] = updatedTask; // Update in UI list
    } else {
      log("Invalid index $index for updating task");
    }
    tasks[index] = updatedTask; // Ensures task list reflects the update
  }

  // Sorts tasks by priority (ascending) and updates UI list
  void sortTasksByPriority() {
    allTasks.sort((a, b) => a.priority.compareTo(b.priority));
    tasks.assignAll(allTasks);
  }

  // Sorts tasks by due date (earliest first) and updates UI list
  void sortTasksByDueDate() {
    allTasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    tasks.assignAll(allTasks);
  }

  // Sorts tasks by creation date (oldest first) and updates UI list
  void sortTasksByCreation() {
    allTasks.sort((a, b) => a.creationDate.compareTo(b.creationDate));
    tasks.assignAll(allTasks);
  }

  // Filters tasks based on search query in title or description
  void searchTasks(String query) {
    if (query.isEmpty) {
      tasks.assignAll(allTasks); // If query is empty, show all tasks
    } else {
      final lower = query.toLowerCase();
      tasks.assignAll(allTasks.where((task) {
        return task.title.toLowerCase().contains(lower) ||
            task.description.toLowerCase().contains(lower);
      }).toList()); // Show only matching tasks
    }
  }
}
