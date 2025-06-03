// Author: Omganesh K. Deshmukh
// Date: 03/06/2025
// Description:
// This class represents a Task model used to store task-related information
// in a task management or to-do list application. Each task has a title,
// description, priority level, due date, and a creation date (defaults to current time).
// The id getter is currently a placeholder and can be extended for database integration.

// This class represents a Task model with properties such as title, description, priority, due date, and creation date.
class Task {
  final String title;           // Title of the task
  final String description;     // Description/details of the task
  final int priority;           // Priority level: 1 - High, 2 - Medium, 3 - Low
  final DateTime dueDate;       // Due date and time for the task
  final DateTime creationDate;  // Date and time when the task was created

  // Constructor to initialize a task.
  // If creationDate is not provided, it defaults to the current date and time.
  Task({
    required this.title,
    required this.description,
    required this.priority,
    required this.dueDate,
    DateTime? creationDate,
  }) : creationDate = creationDate ?? DateTime.now();

  // Getter for task ID (can be used for database operations)
  get id => null;
}
