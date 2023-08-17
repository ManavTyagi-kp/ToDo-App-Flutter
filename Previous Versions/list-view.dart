// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:to_do_list/pages/list.dart';

import '../utility/riverpod.dart';

class MyList extends StatefulWidget {
  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  // const MyList({super.key});
  bool _validate = false;
  String? desc;

  void changeStatus(WidgetRef ref, bool newValue) {
    // ref.read(todoProvider.notifier).updateStatus(newValue);
  }

  DateTime dateTime = DateTime.now();

  final TextEditingController _controller =
      TextEditingController(text: DateTime.now().toString());
  final TextEditingController _text = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    _text.dispose();
    super.dispose();
  }

  Widget _strikeThrough(String text, bool taskDone) {
    if (taskDone) {
      return Text(
        text,
        style: const TextStyle(
          fontSize: 22,
          decoration: TextDecoration.lineThrough,
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    } else {
      return Text(
        text,
        style:
            const TextStyle(fontSize: 22, color: Color.fromARGB(207, 0, 0, 0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ReorderableListView(
        buildDefaultDragHandles: true,
        children: <Widget>[
          for (var index in todos)
            CheckboxListTile(
              key: Key(index.desc),
              value: index.active,
              onChanged: (value) {
                setState(() {
                  index.active = value!;
                });
              },
              title: _strikeThrough(index.desc, index.active),
              subtitle: Text(
                '${index.dateTime.day}/${index.dateTime.month}/${index.dateTime.year}   ${index.dateTime.hour}:${index.dateTime.minute}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            var getReplacedWidget = todos.removeAt(oldIndex);
            todos.insert(newIndex, getReplacedWidget);
          });
        },
      ),
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
                          errorText: _validate ? "Task can't be empty" : null,
                        ),
                        onChanged: (value) {
                          desc = value;
                        },
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            setState(() {
                              _validate = true;
                            });
                            // _validate = true;
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
                          final date = await pickDate();
                          if (date == null) return;

                          final time = await pickTime();
                          if (time == null) return;

                          setState(() {
                            dateTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                            _controller.text = dateTime.toString();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        print('text: ${_text.text}');
                        if (_text.text.isEmpty) {
                          _validate = true;
                          return;
                        } else {
                          // _validate = false;
                          todos.add(
                            Todo(
                              ind: 0, //TODO Error
                              desc: desc!,
                              dateTime: dateTime,
                              active: false,
                            ),
                          );
                          _text.clear();
                          // _selected.add(false);
                          Navigator.pop(context);
                        }
                      });
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

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime.now(),
        lastDate: DateTime(3000),
      );

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
}
