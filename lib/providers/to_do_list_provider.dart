import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:uuid/uuid.dart';

class TodoListProvider extends ChangeNotifier {
  final String _boxName = 'tasks';
  final uuid = Uuid();
  String _searchQuery = "";

  List<Task> _tasks = [];

  List<Task> get tasks {
    if (_searchQuery.isEmpty) return _tasks;
    return _tasks
        .where((task) =>
            task.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> init() async {
    final box = await Hive.openBox<Task>(_boxName);
    _tasks = box.values.toList();
    notifyListeners();
  }

  Future<void> addTask(String title, String description, DateTime scheduleDate,
      Time createdAt, String priority) async {
    final box = Hive.box<Task>(_boxName);

    final formattedTime =
        "${createdAt.hour.toString().padLeft(2, '0')}:${createdAt.minute.toString().padLeft(2, '0')}";

    final task = Task(
      id: uuid.v4(),
      title: title,
      description: description,
      scheduledDate: scheduleDate,
      scheduleTime: formattedTime,
      priority: priority,
      createdAt: DateTime.now(),
    );

    await box.put(task.id, task);
    _tasks = box.values.toList();
    notifyListeners();
  }

  Future<void> toggleComplete(Task task) async {
    final box = Hive.box<Task>(_boxName);
    task.isChecked = !task.isChecked;
    await task.save();
    _tasks = box.values.toList();
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    final box = Hive.box<Task>(_boxName);
    await box.delete(id);
    _tasks = box.values.toList();
    notifyListeners();
  }
}

// import 'package:flutter/material.dart';

// class TodoListProvider extends ChangeNotifier {
//   List<dynamic> todo_list = [
//     // {"title": "title 1", "subtitle": "subtitle 1", "date": "2025.01.13", "time":"21:23"},
//     // {"title": "title 2", "subtitle": "subtitle 2", "date": "2090.01.13", "time":"21:23"},
//     // {"title": "title 3", "subtitle": "subtitle 3", "date": "2789.01.13", "time":"21:23"},
//   ];

//   void addToDo(String title, String description, DateTime scheduleDate, TimeOfDay scheduleTime) {
//     todo_list.add(Map()
//       ..["title"] = title
//       ..["subtitle"] = description
//       ..["date"] = "${scheduleDate.year}.${scheduleDate.month}.${scheduleDate.day}"
//       ..["time"] = "${scheduleTime.hour}:${scheduleTime.minute}"
//       ..["isChecked"] = false
//     );

//     notifyListeners();
//   }

//   void deleteToDoTask(int index) {
//     todo_list.removeAt(index);

//     notifyListeners();
//   }
// }
