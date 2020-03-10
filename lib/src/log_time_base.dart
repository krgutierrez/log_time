import 'package:log_time/src/time_logger.dart';

/// LogTime stores a [TimeLogger] when calling start. This handles storing multiple [TimeLogger] with unique ids.
class LogTime {

  static bool _logEnabled = true;

  static set enabled(bool value) {
    _logEnabled = value;
  }
  static bool get enabled => _logEnabled;

  static final Map<String, TimeLogger> _mappedLoggers = {};

  LogTime._internal();

  /// Create an instance of [TimeLogger] and return it. When calling this, the created [TimeLogger] is not stored in the map.
  static TimeLogger log(String id) {
    return TimeLogger(id, enabled: enabled);
  }

  /// Clear the stored [TimeLogger] in the map.
  static void clear() {
    _mappedLoggers.clear();
  }

  /// Starts a TimeLogger a register it in the mapped stored by this class.
  /// If a id passed is already existing, this will throw an error.
  /// [id] id to use when storing the created [TimeLogger] in the map.
  static void start(String id) {
    if (!_logEnabled) {
      return;
    }
    if (_mappedLoggers.containsKey(id)) {
      throw ArgumentError('There is already a registerd TimeLogger with id $id. Please use a different id');
    }
    final timer = TimeLogger(id, enabled: _logEnabled);
    timer.start();
    _mappedLoggers[id] = timer;
  }

  /// Get the current status. This will throw an error if no [TimerLogger] found.
  /// Returns a [TimeLoggerStatus]
  static TimeLoggerStatus getStatusById(String id) {
    final logger = _mappedLoggers[id];
    if (logger ==  null) {
      throw ArgumentError('There is no registered TimeLogger with id $id');
    }
    return logger.status;
  }

  /// End a [TimeLogger] with the specified id. This will throw an error if no [TimeLogger] found.
  /// [id] id of the [TimeLogger]
  /// Returns an [int] which is the difference of the marked start milliseconds and the current milliseconds.
  ///
  /// [noPrint] prevents printing result. Usable when you have another print(s) for example, getting the average of time logs.
  static int end(String id, { bool noPrint = false }) {
    final timer = _mappedLoggers[id];
    if (timer == null) {
      throw ArgumentError('No TimeLogger found with id $id. Please call LogTime.start($id) first before calling LogTime.end($id)');
    }
    return timer.end(noPrint: noPrint);
  }

}
