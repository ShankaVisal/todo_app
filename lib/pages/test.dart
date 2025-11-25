import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/new_todo_task_page.dart';
import 'package:todo_app/providers/to_do_list_provider.dart';

import '../components/detailed_task_card_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _openTaskDetailsSheet(BuildContext context, var task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: DetailedTaskCard(
            title: task.title,
            description: task.description ?? "No description",
            scheduledDate: task.scheduledDate,
            scheduleTime: task.scheduleTime,
            priority: task.priority ?? "Not set",
            createdAt: task.createdAt,
            isChecked: task.isChecked,
          ),
        );
      },
    );
  }

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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search tasks...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  Provider.of<TodoListProvider>(context, listen: false)
                      .setSearchQuery(value);
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: todoListProviderModal.tasks.length,
                itemBuilder: (context, index) {
                  final item = todoListProviderModal.tasks[index];
                  return Dismissible(
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
                      onTap: () {
                        _openTaskDetailsSheet(context, item);
                      },
                      leading: Checkbox(
                        value: item.isChecked,
                        onChanged: (value) {
                          todoListProviderModal.toggleComplete(item);
                        },
                      ),
                      trailing: IconButton(
                        onPressed: () {
                          todoListProviderModal.deleteTask(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${item.title} is deleted")),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                      title: Text(item.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.scheduledDate.toString().split(' ')[0]),
                              SizedBox(width: 4),
                              Text(item.scheduleTime),
                            ],
                          ),
                          Text(
                            item.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}