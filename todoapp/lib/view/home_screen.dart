// view/home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controller/task_controller.dart';
import 'package:todoapp/view/task_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.put(TaskController());
    final TextEditingController searchController = TextEditingController();
    final Map<int, String> priorityLabels = {
      1: 'High',
      2: 'Medium',
      3: 'Low',
    };

    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.blue,
        title: const Text("To Do List",  style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search,color: Colors.white,),
            onPressed: () {
              Get.defaultDialog(
                title: "Search Tasks",
                content: Column(
                  children: [
                    TextField(
                      controller: searchController,
                      decoration:
                          const InputDecoration(hintText: "Enter keyword"),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            taskController.searchTasks(searchController.text);
                            Get.back(); // Close the dialog
                          },
                          child: const Text("Search"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                          ),
                          onPressed: () {
                            searchController.clear();
                            taskController
                                .sortTasksByCreation(); // Reset to original full list
                            Get.back();
                          },
                          child: const Text("Clear"),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          PopupMenuButton<String>(iconColor: Colors.white,
            onSelected: (value) {
              if (value == "Priority") {
                taskController.sortTasksByPriority();
              } else if (value == "Due Date") {
                taskController.sortTasksByDueDate();
              } else if (value == "Creation") {
                taskController.sortTasksByCreation();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                  value: "Priority", child: Text("Sort by Priority")),
              const PopupMenuItem(
                  value: "Due Date", child: Text("Sort by Due Date")),
              const PopupMenuItem(
                  value: "Creation", child: Text("Sort by Creation")),
            ],
          )
        ],
      ),
      body: 

      Obx(() => ListView.builder(
            itemCount: taskController.tasks.length,
            itemBuilder: (context, index) {
              final task = taskController.tasks[index];
              return ListTile(
                title: Text(task.title),
                subtitle: Text(
                  "Priority: ${priorityLabels[task.priority] ?? 'Unknown'} | Due: ${DateFormat.yMd().add_jm().format(task.dueDate)}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => taskController.removeTask(index),
                ),
                onTap: () => Get.to(() => TaskForm(index: index, task: task)),
              );
            },
          )),
      floatingActionButton: FloatingActionButton( backgroundColor: Colors.blue,
        onPressed: () => Get.to(() => const TaskForm()),
        child: const Icon(Icons.add,color: Colors.white,),
      ),
    );
  }
}



