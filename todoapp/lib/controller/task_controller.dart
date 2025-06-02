import 'package:get/get.dart';
import 'package:todoapp/model/task_model.dart';

class TaskController extends GetxController {
  var allTasks = <Task>[].obs; // master list
  var tasks = <Task>[].obs;    // filtered list shown in UI

  void addTask(Task task) {
    allTasks.add(task);
    tasks.assignAll(allTasks);
  }

  void removeTask(int index) {
    allTasks.removeAt(index);
    tasks.assignAll(allTasks);
  }

  void updateTask(int index, Task task) {
    allTasks[index] = task;
    tasks.assignAll(allTasks);
  }

  void sortTasksByPriority() {
    tasks.sort((a, b) => b.priority.compareTo(a.priority));
  }

  void sortTasksByDueDate() {
    tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  void sortTasksByCreation() {
    tasks.assignAll(allTasks);
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      tasks.assignAll(allTasks);
    } else {
      tasks.assignAll(allTasks.where((task) {
        final lower = query.toLowerCase();
        return task.title.toLowerCase().contains(lower) ||
            task.description.toLowerCase().contains(lower);
      }));
    }
  }
}
