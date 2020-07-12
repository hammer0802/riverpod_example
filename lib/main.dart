import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// グローバル変数でProviderを宣言
final firstNameProvider = StateProvider((ref) => 'Mona');
final lastNameProvider = StateProvider((ref) => 'Lisa');

// Computedを使ってイニシャルを返すproviderを宣言
// 例えばfirstNameがMariaに変更され、firstNameが変わるがinitialsが変わらない場合、
// Computedを使うことでinitialsを使うWidgetはrebuildされない(buildの最適化)
final Computed initialsProvider = Computed((read) {
  final firstName = read(firstNameProvider).state;
  final lastName = read(lastNameProvider).state;

  return '${firstName[0]}${lastName[0]}';
});

void main() {
  runApp(
    // Providerを読むためにはアプリケーション全体をProviderScopeでwrapする
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('Computed Example')),
        body: Center(
          // Providerを使うにはConsumerを使う
          child: Consumer(
            (context, read) {
              final initials = read(initialsProvider);
              return Text(initials);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // initialsの状態は変更ないため、ConsumerのTextはrebuildされない
          onPressed: () => firstNameProvider.read(context).state = 'Maria',
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
