import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/to_do_list_provider.dart';
import 'package:todo_app/pages/new_todo_task_page.dart';

class ModernHomePage extends StatelessWidget {
  const ModernHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TodoListProvider>(
      builder: (context, todoProvider, child) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          floatingActionButton: glassFAB(() {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NewToDoTaskPage()));
          }),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D0D0D),
                  Color(0xFF1A1A1A),
                  Color(0xFF0F0F0F),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SafeArea(
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

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.20),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.white70),
                              hintText: "Search tasks...",
                              hintStyle: TextStyle(color: Colors.white60),
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              Provider.of<TodoListProvider>(context,
                                      listen: false)
                                  .setSearchQuery(value);
                            },
                          ),
                        ),
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
      },
    );
  }

  Widget _buildTaskCard(
      task, BuildContext context, TodoListProvider taskProvider) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Dismissible(
        key: Key(task.id),
        onDismissed: (direction) {
          taskProvider.deleteTask(task.id);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("${task.title} deleted")),
          );
        },
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.red,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: Colors.white.withOpacity(0.12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  splashColor: Colors.white.withOpacity(0.1),
                  highlightColor: Colors.white.withOpacity(0.05),
                  onTap: () {
                    _openTaskDetailsSheet(context, task);
                  },
                  onDoubleTap: () {
                    taskProvider.toggleComplete(task);
                  },
                  onLongPress: () => {
                    taskProvider.deleteTask(task.id),
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${task.title} is deleted")),
                    ),
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Checkbox
                        Checkbox(
                          value: task.isChecked,
                          onChanged: (_) {
                            taskProvider.toggleComplete(task);
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          side: BorderSide(color: Colors.white70),
                          checkColor: Colors.black,
                          activeColor: Colors.white,
                        ),

                        const SizedBox(width: 8),

                        // Title + Priority
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  decoration: task.isChecked
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: _priorityColor(task.priority)
                                      .withOpacity(0.35),
                                ),
                                child: Text(
                                  task.priority.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        // Arrow Icon
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: Colors.white70, size: 18),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
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

Color _priorityColor(String priority) {
  switch (priority.toLowerCase()) {
    case 'high':
      return Colors.redAccent;
    case 'medium':
      return Colors.orangeAccent;
    default:
      return Colors.blueAccent;
  }
}

Widget glassSearchBar(
    TextEditingController controller, Function(String) onSearch) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 5),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
            ),
          ),
          child: TextField(
            controller: controller,
            style: TextStyle(color: Colors.white),
            onChanged: onSearch,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white70),
              hintText: "Search tasks...",
              hintStyle: TextStyle(color: Colors.white54),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget glassFAB(VoidCallback onPressed) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(50),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: Colors.white.withOpacity(0.15),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1.2,
          ),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    ),
  );
}

Future _openTaskDetailsSheet(BuildContext context, var task) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.35,
        maxChildSize: 0.90,
        builder: (_, controller) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.2,
                  ),
                ),
                child: ListView(
                  controller: controller,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        margin: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    Text(
                      task.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      task.description,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 20),
                    _bottomSheetInfo("Priority", task.priority),
                    _bottomSheetInfo(
                        "Date", task.scheduledDate.toString().split(" ").first),
                    _bottomSheetInfo("Time", task.scheduleTime),
                    _bottomSheetInfo(
                        "Created", task.createdAt.toString().split('.')[0]),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            final todoProvider = Provider.of<TodoListProvider>(
                                context,
                                listen: false);
                            todoProvider.deleteTask(task.id);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("${task.title} deleted")),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent.withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "Delete Task",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    NewToDoTaskPage(task: task),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 82, 128, 255)
                                    .withOpacity(0.7),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            "Update Task",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _bottomSheetInfo(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white70, fontSize: 16)),
        Text(value, style: TextStyle(color: Colors.white, fontSize: 16)),
      ],
    ),
  );
}
