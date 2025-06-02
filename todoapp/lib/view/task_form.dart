// view/task_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/controller/notification_service.dart';
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
      appBar:
          AppBar(title: Text(widget.index == null ? "Add Task" : "Edit Task")),
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
              const SizedBox(height: 20),
              ElevatedButton(
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

                    // Schedule reminder 10 minutes before due date
                    final reminderTime =
                        _dueDate.subtract(const Duration(minutes: 10));
                    if (reminderTime.isAfter(DateTime.now())) {
                      await NotificationService.scheduleNotification(
                        id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                        title: 'Reminder: ${newTask.title}',
                        body:
                            'This task is due at ${DateFormat.jm().format(_dueDate)}',
                        scheduledTime: reminderTime,
                      );
                    }

                    Get.back();
                  }
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
