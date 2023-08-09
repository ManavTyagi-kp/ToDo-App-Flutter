import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utility/riverpod.dart';

final validateStateProvider = StateProvider<bool>((ref) {
  return false;
});

class ListViewer extends ConsumerWidget {
  // const ListViewer({super.key});

  var desc;

  ListViewer({super.key});

  void changeStatus(WidgetRef ref, Todo todo) {
    ref.read(todoProvider.notifier).changeData(todo);
  }

  DateTime dateTime = DateTime.now();

  final TextEditingController _controller =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _text = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Build View');
    final validator = ref.watch(validateStateProvider);
    // final todoList = ref.watch(todoProvider);
    return Scaffold(
      body: const ListItem(),
      floatingActionButton: FloatingActionButton(
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
                        // _validate = false;
                        // todoList.add(
                        //   Todo(
                        //     desc: desc!,
                        //     dateTime: dateTime,
                        //     active: false,
                        //   ),
                        // );
                        changeStatus(
                          ref,
                          Todo(
                            desc: desc!,
                            dateTime: dateTime,
                            active: false,
                          ),
                        );
                        _text.clear();
                        // _selected.add(false);
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
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
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

class ListItem extends ConsumerWidget {
  const ListItem({super.key});

  Widget _strikeThrough(String text, bool taskDone, WidgetRef ref, int index) {
    return TextFormField(
      decoration: const InputDecoration(border: InputBorder.none),
      initialValue: text,
      onChanged: (value) {
        final userNotifier = ref.read(todoProvider.notifier);
        userNotifier.updateText(index, value);
      },
      style: taskDone
          ? const TextStyle(
              fontSize: 22,
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            )
          : const TextStyle(
              fontSize: 22,
              color: Color.fromARGB(207, 0, 0, 0),
            ),
    );
  }

  void changeStatus(WidgetRef ref, Todo todo) {
    ref.read(todoProvider.notifier).changeData(todo);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('Build');
    final todoList = ref.watch(todoProvider);

    final userNotifier = ref.read(todoProvider.notifier);
    return Scaffold(
      body: ListView.builder(
          itemCount: ref.watch(todoProvider.select((value) => value.length)),
          itemBuilder: (_, index) {
            return CheckboxListTile(
              value: todoList[index].active,
              onChanged: (value) {
                // setState(() {
                //   index.active = value!;
                // });
                userNotifier.updateTodoStatus(index, value!);
                // changeStatus(ref, todoList[index]);
              },
              title: TextFormField(
                decoration: const InputDecoration(border: InputBorder.none),
                initialValue: todoList[index].desc,
                onChanged: (value) {
                  userNotifier.updateText(index, value);
                },
                style: todoList[index].active
                    ? const TextStyle(
                        fontSize: 22,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      )
                    : const TextStyle(
                        fontSize: 22,
                        color: Color.fromARGB(207, 0, 0, 0),
                      ),
              ),
              subtitle: Text(
                '${todoList[index].dateTime.day}/${todoList[index].dateTime.month}/${todoList[index].dateTime.year}   ${todoList[index].dateTime.hour}:${todoList[index].dateTime.minute}',
                style: const TextStyle(fontSize: 12),
              ),
            );
          }),
    );
  }
}
