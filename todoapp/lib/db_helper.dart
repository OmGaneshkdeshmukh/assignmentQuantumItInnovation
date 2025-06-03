import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoapp/model/task_model.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }
  
  static get tasks => null;

  static Future<Database> initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT,
          description TEXT,
          priority INTEGER,
          dueDate TEXT
        )
      ''');
    });
  }

  static Future<void> insertTask(Task task) async {
    final db = await database;
    await db.insert('tasks', {
      'title': task.title,
      'description': task.description,
      'priority': task.priority,
      'dueDate': task.dueDate.toIso8601String(),
    });
    log('[DB] Task added to local storage: ${task.title}, Priority: ${task.priority}');
    // Log tasks
  if (tasks.isNotEmpty) {
    log('[LOG] Existing Tasks from Local Storage:');
    for (var t in tasks) {
      log('- ${t.title} | Priority: ${t.priority} | Due: ${t.dueDate}');
    }
  } else {
    log('[LOG] No tasks found in local storage.');
  }

  return tasks;
  }

  static Future<List<Task>> fetchTasks() async {
    final db = await database;
    final result = await db.query('tasks');
    return result.map((e) => Task(
      title: e['title'] as String,
      description: e['description'] as String,
      priority: e['priority'] as int,
      dueDate: DateTime.parse(e['dueDate'] as String),
    )).toList();
  }
}
