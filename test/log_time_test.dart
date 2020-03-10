@TestOn('dart-vm')

import 'package:log_time/log_time.dart';
import 'package:log_time/src/time_logger.dart';
import 'package:test/test.dart';

void main() {
  group('Test for TimeLogger enabled', () {
    TimeLogger timeLogger;

    setUp(() {
      timeLogger = TimeLogger('testing');
    });

    test('Expect LogTime to throw an error when not yet started', () {
      expect(() => timeLogger.end(), throwsA(TypeMatcher<UnsupportedError>()));
    });

    test('Expect initial status to be [LogTimeStatus.idle]', () {
      expect(timeLogger.status, equals(TimeLoggerStatus.idle));
    });

    test('LogTime started, expect status to be status is [LogTimeStatus.started]', () {
      timeLogger.start();
      expect(timeLogger.status, equals(TimeLoggerStatus.started));
    });

    test('LogTime ended, expect status to be [LogTimeStatus.ended]', () {
      timeLogger.start();
      timeLogger.end();
      expect(timeLogger.status, equals(TimeLoggerStatus.ended));
    });

  });

  group('Test for TimeLogger disabled', () {

    TimeLogger timeLogger;

    setUp(() {
      timeLogger = TimeLogger('testing', enabled: false);
    });

    test('TimeLogger started, expect status to be [LogTimeStatus.idle] when start is called.', () {
      timeLogger.start();
      expect(timeLogger.status, equals(TimeLoggerStatus.idle));
    });

    test('TimeLogger ended, expect stsatus to be [LogTimeStatus.idle]', () {
      timeLogger.start();
      timeLogger.end();
      expect(timeLogger.status, equals(TimeLoggerStatus.idle));
    });
  });

  group('Test for LogTime enabled', () {
    final logTimeId = 'test';

    setUp(() {
      LogTime.clear();
    });

    test('End a TimeLogger not existing id in LogTime, expect to throws an exception', () {
      expect(() => LogTime.end(logTimeId), throwsArgumentError);
    });

    test('Get status of not existing TimeLogger in LogTime, expect to throws an exception', () {
      expect(() => LogTime.getStatusById(logTimeId), throwsArgumentError);
    });

    test('Start a TimeLogger with an existing id in LogTime', () {
      LogTime.start(logTimeId);
      expect(() => LogTime.start(logTimeId), throwsArgumentError);
    });

    test('Start a TimeLogger using a valid id, expect status to be [LogTimmerStatus.started]', () {
      LogTime.start(logTimeId);
      expect(LogTime.getStatusById(logTimeId), equals(TimeLoggerStatus.started));
    });

    test('Start and end a TimeLogger using a valid id, expect status to be [LogTimmerStatus.ended]', () {
      LogTime.start(logTimeId);
      LogTime.end(logTimeId);
      expect(LogTime.getStatusById(logTimeId), equals(TimeLoggerStatus.ended));
    });

  });

  group('Test toggling LogTime enabled', () {

    test('Set LogTime.enabled to false, expect the enabled getting is false', () {
      LogTime.enabled = false;
      expect(LogTime.enabled, isFalse);
    });
  });

}
