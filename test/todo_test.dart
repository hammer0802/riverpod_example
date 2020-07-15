import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class Repository {
  Future<List<Todo>> fetchTodos() async {}
}

class Todo {
  Todo({this.id, this.label, this.completed});

  final String id;
  final String label;
  final bool completed;
}

// RepositoryProviderのインスタンスを生成
final repositoryProvider = Provider((ref) => Repository());

/// ToDoリスト、ここではRepositoryを使ってサーバーからToDoをfetchするだけ
final FutureProvider todoListProvider = FutureProvider((ref) async {
  // Repositoryのインスタンスを取得
  final repository = ref.read(repositoryProvider);

  // ToDoをfetchしてUIに表示
  return repository.fetchTodos();
});

/// 予め定義したToDoリストを返すRepositoryのモックを実装
class FakeRepository implements Repository {
  @override
  Future<List<Todo>> fetchTodos() async {
    return [
      Todo(id: '42', label: 'Hello world', completed: false),
    ];
  }
}

class TodoItem extends StatelessWidget {
  const TodoItem({Key key, this.todo}) : super(key: key);
  final Todo todo;
  @override
  Widget build(BuildContext context) {
    return Text(todo.label);
  }
}

void main() {
  testWidgets('repositoryProviderをオーバーライドする', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          repositoryProvider.overrideAs(Provider((ref) => FakeRepository()))
        ],
        // todoListProviderからToDoリストを読んで表示する
        // 以下はMyAppウィジェットに抽出しても良い
        child: MaterialApp(
          home: Scaffold(
            body: Consumer((context, read) {
              final todos = read(todoListProvider);
              // ToDoのローディング、取得できなければエラー
              if (todos.data == null) {
                return const CircularProgressIndicator();
              }
              return ListView(
                children: [
                  for (final todo in todos.data.value) TodoItem(todo: todo)
                ],
              );
            }),
          ),
        ),
      ),
    );

    // 最初に表示するframeはローディング.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // 再描画までにTodoListProviderはToDoリストのfetchを終了している必要がある
    await tester.pump();

    // ローディングは終了
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // FakeRepositoryから返されたデータを含むTodoItemを描画
    expect(tester.widgetList(find.byType(TodoItem)), [
      isA<TodoItem>()
          .having((s) => s.todo.id, 'todo.id', '42')
          .having((s) => s.todo.label, 'todo.label', 'Hello world')
          .having((s) => s.todo.completed, 'todo.completed', false),
    ]);
  });
}
