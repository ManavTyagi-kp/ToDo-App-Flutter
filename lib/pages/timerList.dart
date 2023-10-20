// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:to_do_list/Repository/todoRepo.dart';
import 'package:to_do_list/card/ListCard.dart';
import 'package:to_do_list/controller/todoListController.dart';

import '../utility/riverpod.dart';
import 'fullScreen.dart';

final validateStateProvider = StateProvider<bool>((ref) {
  return false;
});

class ListViewerTimer extends ConsumerStatefulWidget {
  String type;

  ListViewerTimer({
    super.key,
    required this.type,
  });

  @override
  ConsumerState<ListViewerTimer> createState() => _ListViewerTimerState();
}

class _ListViewerTimerState extends ConsumerState<ListViewerTimer> {
  String generateRandomString(int length) {
    const String charset =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final Random random = Random();
    return String.fromCharCodes(Iterable.generate(
      length,
      (_) => charset.codeUnitAt(random.nextInt(charset.length)),
    ));
  }

  String? desc;

  var todoList = [];

  final todoRepo = Get.put(TodoRepo());

  void changeStatus(WidgetRef ref, Todo todo) {
    todoRepo.addTodo(todo);
    ref.read(todoProvider.notifier).changeData(todo);
  }

  DateTime dateTime = DateTime.now();

  final TextEditingController _controller =
      TextEditingController(text: DateTime.now().toString());

  final TextEditingController _text = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // print('todolist: $todoList');
    debugPrint('Build View');
    final validator = ref.watch(validateStateProvider);
    // final todoList = ref.watch(todoProvider);
    return Scaffold(
      body: ListSwapStl(
        type: widget.type,
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton.extended(
          label: const Row(
            children: [
              Icon(Icons.add_box),
              SizedBox(
                width: 10,
              ),
              Text('Add Task'),
            ],
          ),

          // isExtended: true,
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: const Text('Add Task'),
                  content: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _text,
                          decoration: InputDecoration(
                            labelText: "Task: ",
                            icon: const Icon(Icons.task),
                            errorText: validator ? "Task can't be empty" : null,
                          ),
                          onChanged: (value) {
                            desc = value;
                          },
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              ref
                                  .read(validateStateProvider.notifier)
                                  .update((state) => true);
                              return "Task can't be empty";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: "Deadline: ",
                            icon: Icon(Icons.timer),
                          ),
                          onTap: () async {
                            final date = await pickDate(context);
                            if (date == null) return;

                            final time = await pickTime(context);
                            if (time == null) return;
                            dateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                            _controller.text = dateTime.toString();
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        debugPrint('text: ${_text.text}');
                        if (_text.text.isEmpty) {
                          ref
                              .read(validateStateProvider.notifier)
                              .update((state) => true);
                          return;
                        } else {
                          String index = generateRandomString(12);
                          // ref.read(indexProvider.notifier).state = 'a';
                          changeStatus(
                            ref,
                            Todo(
                              ind: index,
                              desc: desc!,
                              dateTime: dateTime,
                              active: false,
                            ),
                          );

                          _text.clear();
                          Duration diff = dateTime.difference(DateTime.now());

                          ref
                              .read(timeProvider(index).notifier)
                              .start(diff.inSeconds);

                          ref
                              .read(fullTimeProvider(index).notifier)
                              .update((state) => diff.inSeconds);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit'),
                    )
                  ],
                );
              },
            );
          },
          backgroundColor: Colors.amberAccent,
        ),
      ),
    );
  }

  Future<DateTime?> pickDate(BuildContext context) => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(3000),
      );

  Future<TimeOfDay?> pickTime(BuildContext context) => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
}

///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************
///   ********************************  List class  ********************************

class ListSwapStl extends ConsumerWidget {
  ListSwapStl({
    super.key,
    required this.type,
  });
  String type;
  List<Todo> todoList = [];

  double progress = 0.0;

  var desc;

  void changeStatus(WidgetRef ref, Todo todo) {
    ref.read(todoProvider.notifier).changeData(todo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final controller = Get.put(TodoController());

    final userNotifier = ref.read(todoProvider.notifier);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 29, 29, 29),
      body: OrientationBuilder(builder: (context, orientation) {
        if (type == 'home') {
          todoList = ref.watch(todoProvider);
        } else if (type == 'completed') {
          todoList = ref.watch(tasksDone);
        } else {
          todoList = ref.watch(tasksDoing);
        }
        return todoList.isEmpty
            ? Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 27, 27, 27),
                ),
                child: const Center(
                  child: Text(
                    'No items in the list yet',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            : Scaffold(
                backgroundColor: Color.fromARGB(255, 27, 27, 27),
                body: ReorderableListView(
                  buildDefaultDragHandles: true,
                  children: [
                    for (int index = 0; index < todoList.length; index++)
                      Builder(
                          key: GlobalKey(),
                          builder: (context) {
                            print('Built');
                            return ListCard(
                              todo: todoList[index],
                              index: index,
                            );
                          }),
                  ],
                  onReorder: (oldIndex, newIndex) {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    userNotifier.swapItem(oldIndex, newIndex);
                  },
                ),
              );
      }),
    );
  }
}
