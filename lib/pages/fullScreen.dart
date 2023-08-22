import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/riverpod.dart';

class FullScreen extends StatelessWidget {
  int index;
  int ind;
  FullScreen({
    Key? key,
    required this.index,
    required this.ind,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('Full Build');
    final screenHeight = MediaQuery.of(context).size.height;
    double progress = 0.0;

    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        return OrientationBuilder(
          builder: (context, orientation) {
            final int fullTime = ref.watch(fullTimeProvider(ind));
            // if (MediaQuery.of(context).orientation == Orientation.portrait) {
            //   SystemChrome.setPreferredOrientations([
            //     DeviceOrientation.landscapeLeft,
            //     DeviceOrientation.landscapeRight,
            //   ]);
            // }
            return Stack(
              fit: StackFit.expand,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  // color: Colors.red,
                  child: LinearProgressIndicator(
                    minHeight: screenHeight,
                    // value: progress,
                    value: ref.watch(timeProvider(ind)).when(
                          data: (countdownValue) {
                            // if (countdownValue <= 0) {
                            //   ref
                            //       .read(todoProvider.notifier)
                            //       .updateTodoStatus(index, true);
                            // }

                            if (countdownValue * fullTime > 0.99999) {
                              progress = countdownValue;
                              return progress;
                            } else {
                              return 0;
                            }
                          },
                          loading: () => 0,
                          error: (error, stackTrace) => 0,
                        ),
                    valueColor: progress > 0.2
                        ? const AlwaysStoppedAnimation<Color>(Colors.green)
                        : const AlwaysStoppedAnimation(
                            Color.fromRGBO(244, 67, 54, 1)),
                    backgroundColor: Colors.black.withOpacity(0.4),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: ref.watch(timeProvider(ind)).when(
                            data: (countdownValue) {
                              if (countdownValue * fullTime < 0.9999) {
                                print('time zero');
                                Future.delayed(const Duration(milliseconds: 10),
                                    () {
                                  Navigator.pop(context);
                                  // ref
                                  //     .read(todoProvider.notifier)
                                  //     .updateTodoStatus(index, true);
                                });
                              }
                              // print(countdownValue * fullTime);
                              return CountdownDisplay(
                                  countdownValue * fullTime);
                            },
                            loading: () => const Text('Loading...'),
                            error: (error, stackTrace) => Text('Error: $error'),
                          ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Exit'),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      }),
    );
  }
}

String formatDuration(double seconds) {
  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = (seconds % 60) ~/ 1;

  return '$hours:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
}

class CountdownDisplay extends StatelessWidget {
  final double countdownValue;

  CountdownDisplay(this.countdownValue);

  @override
  Widget build(BuildContext context) {
    final formattedDuration = formatDuration(countdownValue);
    return Text(
      formattedDuration,
      style: const TextStyle(fontSize: 104, color: Colors.white),
    );
  }
}
