import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// 2つのテスト間でstateが0にリセットされているかをテストするためグローバルで宣言
final counterProvider = StateProvider((ref) => 0);

// 現在のstateとstateの値を増加するボタンを描画する
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer((context, read) {
        final counter = read(counterProvider);
        return RaisedButton(
          onPressed: () => counter.state++,
          child: Text('${counter.state}'),
        );
      }),
    );
  }
}

void main() {
  testWidgets('stateを増加させた時にUIを更新する', (tester) async {
    // MyAppをbuildしてUIを描画する
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // デフォルト値はProviderで宣言した0が入る
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // stateを増加させて再描画
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();

    // stateは1に変化して表示されている
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });

  testWidgets('カウンターのstateはtest間で共有されない', (tester) async {
    await tester.pumpWidget(ProviderScope(child: MyApp()));

    // tearDown/setUpの必要なしにstateは0になっている
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);
  });
}
