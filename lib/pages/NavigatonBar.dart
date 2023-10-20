// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:to_do_list/controller/todoListController.dart';
import 'package:to_do_list/main.dart';

import 'package:to_do_list/pages/timerList.dart';
import 'package:to_do_list/utility/riverpod.dart';

class BottomNav extends ConsumerStatefulWidget {
  final int currentIndex;
  const BottomNav({
    required this.currentIndex,
  });

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> {
  int currentIndex = 0;
  @override
  void initState() {
    currentIndex = widget.currentIndex;
    Future<void> fetchList() async {
      final controller = Get.put(TodoController());
      List<Todo> todoLst = await controller.getTodoList();
      print('lst: $todoLst');
      for (int i = 0; i < todoLst.length; i++) {
        ref.read(todoProvider.notifier).changeData(todoLst[i]);
        Duration diff = todoLst[i].dateTime.difference(DateTime.now());
        ref
            .read(fullTimeProvider(todoLst[i].ind).notifier)
            .update((state) => diff.inSeconds);
        ref.read(timeProvider(todoLst[i].ind).notifier).start(diff.inSeconds);
      }
      print('provider list: ${ref.watch(todoProvider)}');
    }

    if (ref.read(todoProvider).isEmpty) {
      fetchList();
    }

    super.initState();
  }

  // int currentIndex;
  @override
  Widget build(BuildContext context) {
    // print(fullList);
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.square(55),
        child: MyAppBar(title: 'ToDo App'),
      ),
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
