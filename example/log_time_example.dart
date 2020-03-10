import 'dart:async';
import 'dart:isolate';

import 'package:log_time/log_time.dart';

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