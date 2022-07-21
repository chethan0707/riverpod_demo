import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider((ref) => 1);

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Counter App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: Colors.green,
          surface: const Color(0xff003909),
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to Counter Page'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: ((context) => const CounterPage()),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CounterPage extends ConsumerWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int counter = ref.watch(counterProvider);
    ref.listen<int>(
      counterProvider,
      ((previous, next) => {
            if (next >= 5)
              {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: const Text("Counter High!!!"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Ok'))
                      ],
                    );
                  },
                )
              }
          }),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
        actions: [
          IconButton(
              onPressed: () {
                ref.invalidate(counterProvider);
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      body: Center(
        child: Text(
          counter.toString(),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          ref.read(counterProvider.notifier).state++;
        },
      ),
    );
  }
}

abstract class WebSocketClient {
  Stream<int> getCounterStream();
}

class FakeWebSocketClient implements WebSocketClient {
  @override
  Stream<int> getCounterStream() async* {
    int i = 0;
    while (true) {
      await Future.delayed(const Duration(microseconds: 500));
      yield i++;
    }
  }
}
