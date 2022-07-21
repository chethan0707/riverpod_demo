import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StreamProvider.family<int, int>((ref, start) {
  final wsClient = ref.watch(websocketClientProvider);
  return wsClient.getCounterStream(start);
});

final websocketClientProvider = Provider<WebSocketClient>(
  (ref) {
    return FakeWebSocketClient();
  },
);

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
    final AsyncValue<int> counter = ref.watch(counterProvider(5));
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         ref.invalidate(counterProvider);
        //       },
        //       icon: const Icon(Icons.refresh))
        // ],
      ),
      body: Center(
        child: Text(
          counter.when(
              data: (int value) => value.toString(),
              error: (Object e, _) => e.toString(),
              loading: () => 0.toString()),
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
    );
  }
}

// abstract class WebSocketClient {
//   Stream<int> getCounterStream();
// }

// class FakeWebSocketClient implements WebSocketClient {
//   @override
//   Stream<int> getCounterStream() async* {
//     int i = 0;
//     while (true) {
//       await Future.delayed(const Duration(milliseconds: 500));
//       yield i++;
//     }
//   }
// }

abstract class WebSocketClient {
  Stream<int> getCounterStream([int start]);
}

class FakeWebSocketClient implements WebSocketClient {
  @override
  Stream<int> getCounterStream([int start = 0]) async* {
    int i = start;
    while (true) {
      yield i++;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }
}
