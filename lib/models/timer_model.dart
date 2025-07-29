import 'package:flutter/material.dart';

enum TimerMode { timed, hit }

class TimerModel extends ChangeNotifier {
  TimerMode mode;
  String label;
  double elapsed;
  bool isRunning;
  late Stopwatch _stopwatch;
  Ticker? _ticker;

  TimerModel({
    required this.label,
    this.mode = TimerMode.timed,
    this.elapsed = 0,
  })  : isRunning = false,
        _stopwatch = Stopwatch();

  void start() {
    if (mode == TimerMode.timed && !isRunning) {
      _stopwatch.start();
      isRunning = true;
      _ticker = Ticker(_onTick)..start();
      notifyListeners();
    }
  }

  void pause() {
    if (mode == TimerMode.timed && isRunning) {
      _stopwatch.stop();
      isRunning = false;
      _ticker?.stop();
      notifyListeners();
    }
  }

  void reset() {
    _stopwatch.reset();
    elapsed = 0;
    isRunning = false;
    _ticker?.stop();
    notifyListeners();
  }

  void hit() {
    if (mode == TimerMode.hit) {
      elapsed += 1.5;
      notifyListeners();
    }
  }

  void setLabel(String newLabel) {
    label = newLabel;
    notifyListeners();
  }

  void setMode(TimerMode newMode) {
    if (mode != newMode) {
      reset(); // Reset using the current mode first
      mode = newMode;
      notifyListeners();
    }
  }

  void _onTick(Duration elapsedDuration) {
    if (mode == TimerMode.timed && isRunning) {
      elapsed = _stopwatch.elapsed.inMilliseconds / 1000.0;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    super.dispose();
  }
}

// Simple ticker for updating elapsed time
class Ticker {
  final void Function(Duration) onTick;
  late final Stopwatch _stopwatch;
  late final Duration _interval;
  bool _active = false;

  Ticker(this.onTick, [this._interval = const Duration(milliseconds: 100)]) {
    _stopwatch = Stopwatch();
  }

  void start() {
    _active = true;
    _stopwatch.start();
    _tick();
  }

  void stop() {
    _active = false;
    _stopwatch.stop();
  }

  void _tick() async {
    while (_active) {
      await Future.delayed(_interval);
      if (_active) {
        onTick(Duration(milliseconds: _stopwatch.elapsedMilliseconds));
      }
    }
  }

  void dispose() {
    stop();
  }
}
