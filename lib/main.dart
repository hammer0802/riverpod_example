import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodexample/data/task.dart';
import 'package:riverpodexample/widget/task_tile.dart';

final taskListProvider =
    StateNotifierProvider((ref) => TaskList([Task(title: 'aaaa')]));

final Computed isNotDoneTasksCount = Computed((read) {
  return read(taskListProvider.state).where((task) => !task.isDone).length;
});

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
    String _newTaskTitle = '';
    final textEditingController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'ToDo List',
                    style: TextStyle(
                      color: Colors.deepPurpleAccent,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ),
                    child: Consumer((context, read) {
                      final taskList = read(taskListProvider);
                      return TextField(
                        controller: textEditingController,
                        textAlign: TextAlign.start,
                        onChanged: (newText) {
                          _newTaskTitle = newText;
                        },
                        onSubmitted: (newText) {
                          if (_newTaskTitle.isEmpty) {
                            _newTaskTitle = 'No Title';
                          }
                          taskList.addTask(_newTaskTitle);
                          _newTaskTitle = '';
                          textEditingController.clear();
                        },
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer(
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
          ],
        ),
      ),
    );
  }
}
