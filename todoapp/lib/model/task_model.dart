class Task {
  final String title;
  final String description;
  final int priority;
  final DateTime dueDate;
  final DateTime creationDate;  // add this!

  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    DateTime? creationDate,
  }) : creationDate = creationDate ?? DateTime.now();

  get id => null;
}
