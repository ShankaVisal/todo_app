import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/todo_list.dart';

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
  DateTime ? selectDate;
  TimeOfDay ? selectTime;

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, todoListProviderModal, child) => Scaffold(
        body: Container(
          child: Column(
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
                decoration: InputDecoration(label: Text("Date")),
                onTap: () async {
                  selectDate = await showDatePicker(
                    context: context, 
                    firstDate: DateTime.now(), 
                    lastDate: DateTime(2100)
                    );

                    if(selectDate != null){
                      scheduleDate.text = "${selectDate!.year}-${selectDate!.month.toString().padLeft(2, '0')}-${selectDate!.day.toString().padLeft(2, '0')}";
                    }
                },
              ),

              TextField(
                controller: scheduleTime,
                decoration: InputDecoration(label: Text("Time")),
                onTap: () async{
                  selectTime = await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.now()
                    );
                  if(selectTime !=null){
                    scheduleTime.text = "${selectTime!.hour} : ${selectTime!.minute}";
                  }
                },
              ),

              TextButton(
                onPressed: (){
                  todoListProviderModal.addToDo(title.text, subtitle.text, selectDate!, selectTime!);
                  Navigator.pop(context);
                }, 
                child: Text("Submit")
                ),
              
            ],
          ),
        ),
      ),
    );
  }
}
