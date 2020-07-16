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

    void clearTextField() {
      _textEditingController.clear();
      _newTaskTitle = '';
    }

    void showSnackBar({
      List<Task> previousTasks,
      TaskList taskList,
      String content,
      ScaffoldState scaffoldState,
    }) {
      scaffoldState.removeCurrentSnackBar();
      final snackBar = SnackBar(
        content: Text(content),
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
    }

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
                                onPressed: () {
                                  clearTextField();
                                },
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
                              clearTextField();
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('${read(isNotDoneTasksCount)} tasks left'),
                            FlatButton(
                              child: Text('Delete All'),
                              onPressed: () {
                                taskList.deleteAllTasks();
                                showSnackBar(
                                  previousTasks: tasks,
                                  taskList: taskList,
                                  content: 'All tasks have been deleted.',
                                  scaffoldState: Scaffold.of(context),
                                );
                              },
                            ),
                          ],
                        ),
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
                            taskList.deleteTask(task);
                            showSnackBar(
                              previousTasks: tasks,
                              taskList: taskList,
                              content: '${task.title} has been deleted.',
                              scaffoldState: Scaffold.of(context),
                            );
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
