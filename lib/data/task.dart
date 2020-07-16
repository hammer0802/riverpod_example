import 'package:uuid/uuid.dart';

var _uuid = Uuid();

class Task {
  Task({
    this.title,
    this.isDone = false,
    String id,
  }) : id = id ?? _uuid.v4();

  final String id;
  final String title;
  final bool isDone;
}
