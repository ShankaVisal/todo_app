import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/to_do_list_provider.dart';

class NewToDoTaskPage extends StatefulWidget {
  const NewToDoTaskPage({super.key});

  @override
  State<NewToDoTaskPage> createState() => _NewToDoTaskPageState();
}

class _NewToDoTaskPageState extends State<NewToDoTaskPage> {
  TextEditingController title = TextEditingController();
  TextEditingController subtitle = TextEditingController();
  TextEditingController scheduleDate = TextEditingController();
  TextEditingController scheduleTime = TextEditingController();
  DateTime? selectDate;
  Time selectTime = Time(hour: 11, minute: 30, second: 20);
  String? selectedPriority;

  void onTimeChanged(Time newTime) {
    setState(() {
      selectTime = newTime;
      scheduleTime.text =
          "${selectTime.hour.toString().padLeft(2, '0')} : ${selectTime.minute.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, todoListProviderModal, child) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              autocorrect: true,
              controller: title,
              decoration: InputDecoration(label: Text("Task Name")),
            ),
            TextField(
              controller: subtitle,
              decoration: InputDecoration(label: Text("Description")),
            ),
            TextField(
              controller: scheduleDate,
              readOnly: true,
              decoration: InputDecoration(label: Text("Date")),
              onTap: () async {
                selectDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100));
        
                if (selectDate != null) {
                  scheduleDate.text =
                      "${selectDate!.year}-${selectDate!.month.toString().padLeft(2, '0')}-${selectDate!.day.toString().padLeft(2, '0')}";
                }
              },
            ),
            TextField(
              controller: scheduleTime,
              decoration: InputDecoration(label: Text("Time")),
              readOnly: true,
              onTap: () async {
                Navigator.of(context).push(
                  showPicker(
                    context: context,
                    value: selectTime,
                    sunrise: TimeOfDay(hour: 6, minute: 0), // optional
                    sunset: TimeOfDay(hour: 18, minute: 0), // optional
                    duskSpanInMinutes: 120, // optional
                    onChange: onTimeChanged,
                  ),
                );
              },
            ),
            DropdownButton(
              value: selectedPriority,
              items: ["Low", "Medium", "High"].map((String value){
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(), 
              onChanged: (newValue) {
                setState(() {
                  selectedPriority = newValue;
                });
              }
            ),
            TextButton(
                onPressed: () {
                  todoListProviderModal.addTask(
                      title.text, subtitle.text, selectDate!, selectTime, selectedPriority!);
                  Navigator.pop(context);
                },
                child: Text("Submit")),
          ],
        ),
      ),
    );
  }
}
