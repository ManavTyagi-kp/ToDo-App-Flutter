import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/pages/timerList.dart';
import 'package:to_do_list/utility/riverpod.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({super.key});

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final fullList = ref.watch(todoProvider);
    final completedList = ref.watch(tasksDone);
    final onGoingList = ref.watch(tasksDoing);
    // print(fullList);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentIndex = index;
          });
        },
        indicatorColor: Colors.amberAccent,
        selectedIndex: currentIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_box),
            label: 'Completed',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_box_outline_blank),
            label: 'OnGoing',
          ),
        ],
      ),
      body: [
        ListViewerTimer(
          type: 'home',
        ),
        ListViewerTimer(
          type: 'completed',
        ),
        ListViewerTimer(
          type: 'ongoing',
        ),
        // onGoingList.isNull
        //     ? ListViewerTimer(
        //         todoList: onGoingList,
        //       )
        //     : ListViewerTimer(todoList: const [])
      ][currentIndex],
    );
  }
}
