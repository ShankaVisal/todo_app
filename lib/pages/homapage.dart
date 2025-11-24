// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_app/pages/new_todo_task_page.dart';
// import 'package:todo_app/providers/to_do_list_provider.dart';

// import '../components/detailed_task_card_model.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   void _openTaskDetailsSheet(BuildContext context, var task) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: DetailedTaskCard(
//             title: task.title,
//             description: task.description ?? "No description",
//             scheduledDate: task.scheduledDate,
//             scheduleTime: task.scheduleTime,
//             priority: task.priority ?? "Not set",
//             createdAt: task.createdAt,
//             isChecked: task.isChecked,
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TodoListProvider>(
//       builder: (context, todoListProviderModal, child) => Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             Navigator.push(context,
//                 MaterialPageRoute(builder: (context) => NewToDoTaskPage()));
//           },
//           child: Icon(Icons.add),
//         ),
//         backgroundColor: Colors.white,
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: TextField(
//                 decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.search),
//                   hintText: "Search tasks...",
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   Provider.of<TodoListProvider>(context, listen: false)
//                       .setSearchQuery(value);
//                 },
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: todoListProviderModal.tasks.length,
//                 itemBuilder: (context, index) {
//                   final item = todoListProviderModal.tasks[index];
//                   return Dismissible(
//                     key: Key(item.id),
//                     direction: DismissDirection.endToStart,
//                     onDismissed: (direction) {
//                       todoListProviderModal.deleteTask(item.id);

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("${item.title} deleted")),
//                       );
//                     },
//                     background: Container(
//                       color: Colors.red,
//                       alignment: Alignment.centerRight,
//                       padding: EdgeInsets.only(right: 20),
//                       child: Icon(
//                         Icons.delete,
//                         color: Colors.white,
//                       ),
//                     ),
//                     child: ListTile(
//                       onTap: () {
//                         _openTaskDetailsSheet(context, item);
//                       },
//                       leading: Checkbox(
//                         value: item.isChecked,
//                         onChanged: (value) {
//                           todoListProviderModal.toggleComplete(item);
//                         },
//                       ),
//                       trailing: IconButton(
//                         onPressed: () {
//                           todoListProviderModal.deleteTask(item.id);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text("${item.title} is deleted")),
//                           );
//                         },
//                         icon: Icon(Icons.delete),
//                       ),
//                       title: Text(item.title),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(item.scheduledDate.toString().split(' ')[0]),
//                               SizedBox(width: 4),
//                               Text(item.scheduleTime),
//                             ],
//                           ),
//                           Text(
//                             item.description,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/to_do_list_provider.dart';
import 'package:todo_app/pages/new_todo_task_page.dart';

class ModernHomePage extends StatelessWidget {
  const ModernHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, todoProvider, child) => Scaffold(
        backgroundColor: const Color(0xFFF4F6FA),

        floatingActionButton: Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.blueAccent.withOpacity(0.7),
                Colors.purpleAccent.withOpacity(0.7),
                Colors.greenAccent.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NewToDoTaskPage()));
            },
            child: const Icon(Icons.add, size: 32),
          ),
        ),

        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  "My Tasks",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: "Search tasks...",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      Provider.of<TodoListProvider>(context, listen: false)
                          .setSearchQuery(value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Task List
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: todoProvider.tasks.length,
                  itemBuilder: (context, index) {
                    final task = todoProvider.tasks[index];

                    return _buildTaskCard(task, context, todoProvider);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(task, BuildContext context, TodoListProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.white.withOpacity(0.6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Priority
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                task.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              _priorityChip(task.priority),
            ],
          ),

          const SizedBox(height: 6),

          // Description
          Text(
            task.description,
            style: TextStyle(color: Colors.black54),
          ),

          const SizedBox(height: 10),

          // Schedule
          Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Colors.grey),
              SizedBox(width: 4),
              Text(
                "${task.scheduledDate.toString().split(' ')[0]}, ${task.scheduleTime}",
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Priority badge UI
  Widget _priorityChip(String priority) {
    Color color;

    switch (priority.toLowerCase()) {
      case "high":
        color = Colors.redAccent;
        break;
      case "medium":
        color = Colors.orangeAccent;
        break;
      case "low":
        color = Colors.blueAccent;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        priority,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
