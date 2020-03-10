import 'dart:async';

import 'package:log_time/log_time.dart';
import 'package:log_time/src/time_logger.dart';

void main() {
  final logger = TimeLogger('test');
  for (var x = 0; x < 10; x++) {
    LogTime.start('Logger-$x');
    Future.delayed(const Duration(seconds: 5), () {
      LogTime.end('Logger-$x');
    });
  }
}
