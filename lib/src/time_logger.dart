enum TimeLoggerStatus {
  idle,
  started,
  ended,
}

class TimeLogger {
  final String id;
  int _logStartInMilliseconds;
  int _logEndInMilliseconds;
  TimeLoggerStatus _status;
  final bool enabled;

  TimeLogger(this.id, {this.enabled = true}) : _status = TimeLoggerStatus.idle;

  TimeLoggerStatus get status => _status;

  void start() {
    if (!enabled) {
      return;
    }
    _logStartInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    _status = TimeLoggerStatus.started;
  }

  int end() {
    if (!enabled) {
      return 0;
    }
    if (_status != TimeLoggerStatus.started) {
      throw UnsupportedError('Failed ending TimeLogger. Cannot call function [end] of TimeLogger since it is not yet started.');
    }
    _logEndInMilliseconds = DateTime.now().millisecondsSinceEpoch;
    final difference = _logEndInMilliseconds - _logStartInMilliseconds;
    _status = TimeLoggerStatus.ended;
    return difference;
  }
}
