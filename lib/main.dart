import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const japan = 'Japan';
const america = 'America';

// familyを使ったprovider
// Providerにvalueを持たせられる
final titleProvider = Provider.family<String, String>((ref, country) {
  if (country == japan) {
    return 'こんにちは、日本';
  } else if (country == america) {
    return 'Hello America';
  } else {
    throw UnsupportedError('Unknown country $country');
  }
});

final countryProvider = StateProvider((ref) => japan);

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
              // 通常のProviderとは違い引数に値を入れる必要がある
              final country = read(countryProvider);
              final title = read(titleProvider(country.state));
              return Text(title);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => countryProvider.read(context).state = america,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
