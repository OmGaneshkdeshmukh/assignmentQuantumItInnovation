//Author : Omganesh K. Deshmukh
//Date: 03/06/2025
//This Screen Represents Task Form to create task

import 'dart:developer'; // For logging purposes
import 'package:flutter/material.dart'; // Flutter UI framework
import 'package:get/get.dart'; // GetX for state management and navigation
import 'package:intl/intl.dart'; // For date and time formatting
import 'package:todoapp/controller/local_notification.dart'; // Custom controller for showing local notifications
import 'package:todoapp/controller/task_controller.dart'; // Controller to manage task state (add/update)
import 'package:todoapp/model/task_model.dart'; // Task model class

// TaskForm widget allows adding or editing a task
class TaskForm extends StatefulWidget {
  final int? index; // Used to determine if task is new or being edited
  final Task? task; // Task data to populate if editing

  const TaskForm({super.key, this.index, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

// Priority mapping to display labels for integer values
final Map<int, String> _priorityMap = {
  1: 'High',
  2: 'Medium',
  3: 'Low',
};

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>(); // Key for form validation
  final _titleController = TextEditingController(); // Controller for title input
  final _descriptionController = TextEditingController(); // Controller for description input
  int _priority = 1; // Default priority
  DateTime _dueDate = DateTime.now(); // Default due date is now

  @override
  void initState() {
    super.initState();
    // If task is being edited, populate fields with existing values
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find(); // Get the task controller

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.index == null ? "Add Task" : "Edit Task", // Dynamic title
          selectionColor: Colors.white,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Assign form key for validation
          child: ListView(
            children: [
              // Input field for Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              // Input field for Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Enter description' : null,
              ),
              // Dropdown for selecting Priority
              DropdownButtonFormField<int>(
                value: _priority,
                items: _priorityMap.entries.map((entry) {
                  return DropdownMenuItem<int>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _priority = value!),
                decoration: const InputDecoration(labelText: 'Priority'),
                validator: (value) => value == null ? 'Select priority' : null,
              ),
              // Date and Time picker for Due Date
              ListTile(
                title: Text(
                  "Due Date: ${DateFormat.yMd().add_jm().format(_dueDate)}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  // First pick date
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    // Then pick time
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dueDate),
                    );
                    if (time != null) {
                      setState(() {
                        _dueDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 50),
              // Save/Update Task button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 50),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Create new task from form data
                    final newTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority,
                      dueDate: _dueDate,
                    );

                    // Add or update task in controller
                    if (widget.index == null) {
                      taskController.addTask(newTask);
                    } else {
                      taskController.updateTask(widget.index!, newTask);
                    }

                    // Optional: Subtract 1 min to simulate notification time
                    _dueDate.subtract(const Duration(minutes: 1));

                    // Show a local notification
                    LocalNotification.showSimpleNotification(
                      title: "Task Added Successfully",
                      body: "Task Notiffy", // Could be improved for grammar
                      payload: "Task Data",
                    );

                    // Log and return to home
                    log("Task added, returning to home");
                    Get.back();
                  }
                },
                child: Text(widget.index == null ? 'Add Task' : 'Update Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
