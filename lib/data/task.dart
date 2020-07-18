import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'task.freezed.dart';

@freezed
abstract class Task with _$Task {
  const factory Task({
    String title,
    @Default(false) bool isDone,
    String id,
  }) = _Task;
}
