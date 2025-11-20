import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/new_todo_task_page.dart';
import 'package:todo_app/providers/to_do_list_provider.dart';

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
            itemCount: todoListProviderModal.tasks.length,
            itemBuilder: (context, index) {
              final item = todoListProviderModal.tasks[index];
              return Dismissible(  // add swipe to delete option using Dismissible method
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  todoListProviderModal.deleteTask(item.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item.title} deleted")),
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
                    value: todoListProviderModal.tasks[index].isChecked,
                    onChanged: (value) {
                      setState(() {
                        // todoListProviderModal.tasks[index].isChecked =
                        //     value!;
                        todoListProviderModal.toggleComplete(item);
                      });
                    },
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        todoListProviderModal.deleteTask(item.id);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("${item.title} is deleted")));
                      },
                      icon: Icon(Icons.delete)),
                  title: Text(todoListProviderModal.tasks[index].title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todoListProviderModal.tasks[index].description),
                      Text(todoListProviderModal.tasks[index].scheduledDate.toString()),
                      Text(todoListProviderModal.tasks[index].createdAt),
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
