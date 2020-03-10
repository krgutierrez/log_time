import 'package:log_time/src/time_logger.dart';

class LogTime {

  static bool _logEnabled = true;

  static set enabled(bool value) {
    _logEnabled = value;
  }

  static bool get enabled => _logEnabled;

  static final Map<String, TimeLogger> _mappedLoggers = {};

  LogTime._internal();

  static void clear() {
    _mappedLoggers.clear();
  }

  static void start(String id) {
    if (!_logEnabled) {
      return;
    }
    final logger = _mappedLoggers[id];
    if (_mappedLoggers.containsKey(id)) {
      throw ArgumentError('There is already a registerd TimeLogger with id $id. Please use a different id');
    }
    final timer = TimeLogger(id, enabled: _logEnabled);
    timer.start();
    _mappedLoggers[id] = timer;
  }

  static TimeLoggerStatus getStatusById(String id) {
    final logger = _mappedLoggers[id];
    if (logger ==  null) {
      throw ArgumentError('There is no registered TimeLogger with id $id');
    }
    return logger.status;
  }

  static int end(String id) {
    final timer = _mappedLoggers[id];
    if (timer == null) {
      throw ArgumentError('No TimeLogger found with id $id. Please call LogTime.start($id) first before calling LogTime.end($id)');
    }
    return timer.end();
  }

}
