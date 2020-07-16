import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpodexample/data/task.dart';
import 'package:riverpodexample/widget/task_tile.dart';

final taskListProvider =
    StateNotifierProvider((ref) => TaskList([Task(title: 'play tennis')]));

final Computed isNotDoneTasksCount = Computed((read) {
  return read(taskListProvider.state).where((task) => !task.isDone).length;
});

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String _newTaskTitle = '';
    final _textEditingController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        body: Consumer(
          (context, read) {
            final taskList = read(taskListProvider);
            final tasks = read(taskListProvider.state);
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'ToDo List',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          child: TextField(
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              hintText: "Enter a todo title",
                              suffixIcon: IconButton(
                                onPressed: () => _textEditingController.clear(),
                                icon: Icon(Icons.clear),
                              ),
                            ),
                            textAlign: TextAlign.start,
                            onChanged: (newText) {
                              _newTaskTitle = newText;
                            },
                            onSubmitted: (newText) {
                              if (_newTaskTitle.isEmpty) {
                                _newTaskTitle = 'No Title';
                              }
                              taskList.addTask(_newTaskTitle);
                              _textEditingController.clear();
                              _newTaskTitle = '';
                            },
                          ),
                        ),
                        Text('${read(isNotDoneTasksCount)} tasks left'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return TaskTile(
                          taskTitle: task.title,
                          isChecked: task.isDone,
                          checkboxCallback: (bool value) {
                            taskList.toggleDone(task.id);
                          },
                          longPressCallback: () {
                            final scaffoldState = Scaffold.of(context);
                            final previousTasks = tasks;

                            scaffoldState.removeCurrentSnackBar();
                            taskList.deleteTask(task);
                            final snackBar = SnackBar(
                              content: Text('${task.title} has been deleted'),
                              action: SnackBarAction(
                                label: 'restore',
                                onPressed: () {
                                  taskList.updateTasks(previousTasks);
                                  scaffoldState.removeCurrentSnackBar();
                                },
                              ),
                              duration: Duration(seconds: 3),
                            );
                            scaffoldState.showSnackBar(snackBar);
                          },
                        );
                      },
                      itemCount: taskList.taskCount,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
