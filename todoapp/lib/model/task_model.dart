// model/task_model.dart
class Task {
  String title;
  String description;
  int priority;
  DateTime dueDate;

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
  });
}
