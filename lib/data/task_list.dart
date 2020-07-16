import 'package:riverpodexample/data/task.dart';
import 'package:state_notifier/state_notifier.dart';

class TaskList extends StateNotifier<List<Task>> {
  TaskList([List<Task> initialTask]) : super(initialTask ?? []);

  int get taskCount => state.length;

  void addTask(String title) {
    state = [...state, Task(title: title)];
  }

  void toggleDone(String id) {
    state = [
      for (final task in state)
        if (task.id == id)
          Task(id: task.id, title: task.title, isDone: !task.isDone)
        else
          task
    ];
  }

  void deleteTask(Task target) {
    state = state.where((task) => task.id != target.id).toList();
  }

  void updateTasks(List<Task> newTasks) {
    state = [for (final task in newTasks) task];
  }
}
