import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/new_todo_task.dart';
import 'package:todo_app/to_do_list_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, todoListProviderModal, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewToDoTaskPage()));
            },
            child: Icon(Icons.add),
          ),
          backgroundColor: Colors.white,
          body: ListView.builder(
            itemCount: todoListProviderModal.todo_list.length,
            itemBuilder: (context, index) {
              final item = todoListProviderModal.todo_list[index];
              return Dismissible(  // add swipe to delete option using Dismissible method
                key: Key(item["title"]),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  todoListProviderModal.deleteToDoTask(index);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item["title"]} deleted")),
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
                child: ListTile(
                  autofocus: true,
                  leading: Checkbox(
                    value: todoListProviderModal.todo_list[index]["isChecked"],
                    onChanged: (value) {
                      setState(() {
                        todoListProviderModal.todo_list[index]["isChecked"] =
                            value!;
                      });
                    },
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        todoListProviderModal.deleteToDoTask(index);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("${item["title"]} is deleted")));
                      },
                      icon: Icon(Icons.delete)),
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
                ),
              );
            },
          )),
    );
  }
}
