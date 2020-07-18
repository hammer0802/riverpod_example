import 'package:riverpodexample/data/task.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class TaskList extends StateNotifier<List<Task>> {
  TaskList([List<Task> initialTask]) : super(initialTask ?? []);

  int get taskCount => state.length;

  void addTask(String title) {
    state = [...state, Task(title: title, id: _uuid.v4())];
  }

  void toggleDone(String id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isDone: !task.isDone) else task
    ];
  }

  void deleteTask(Task target) {
    state = state.where((task) => task.id != target.id).toList();
  }

  void deleteAllTasks() {
    state = [];
  }

  void deleteDoneTasks() {
    state = state.where((task) => !task.isDone).toList();
  }

  void updateTasks(List<Task> newTasks) {
    state = [for (final task in newTasks) task];
  }
}
