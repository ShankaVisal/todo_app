import 'package:flutter/material.dart';

class TodoListProvider extends ChangeNotifier {
  List<dynamic> todo_list = [
    // {"title": "title 1", "subtitle": "subtitle 1", "date": "2025.01.13", "time":"21:23"},
    // {"title": "title 2", "subtitle": "subtitle 2", "date": "2090.01.13", "time":"21:23"},
    // {"title": "title 3", "subtitle": "subtitle 3", "date": "2789.01.13", "time":"21:23"},
  ];

  void addToDo(String title, String description, DateTime scheduleDate, TimeOfDay scheduleTime) {
    todo_list.add(Map()
      ..["title"] = title
      ..["subtitle"] = description
      ..["date"] = "${scheduleDate.year}.${scheduleDate.month}.${scheduleDate.day}"
      ..["time"] = "${scheduleTime.hour}:${scheduleTime.minute}"
      ..["isChecked"] = false
    );

    notifyListeners();
  }

  void deleteToDoTask(int index) {
    todo_list.removeAt(index);

    notifyListeners();
  }
}
