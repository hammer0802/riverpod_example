import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodexample/task.dart';
import 'package:riverpodexample/widget/task_tile.dart';

final taskListProvider =
    StateNotifierProvider((ref) => TaskList([Task(title: 'aaaa')]));

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Riverpod ToDo')),
        body: Consumer(
          (context, read) {
            final taskList = read(taskListProvider);
            final tasks = read(taskListProvider.state);
            return ListView.builder(
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskTile(
                  taskTitle: task.title,
                  isChecked: task.isDone,
                  checkboxCallback: (bool value) {
                    taskList.toggleDone(task.id);
                  },
                  longPressCallback: () {
                    taskList.deleteTask(task);
                  },
                );
              },
              itemCount: taskList.taskCount,
            );
          },
        ),
      ),
    );
  }
}
