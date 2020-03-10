enum TimeLoggerStatus {
  idle,
  started,
  ended,
}

/// A class to track the length of an operation.
///
/// This will stores a millisecond when function [start] is called.
/// Calling function [end] will return the difference of the stored start milliseconds and the current milliseconds.
class TimeLogger {

  final String id;
  int _logStartInMilliseconds;
  int _logEndInMilliseconds;
  TimeLoggerStatus _status;
  final bool enabled;

  /// Initialize TimeLogger
  ///
  /// [id] The id of the TimeLogger. This is only use when [end] is called. The print will show '[id]: {milliseconds}
  /// [enabled] If time logging is enabled. If this is set to false, calling [start] will do nothing.
  TimeLogger(this.id, {this.enabled = true}) : _status = TimeLoggerStatus.idle;

  TimeLoggerStatus get status => _status;

  /// Start the [TimeLogger]. Calling this will store a milliseconds that will be used when function [end] is called.
  /// Calling this function when [enabled] is set to false will do nothing.
  /// This will throw an exception when [start] is called and [status] is [TimeLoggerStatus.started].
  void start() {
    if (!enabled) {
      return;
    }
    if (_status == TimeLoggerStatus.started) {
      throw UnsupportedError('Cannot start [TimeLogger] when it is already started. To be able to call [start] again, call[reset] first');
    }
    _logStartInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    _status = TimeLoggerStatus.started;
  }

  /// Resets the status of this [TimeLogger]
  void reset() {
    _logStartInMilliseconds = null;
    _status = TimeLoggerStatus.idle;
  }

  /// End the [TimeLogger]. This will return the difference between the current milliseconds and the stored start milliseconds.
  /// Calling [end] when status is not yet started will throw an exception.
  /// This will return 0 if [enabled] is set to false.
  ///
  /// [noPrint] prevents printing result. Usable when you have another print(s) for example, getting the average of time logs.
  int end({ bool noPrint = false }) {
    if (!enabled) {
      return 0;
    }
    if (_status != TimeLoggerStatus.started) {
      throw UnsupportedError('Failed ending TimeLogger. Cannot call function [end] of TimeLogger since it is not yet started.');
    }
    _logEndInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    final difference = _logEndInMilliseconds - _logStartInMilliseconds;
    _status = TimeLoggerStatus.ended;
    if (!noPrint) {
      print('$id: $difference');
    }
    return difference;
  }
}
