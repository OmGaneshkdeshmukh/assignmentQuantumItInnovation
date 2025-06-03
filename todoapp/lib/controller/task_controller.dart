// import 'dart:developer';

// import 'package:get/get.dart';
// import 'package:todoapp/controller/notification_service.dart';
// import 'package:todoapp/model/task_model.dart';

// class TaskController extends GetxController {
//   var allTasks = <Task>[].obs; // master list
//   var tasks = <Task>[].obs;    // filtered list shown in UI

//   void addTask(Task task) {
//   tasks.add(task);

//   // Schedule a notification 1 hour before due date
//   final reminderTime = task.dueDate.subtract(const Duration(hours: 1));
//   if (reminderTime.isAfter(DateTime.now())) {
//     NotificationService.scheduleNotification(
//       id: tasks.length, // use a unique ID
//       title: 'Task Reminder',
//       body: '${task.title} is due soon!',
//       scheduledTime: reminderTime,
//     );
//   }
// }

//  void removeTask(int index) {
//   if (index >= 0 && index < tasks.length) {
//     tasks.removeAt(index);
//   } else {
//     log("Invalid index $index for removing task");
//   }
// }

// void updateTask(int index, Task updatedTask) {
//   if (index >= 0 && index < tasks.length) {
//     tasks[index] = updatedTask;
//   } else {
//     log("Invalid index $index for updating task");
//     // Optionally show a user-friendly message or ignore
//   }
// }

//   void sortTasksByPriority() {
//     tasks.sort((a, b) => a.priority.compareTo(b.priority));
//   }

//   void sortTasksByDueDate() {
//     tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
//   }

//   void sortTasksByCreation() {
//     tasks.assignAll(allTasks);
//   }

//   void searchTasks(String query) {
//     if (query.isEmpty) {
//       tasks.assignAll(allTasks);
//     } else {
//       tasks.assignAll(allTasks.where((task) {
//         final lower = query.toLowerCase();
//         return task.title.toLowerCase().contains(lower) ||
//             task.description.toLowerCase().contains(lower);
//       }));
//     }
//   }

// }

import 'dart:developer';
import 'package:get/get.dart';
import 'package:todoapp/controller/notification_service.dart';
import 'package:todoapp/db_helper.dart';
import 'package:todoapp/model/task_model.dart';
import 'package:todoapp/services/notification_helper.dart';

class TaskController extends GetxController {
  var allTasks = <Task>[].obs; // master list
  var tasks = <Task>[].obs; // filtered list shown in UI

 
@override
  void onInit() {
  super.onInit();
  loadTasks(); // This will automatically trigger logs from DBHelper
}
 void loadTasks() async {
  tasks.value = await DBHelper.fetchTasks();
}


  void addTask(Task task)async {
    allTasks.add(task);
    tasks.assignAll(allTasks);
    checkAndSchedule(task);
    await DBHelper.insertTask(task);
  tasks.add(task);

    // // Schedule a notification 1 hour before due date
    // final reminderTime = task.dueDate.subtract(const Duration(minutes: 5));
    // if (reminderTime.isAfter(DateTime.now())) {
    //   NotificationService.scheduleNotification(
    //     id: task.hashCode, // unique ID for notification
    //     title: 'Task Reminder',
    //     body: '${task.title} is due soon!',
    //     scheduledTime: reminderTime,
    //   );
    //   checkAndSchedule(task);
    //   log('Notification scheduled for task "${task.title}" at $reminderTime');
    // }
  }

  void checkAndSchedule(Task task) async {
    bool granted = await requestNotificationPermission();
    if (granted) {
      final reminderTime = task.dueDate.subtract(const Duration(minutes: 1));
      if (reminderTime.isAfter(DateTime.now())) {
        NotificationService.scheduleNotification(
          id: task.hashCode,
          title: 'Task Reminder',
          body: '${task.title} is due soon!',
          scheduledTime: reminderTime,
        );
        log("🔔 Notification scheduled for '${task.title}' at $reminderTime");
      } else {
        log("❗ Reminder time for '${task.title}' has already passed");
      }
    } else {
      log('🚫 Notification permission denied');
    }
  }

  void removeTask(int index) {
    if (index >= 0 && index < tasks.length) {
      // Remove from allTasks as well
      final taskToRemove = tasks[index];
      allTasks.remove(taskToRemove);
      tasks.removeAt(index);
    } else {
      log("Invalid index $index for removing task");
    }
  }

  void updateTask(int index, Task updatedTask) {
    if (index >= 0 && index < tasks.length) {
      final oldTask = tasks[index];
      // Update in allTasks
      final allIndex = allTasks.indexOf(oldTask);
      if (allIndex != -1) {
        allTasks[allIndex] = updatedTask;
      }
      tasks[index] = updatedTask;
    } else {
      log("Invalid index $index for updating task");
    }
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
