// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/riverpod.dart';
import 'fullScreen.dart';

final validateStateProvider = StateProvider<bool>((ref) {
  return false;
});

class ListViewerTimer extends ConsumerWidget {
  // const ListViewer({super.key});
  String type;
  String? desc;
  var todoList = [];

  ListViewerTimer({
    super.key,
    required this.type,
  });

  void changeStatus(WidgetRef ref, Todo todo) {
    ref.read(todoProvider.notifier).changeData(todo);
  }

  DateTime dateTime = DateTime.now();

  final TextEditingController _controller =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _text = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // print('todolist: $todoList');
    debugPrint('Build View');
    final validator = ref.watch(validateStateProvider);
    // final todoList = ref.watch(todoProvider);
    return Scaffold(
      body: ListSwapStl(
        type: type,
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
                          int index = ref.watch(indexProvider);
                          ref.read(indexProvider.notifier).state++;
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
  double progress = 0.0;
  String type;
  var desc;
  List<Todo> todoList = [];

  void changeStatus(WidgetRef ref, Todo todo) {
    ref.read(todoProvider.notifier).changeData(todo);
  }

  FocusNode _generateFocus(int index) {
    final FocusNode index = FocusNode();
    return index;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugPrint('Build');
    // final todoList = ref.watch(todoProvider);
    if (type == 'home') {
      todoList = ref.watch(todoProvider);
    } else if (type == 'completed') {
      todoList = ref.watch(tasksDone);
    } else {
      todoList = ref.watch(tasksDoing);
    }

    final userNotifier = ref.read(todoProvider.notifier);
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
                        int ind = todoList[index].ind;
                        bool _active = todoList[index].active;
                        Duration diff =
                            todoList[index].dateTime.difference(DateTime.now());
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                15.0), // Adjust the radius as needed
                            side: const BorderSide(
                              color: Colors.amberAccent, // Border color
                              width: 15, // Border width
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: CheckboxListTile(
                              tileColor: Colors.amberAccent,
                              value: todoList[index].active,
                              hoverColor:
                                  const Color.fromARGB(255, 245, 212, 94),
                              contentPadding: const EdgeInsets.all(20),
                              // key: GlobalKey(),
                              onChanged: (value) {
                                value!
                                    ? {
                                        ref
                                            .read(todoProvider.notifier)
                                            .updateTodoStatus(ind, value),
                                        ref
                                            .read(timeProvider(ind).notifier)
                                            .pauseStream(),
                                      }
                                    : {
                                        ref
                                            .read(todoProvider.notifier)
                                            .updateTodoStatus(ind, value),
                                        ref
                                            .read(timeProvider(ind).notifier)
                                            .resumeStream(),
                                      };
                              },
                              title: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      if (_active != true) {
                                        debugPrint(diff.inSeconds.toString());
                                        if (diff.inSeconds < 21600 &&
                                            diff.inSeconds > 0) {
                                          print('index: $index');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FullScreen(
                                                index: index,
                                                ind: ind,
                                              ),
                                            ),
                                          );
                                        } else if (diff.inSeconds < 0) {
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Time Over',
                                                ),
                                              ),
                                            );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                            ..removeCurrentSnackBar()
                                            ..showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Time left should be less than 6 hours for focus mode',
                                                ),
                                              ),
                                            );
                                        }
                                      } else {
                                        null;
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        shape: const CircleBorder(
                                          eccentricity: 0,
                                        ),
                                        padding: const EdgeInsets.all(10)),
                                    child: Stack(
                                      children: [
                                        Consumer(
                                            builder: (context, ref, child) {
                                          return CircularProgressIndicator(
                                            value: ref
                                                .watch(timeProvider(ind))
                                                .when(
                                                  data: (countdownValue) {
                                                    if (countdownValue >
                                                        0.0199) {
                                                      progress = countdownValue;
                                                      return progress;
                                                    } else {
                                                      return 0;
                                                    }
                                                  },
                                                  loading: () => 0,
                                                  error: (error, stackTrace) =>
                                                      0,
                                                ),
                                            valueColor: progress > 0.25
                                                ? const AlwaysStoppedAnimation<
                                                    Color>(Colors.green)
                                                : const AlwaysStoppedAnimation(
                                                    Colors.red),
                                            backgroundColor:
                                                Colors.black.withOpacity(0),
                                          );
                                        }),
                                        Positioned.fill(
                                          child: Transform.translate(
                                            offset: const Offset(0, 0),
                                            child: const Icon(
                                              Icons.play_arrow_outlined,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onHover: (value) {
                                      const Tooltip(
                                        message: 'Focus Mode',
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: 300,
                                    height: 50,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: TextFormField(
                                            focusNode: _generateFocus(index),
                                            textInputAction:
                                                TextInputAction.done,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none),
                                            initialValue: todoList[index].desc,
                                            onFieldSubmitted: (val) {
                                              print(GlobalKey());
                                              _generateFocus(index).dispose();
                                              userNotifier.updateText(
                                                  index, val);
                                            },
                                            onEditingComplete: () {
                                              _generateFocus(index).dispose();
                                            },
                                            style: todoList[index].active
                                                ? const TextStyle(
                                                    fontSize: 22,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    color: Colors.grey,
                                                    fontStyle: FontStyle.italic,
                                                  )
                                                : const TextStyle(
                                                    fontSize: 22,
                                                    color: Color.fromARGB(
                                                        207, 0, 0, 0),
                                                  ),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${todoList[index].dateTime.day}/${todoList[index].dateTime.month}/${todoList[index].dateTime.year}   ${todoList[index].dateTime.hour}:${todoList[index].dateTime.minute}',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Padding(
                                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                child: TextFormField(
                                  focusNode: _generateFocus(index),
                                  textInputAction: TextInputAction.done,
                                  decoration: const InputDecoration(
                                      hintText: 'Add SubTitle',
                                      border: InputBorder.none),
                                  initialValue: todoList[index].description,
                                  onChanged: (val) {
                                    print(GlobalKey());
                                    _generateFocus(index).dispose();
                                    userNotifier.addDesc(index, val);
                                  },
                                  onEditingComplete: () {
                                    _generateFocus(index).dispose();
                                  },
                                  style: todoList[index].active
                                      ? const TextStyle(
                                          fontSize: 11,
                                          decoration:
                                              TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontStyle: FontStyle.italic,
                                        )
                                      : const TextStyle(
                                          fontSize: 11,
                                          color: Color.fromARGB(207, 0, 0, 0),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
              ],
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                // final prov1 = ref.read(timeProvider(oldIndex).notifier).start(time);
                // ref.read(timeProvider(oldIndex).notifier).state =
                //     ref.read(timeProvider(newIndex).notifier).state;
                // ref.read(timeProvider(newIndex).notifier).state = prov1;
                userNotifier.swapItem(oldIndex, newIndex);
              },
            ),
          );
  }
}
