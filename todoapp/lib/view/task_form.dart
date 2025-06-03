import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controller/localnotification.dart';
import 'package:todoapp/controller/task_controller.dart';
import 'package:todoapp/model/task_model.dart';

class TaskForm extends StatefulWidget {
  final int? index;
  final Task? task;

  const TaskForm({super.key, this.index, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

final Map<int, String> _priorityMap = {
  1: 'High',
  2: 'Medium',
  3: 'Low',
};

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _priority = 1;
  DateTime _dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _priority = widget.task!.priority;
      _dueDate = widget.task!.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final TaskController taskController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.index == null ? "Add Task" : "Edit Task",
          selectionColor: Colors.white,
          style: TextStyle(fontWeight: FontWeight.w600,color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) => value!.isEmpty ? 'Enter title' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter description' : null,
              ),
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
              ListTile(
                title: Text(
                    "Due Date: ${DateFormat.yMd().add_jm().format(_dueDate)}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_dueDate),
                    );
                    if (time != null) {
                      setState(() {
                        _dueDate = DateTime(date.year, date.month, date.day,
                            time.hour, time.minute);
                      });
                    }
                  }
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, //  Button background color
                  foregroundColor: Colors.white, //  Text (foreground) color
                  minimumSize: const Size(200, 50), //  Width: 200, Height: 50
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 15), // Padding inside button
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), //  Rounded corners
                  ),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newTask = Task(
                      title: _titleController.text,
                      description: _descriptionController.text,
                      priority: _priority,
                      dueDate: _dueDate,
                    );

                    if (widget.index == null) {
                      taskController.addTask(newTask);
                    } else {
                      taskController.updateTask(widget.index!, newTask);
                    }
                  }

                  // Schedule notification 10 mins before due date
                  _dueDate.subtract(const Duration(minutes: 1));

                  LocalNotification.showSimpleNotification(
                    title: "Task Added Successfully",
                    body: "Task Notiffy",
                    payload: "Task Data",
                  );
                  Text("Notification");

                  Get.back();
                  log("Task added, returning to home");
                },
                child: Text(widget.index == null ? 'Add Task' : 'Update Task'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
