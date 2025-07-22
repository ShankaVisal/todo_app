import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/new_todo_task.dart';
import 'package:todo_app/todo_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder:(context, todoListProviderModal, child) =>  Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewToDoTaskPage()));
        }, child: Icon(Icons.add),),
        backgroundColor:Colors.white,
        body: ListView.builder(
          itemCount: todoListProviderModal.todo_list.length,
          itemBuilder: (context, index){
            return ListTile(
              autofocus: true,
              leading: IconButton(onPressed: (){}, icon: Icon(Icons.check_box_outline_blank)),
              trailing: IconButton(onPressed: (){todoListProviderModal.deleteToDoTask(index);}, icon: Icon(Icons.delete)),
              title: Text(todoListProviderModal.todo_list[index]["title"]),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todoListProviderModal.todo_list[index]["subtitle"]),
                  Text(todoListProviderModal.todo_list[index]["date"]),
                  Text(todoListProviderModal.todo_list[index]["time"])
                ],
              ),
              isThreeLine: true,
            
            );
          },
        )
      ),
    );
  }
}