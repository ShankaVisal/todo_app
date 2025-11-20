import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime scheduledDate;

  @HiveField(4)
  String createdAt;

  @HiveField(5)
  bool isChecked;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.scheduledDate,
    this.isChecked = false,
    required this.createdAt
  }) ;
}
