//Author : Omganesh K.Deshmukh
//Date :03/04/2025
//This Screen Represent the Database operations .

// Importing dart:developer for logging debug information
import 'dart:developer';
// Importing path package to help with file system path operations
import 'package:path/path.dart';
// Importing sqflite package for SQLite database operations in Flutter
import 'package:sqflite/sqflite.dart';
// Importing the Task model to map database records to Task objects
import 'package:todoapp/model/task_model.dart';


/// DBHelper is a utility class to manage local SQLite database operations
/// such as creating the database, inserting, fetching, and deleting tasks.
class DBHelper {
  // Holds the reference to the database instance
  static Database? _db;

  /// Returns the existing database instance or initializes it if null
  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  /// Initializes the database and creates the tasks table if it doesn't exist
  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath(); // Get path to store the DB
    final path = join(dbPath, 'tasks.db'); // Create full path to database file

    // Open the database and create the table
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            priority INTEGER,
            dueDate TEXT
          )
        ''');
      },
    );
  }

  /// Inserts a task into the 'tasks' table
  /// Also logs all tasks after insertion for debugging purposes
  static Future<void> insertTask(Task task) async {
    final db = await database;

    // Insert the task into the database
    await db.insert(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'priority': task.priority,
        'dueDate': task.dueDate.toIso8601String(), // Store date as ISO string
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Avoid overwriting
    );

    log('[DB] Task added to local storage: ${task.title}, Priority: ${task.priority}');

    // Fetch and log all tasks after insertion
    final allTasks = await fetchTasks();
    if (allTasks.isNotEmpty) {
      log('[LOG] Existing Tasks from Local Storage:');
      for (var t in allTasks) {
        log('- ${t.title} | Priority: ${t.priority} | Due: ${t.dueDate}');
      }
    } else {
      log('[LOG] No tasks found in local storage.');
    }
  }

  /// Fetches all tasks from the database and returns them as a list of Task objects
  static Future<List<Task>> fetchTasks() async {
    final db = await database;

    // Query all rows in the 'tasks' table
    final result = await db.query('tasks');

    // Map the results to Task objects
    return result.map((e) => Task(
      title: e['title'] as String,
      description: e['description'] as String,
      priority: e['priority'] as int,
      dueDate: DateTime.parse(e['dueDate'] as String),
    )).toList();
  }

  /// Deletes a task from the database by its ID
  /// Returns the number of rows affected
  static Future<int> deleteTask(int id) async {
    final db = await database;
    final deleted = await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
    log('[DB] Deleted task with ID: $id');
    return deleted;
  }
}
