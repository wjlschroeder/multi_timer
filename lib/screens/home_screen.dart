import 'package:flutter/material.dart';
import '../models/timer_model.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<TimerModel> timers = [
    TimerModel(label: 'Timer 1'),
  ];

  // Add a map to keep track of hit counts for each timer
  final Map<TimerModel, int> hitCounts = {};

  final TextEditingController timerNameController = TextEditingController();

  double get totalTime =>
      timers.fold(0.0, (sum, timer) => sum + timer.elapsed);

  void addTimer() {
    setState(() {
      final newTimer = TimerModel(label: 'Timer ${timers.length + 1}');
      timers.add(newTimer);
      hitCounts[newTimer] = 0;
    });
  }

void sendEmailWithTimerData() {
    final buffer = StringBuffer();
    buffer.writeln('Total Time: ${_formatTime(totalTime)}\n');

    for (var timer in timers) {
      buffer.writeln('${timer.label}: ${_formatTime(timer.elapsed)}');
      if (timer.mode == TimerMode.hit) {
        buffer.writeln('Hit Count: ${hitCounts[timer] ?? 0}');
      }
      buffer.writeln('');
    }

    final timerName = timerNameController.text.trim().isEmpty
        ? 'Unnamed'
        : timerNameController.text.trim();

    final subject = Uri.encodeComponent('$timerName Timer Summary');
    final body = Uri.encodeComponent(buffer.toString());
    final uri = Uri.parse('mailto:?subject=$subject&body=$body');

    launchUrl(uri);
  }


  Widget buildTimerTile(TimerModel timer) {
  hitCounts.putIfAbsent(timer, () => 0);

  return Container(
    color: const Color.fromARGB(255, 255, 255, 255),
    padding: const EdgeInsets.all(8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left-side buttons: Reset and Delete
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Reset Timer',
              onPressed: () {
                setState(() {
                  timer.reset();
                  if (timer.mode == TimerMode.hit) {
                    hitCounts[timer] = 0;
                  }
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Timer',
              onPressed: () {
                setState(() {
                  hitCounts.remove(timer);
                  timers.remove(timer);
                });
              },
            ),
          ],
        ),
        const SizedBox(width: 16),

        // Timer content and control button in separate columns
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Timer text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: timer.label,
                      decoration: const InputDecoration(border: InputBorder.none),
                      onChanged: timer.setLabel,
                    ),
                    DropdownButton<TimerMode>(
                      value: timer.mode,
                      items: const [
                        DropdownMenuItem(value: TimerMode.timed, child: Text('Timed')),
                        DropdownMenuItem(value: TimerMode.hit, child: Text('Hit')),
                      ],
                      onChanged: (mode) {
                        setState(() {
                          timer.setMode(mode!);
                          hitCounts[timer] = 0;
                        });
                      },
                    ),
                    const SizedBox(height: 4),
                    Text('Time: ${_formatTime(timer.elapsed)}'),
                    if (timer.mode == TimerMode.hit)
                      Text('Hit Count: ${hitCounts[timer]}'),
                  ],
                ),
              ),

              // Control button column
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  timer.mode == TimerMode.timed
                      ? IconButton(
                          icon: Icon(timer.isRunning ? Icons.pause : Icons.play_arrow),
                          iconSize: 36.0,
                          onPressed: () {
                            setState(() {
                              timer.isRunning ? timer.pause() : timer.start();
                            });
                          },
                        )
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 115, 47, 47),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 4,
                          ),
                          child: const Text(
                            'HIT',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              timer.hit();
                              hitCounts[timer] = (hitCounts[timer] ?? 0) + 1;
                            });
                          },
                        ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}


  String _formatTime(double seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toStringAsFixed(1).padLeft(4, '0');
    return '$mins:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color.fromARGB(255, 115, 47, 47),
      title: const Text('ASTM F2781 Multi Timer',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      ),
      ),
      
      body: Column(
        children: [
 Container(
  color: const Color.fromARGB(255, 255, 255, 255),
  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  child: Row(
    children: [
      const Text(
        'Timer Name:',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: TextField(
          controller: timerNameController,
          decoration: const InputDecoration(
            hintText: 'Enter a name for this timer session',
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ),
    ],
  ),
),

          Expanded(
            child: ListView.builder(
              itemCount: timers.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: timers[index],
                  builder: (context, _) => Padding(padding: const EdgeInsets.all(8.0),
                  child:buildTimerTile(timers[index]),
                ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: AnimatedBuilder(
              animation: Listenable.merge(timers),
              builder: (context, _) => Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                children: [
                  const Text(
                    'Total Time:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(totalTime),
                    style: const TextStyle(fontSize: 16),
                  ),
                  const Spacer(),
                 IconButton(
                  icon: const Icon(Icons.mail),
                  tooltip: 'Email Timer Data',
                  onPressed: sendEmailWithTimerData,
                  ),

                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add Timer'),
                    onPressed: addTimer,
                  ),
                ],
              ),
            ),
          ),
      ),
      ],
      ),
    );
  }
}