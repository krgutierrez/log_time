A library to track the length of an operation. This library is inspired by JavaScript's `console.log` and `console.time`.
This will be helpful if you want to check how long your functions takes. 

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

This example will call LogTime.start 10 times with unique ids and will end all of them after 5 seconds.  

```dart
import 'package:log_time/log_time.dart';

void main() {
  for (var x = 0; x < 10; x++) {
    LogTime.start('Logger-$x');
    Future.delayed(const Duration(seconds: 5), () {
      LogTime.end('Logger-$x');
      // Will print: Logger-1: {milliseconds} 
    });
  }
}
```

Results will be something like this:
```text
Logger-0: 5011
Logger-1: 5009
Logger-2: 5009
Logger-3: 5009
Logger-4: 5009
Logger-5: 5009
Logger-6: 5009
Logger-7: 5009
Logger-8: 5008
Logger-9: 5008
```

Another example will run 1,000,000 loops using `For Each` and `For Loop` then get the average durations.

In this example, you will see that an `Isolate` is used. This is to show the difference of the result between calling with and without `Isolate`.
This example also uses the parameter `` 
```dart
void forLoopIsolateEntryPoint(SendPort sendPort) async {
  await useForEach(1000000);
  sendPort.send('End');
}

void forEachIsolateEntryPoint(SendPort sendPort) async {
  await useForLoop(1000000);
  sendPort.send('End');
}

Future<void> runUseForLoopInIsolate() async {
  final receivePort = ReceivePort();
  await Isolate.spawn<SendPort>(forLoopIsolateEntryPoint, receivePort.sendPort);
  receivePort.listen((data) {
    receivePort.close();
  });
}

Future<void> runUseForEachInIsolate() async { 
  final receivePort = ReceivePort();
  await Isolate.spawn<SendPort>(forEachIsolateEntryPoint, receivePort.sendPort);
  receivePort.listen((data) {
    receivePort.close();
  });
}

Future<void> useForLoop(int length) async {
  final items = <int>[];
  final completer = Completer();
  for (var x = 1; x <= length; x++) {
    final id = 'For-Loop-$x';
    LogTime.start(id);
    Future.delayed(const Duration(seconds: 2), () {
      items.add(LogTime.end(id, noPrint: true));
      if (x == length) {
        completer.complete();
      }
    });
  }
  await completer.future;
  final total = items.fold<int>(0, (previousValue, length) {
    return previousValue += length;
  });
  print('For Loop Average: ${total / items.length}');
}

Future<void> useForEach(int length) async {
  final items = <int>[];
  final completer = Completer();
  final indexes = <int>[];
  for (var count = 1; count <= length; count ++) {
    indexes.add(count);
  }
  indexes.forEach((index) {
    final id = 'For-Each-$index';
    LogTime.start(id);
    Future.delayed(const Duration(seconds: 2), () {
      items.add(LogTime.end(id, noPrint: true));
      if (index == length) {
        completer.complete();
      }
    });
  });
  await completer.future;
  final total = items.fold<int>(0, (previousValue, length) {
    return previousValue += length;
  });
  print('ForEach Average: ${total / items.length}');
}

void main() async {
    print('Running for loop and for each without isolate');
    await Future.wait([
      useForLoop(1000000),
      useForEach(1000000),
    ]);
    print('Running for loop and for each with isolate');
    await Future.wait([
      runUseForLoopInIsolate(),
      runUseForEachInIsolate(),
    ]);
}
```

Result:
```text
Running for loop and for each without isolate
For Loop Average: 3015.630473
ForEach Average: 2105.882415
Running for loop and for each with isolate
For Loop Average: 2004.303154
ForEach Average: 2006.8629
```



## Features and bugs

Please file feature requests and bugs at the [issue tracker](https://github.com/krgutierrez/time_logger/issues). I will try my best to fix or implement them. :D 

[tracker]: https://github.com/krgutierrez/time_logger/issues