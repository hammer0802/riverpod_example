import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final helloWorldProvider = Provider((_) => 'Hello World!');

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
        appBar: AppBar(title: Text('Riverpod Example')),
        body: Center(
          // Providerを使うにはConsumerを使う
          child: Consumer((context, read) {
            // helloWorldProviderを読む
            final value = read(helloWorldProvider);
            return Text(value);
          }),
        ),
      ),
    );
  }
}
