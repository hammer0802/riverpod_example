import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// グローバル変数でProviderを宣言
final counterProvider = StateProvider((_) => 0);

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
        appBar: AppBar(title: Text('Counter Example')),
        body: Center(
          // Providerを使うにはConsumerを使う
          // hooks_riverpodのみuseProviderも使える
          child: Consumer(
            (context, read) {
              // helloWorldProviderを読む
              final count = read(counterProvider).state;
              return Text('$count');
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // read(context)を使うことで値が変更されてもFABがrebuildされない
          onPressed: () => counterProvider.read(context).state++,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
