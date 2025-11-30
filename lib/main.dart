import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/pages/homapage.dart';
import 'package:todo_app/providers/to_do_list_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasks');

  // Initialize provider
  final todoListProvider = TodoListProvider();
  await todoListProvider.init();

  runApp(MyApp(todoListProvider: todoListProvider));
}

class MyApp extends StatelessWidget {
  final TodoListProvider todoListProvider;

  const MyApp({super.key, required this.todoListProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: todoListProvider),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doneo',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ModernHomePage(),
      ),
    );
  }
}
