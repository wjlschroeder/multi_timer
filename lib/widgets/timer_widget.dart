import 'package:flutter/material.dart';
import '../models/timer_model.dart';

class TimerWidget extends StatelessWidget {
  final TimerModel timer;
  final ValueChanged<TimerMode> onModeChanged;
  final ValueChanged<String> onLabelChanged;
  final VoidCallback onStartPause;
  final VoidCallback onReset;
  final VoidCallback onHit;

  const TimerWidget({
    super.key,
    required this.timer,
    required this.onModeChanged,
    required this.onLabelChanged,
    required this.onStartPause,
    required this.onReset,
    required this.onHit,
  });

  String _formatTime(double seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toStringAsFixed(1).padLeft(4, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: timer.label,
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: onLabelChanged,
            ),
          ),
          DropdownButton<TimerMode>(
            value: timer.mode,
            items: const [
              DropdownMenuItem(
                value: TimerMode.timed,
                child: Text('Timed'),
              ),
              DropdownMenuItem(
                value: TimerMode.hit,
                child: Text('Hit'),
              ),
            ],
            onChanged: (mode) {
              if (mode != null) {
                onModeChanged(mode);
              }
            },
          ),
        ],),

      subtitle: Text('Time: ${_formatTime(timer.elapsed)}'),
      trailing: timer.mode == TimerMode.timed
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
                  onPressed: onStartPause,
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: onReset,
                ),
              ],
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: onHit,
                  child: const Text('HIT'),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: onReset,
                ),
              ],
            ),
    );
  }
}