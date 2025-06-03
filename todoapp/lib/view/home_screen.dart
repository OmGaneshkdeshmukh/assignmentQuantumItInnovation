//Author : Omganesh K.Deshmukh
//Date :03/04/2025
//This Screen Represent the home page .

import 'package:flutter/material.dart'; // Flutter framework for UI components
import 'package:get/get.dart'; // GetX package for state management and navigation
import 'package:intl/intl.dart'; // For date formatting
import 'package:todoapp/controller/task_controller.dart'; // Controller managing task data and logic
import 'package:todoapp/view/task_form.dart'; // Screen for creating/editing a task

// Main screen of the ToDo app displaying the list of tasks
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize TaskController with GetX for state management
    final TaskController taskController = Get.put(TaskController());
    // Controller to handle text input for searching tasks
    final TextEditingController searchController = TextEditingController();
    // Mapping of priority levels to their labels
    final Map<int, String> priorityLabels = {
      1: 'High',
      2: 'Medium',
      3: 'Low',
    };

    // Get screen width for responsive horizontal padding
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Top app bar with title and action buttons
      appBar: AppBar(
        backgroundColor: Colors.blue,
        // Title wrapped with FittedBox to prevent overflow on smaller screens
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: const Text(
            "To Do List",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        centerTitle: true,
        actions: [
          // Search button to open dialog for searching tasks
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Show search dialog with input field and buttons
              Get.defaultDialog(
                title: "Search Tasks",
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Input text field for entering search keywords
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(hintText: "Enter keyword"),
                      ),
                      const SizedBox(height: 20),
                      // Row containing Search and Clear buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              // Trigger search in controller and close dialog
                              taskController.searchTasks(searchController.text);
                              Get.back();
                            },
                            child: const Text("Search",style: TextStyle( fontWeight: FontWeight.w500,color: Colors.white),),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {
                              // Clear search input, reset task list, and close dialog
                              searchController.clear();
                              taskController.sortTasksByCreation();
                              Get.back();
                            },
                            child: const Text("Clear",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.white),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Popup menu to sort tasks by different criteria
          PopupMenuButton<String>(
            iconColor: Colors.white,
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
              const PopupMenuItem(value: "Priority", child: Text("Sort by Priority")),
              const PopupMenuItem(value: "Due Date", child: Text("Sort by Due Date")),
              const PopupMenuItem(value: "Creation", child: Text("Sort by Creation")),
            ],
          )
        ],
      ),

      // Body shows list of tasks with automatic UI update using Obx
      body: Obx(() => ListView.builder(
            itemCount: taskController.tasks.length, // Number of tasks
            itemBuilder: (context, index) {
              final task = taskController.tasks[index]; // Current task

              return Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03), // Responsive horizontal padding
                child: ListTile(
                  title: Text(
                    task.title,
                    maxLines: 1, // Single line with ellipsis if too long
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    // Display priority label and formatted due date/time
                    "Priority: ${priorityLabels[task.priority] ?? 'Unknown'} | Due: ${DateFormat.yMd().add_jm().format(task.dueDate)}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Delete button for the task
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => taskController.removeTask(index),
                  ),
                  // Tap to edit the task opens TaskForm with current task data
                  onTap: () => Get.to(() => TaskForm(index: index, task: task)),
                ),
              );
            },
          )),

      // Floating action button to add a new task
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Get.to(() => const TaskForm()), // Navigate to empty form for new task
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
