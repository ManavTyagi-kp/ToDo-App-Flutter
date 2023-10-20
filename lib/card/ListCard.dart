// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:to_do_list/Repository/todoRepo.dart';
import 'package:to_do_list/pages/fullScreen.dart';

import 'package:to_do_list/utility/riverpod.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

class ListCard extends ConsumerWidget {
  final Todo todo;
  final int index;
  ListCard({
    Key? key,
    required this.todo,
    required this.index,
  }) : super(key: key);

  FocusNode _generateFocus(int index) {
    final FocusNode index = FocusNode();
    return index;
  }

  double progress = 0.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoRepo = Get.put(TodoRepo());
    print('Card called');
    Duration diff = todo.dateTime.difference(DateTime.now());
    // ref.read(timeProvider(index).notifier).start(diff.inSeconds);
    final userNotifier = ref.read(todoProvider.notifier);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4.0, 2, 4.0, 0),
      child: Slidable(
        key: ValueKey(index),
        startActionPane: ActionPane(
          motion: const ScrollMotion(),
          dismissible: DismissiblePane(onDismissed: () {
            userNotifier.delete(index);
          }),
          children: [
            SlidableAction(
              onPressed: (context) {},
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: (context) {},
              backgroundColor: Color(0xFF7BC043),
              foregroundColor: Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
            side: const BorderSide(
              color: Colors.amberAccent, // Border color
              width: 15, // Border width
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: CheckboxListTile(
              tileColor: Colors.amberAccent,
              value: todo.active,
              hoverColor: const Color.fromARGB(255, 245, 212, 94),
              contentPadding: const EdgeInsets.all(20),
              // key: GlobalKey(),
              onChanged: (value) {
                value!
                    ? {
                        ref
                            .read(todoProvider.notifier)
                            .updateTodoStatus(todo.ind, value),
                        ref.read(timeProvider(todo.ind).notifier).pauseStream(),
                      }
                    : {
                        ref
                            .read(todoProvider.notifier)
                            .updateTodoStatus(todo.ind, value),
                        ref
                            .read(timeProvider(todo.ind).notifier)
                            .resumeStream(),
                      };
              },
              title: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (todo.active != true) {
                        debugPrint(diff.inSeconds.toString());
                        if (diff.inSeconds < 21600 && diff.inSeconds > 0) {
                          print('index: $index');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreen(
                                index: index,
                                ind: todo.ind,
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
                        padding: const EdgeInsets.all(7)),
                    child: Stack(
                      children: [
                        Consumer(builder: (context, ref, child) {
                          return CircularProgressIndicator(
                            value: ref.watch(timeProvider(todo.ind)).when(
                                  data: (countdownValue) {
                                    if (countdownValue > 0.0199) {
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
                                ? const AlwaysStoppedAnimation<Color>(
                                    Colors.green)
                                : const AlwaysStoppedAnimation(Colors.red),
                            backgroundColor: Colors.black.withOpacity(0),
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
                    width: 200,
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            focusNode: _generateFocus(index),
                            textInputAction: TextInputAction.done,
                            decoration:
                                const InputDecoration(border: InputBorder.none),
                            initialValue: todo.desc,
                            onFieldSubmitted: (val) {
                              print(GlobalKey());
                              _generateFocus(index).dispose();
                              userNotifier.updateText(index, val);
                            },
                            onEditingComplete: () {
                              _generateFocus(index).dispose();
                            },
                            style: todo.active
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
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${todo.dateTime.day}/${todo.dateTime.month}/${todo.dateTime.year}   ${todo.dateTime.hour}:${todo.dateTime.minute}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: TextFormField(
                  focusNode: _generateFocus(index),
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                      hintText: 'Add SubTitle', border: InputBorder.none),
                  initialValue: todo.description,
                  onFieldSubmitted: (val) {
                    // print(GlobalKey());
                    // _generateFocus(index).dispose();
                    userNotifier.addDesc(index, val);
                  },
                  style: todo.active
                      ? const TextStyle(
                          fontSize: 11,
                          decoration: TextDecoration.lineThrough,
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
        ),
      ),
    );
  }
}
