// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:to_do_list/controller/todoListController.dart';

// Todo todo1 = Todo(desc: '111ef', dateTime: DateTime.now(), active: false);
// Todo todo2 = Todo(desc: '222ef', dateTime: DateTime.now(), active: false);
// Todo todo3 = Todo(
//     desc: '333ef',
//     dateTime: DateTime.parse("2023-08-16 18:00:00"),
//     active: false);
final todos = <Todo>[];

List<Todo> todoWithIndex = todos
    .asMap()
    .entries
    .map((entry) {
      int index = entry.key;
      Todo item = entry.value;
      return '$index: $item';
    })
    .cast<Todo>()
    .toList();

final indexProvider = StateProvider((ref) => 'a');

final tasksDone = Provider<List<Todo>>((ref) {
  final tasks = ref.watch(todoProvider);
  return tasks.where((todo) => todo.active).toList();
});

final tasksDoing = Provider<List<Todo>>((ref) {
  final tasks = ref.watch(todoProvider);
  return tasks.where((todo) => !todo.active).toList();
});

final todoProvider = StateNotifierProvider<UserNotifier, List<Todo>>((ref) {
  return UserNotifier();
});

final fullTimeProvider = StateProvider.family<int, String>((ref, index) => 0);

final timeProvider =
    StateNotifierProvider.family<TimeProvider, AsyncValue<double>, String>(
  (ref, ind) {
    // int index = ref.watch(todoProvider.notifier).getIndex(ind);
    return TimeProvider(ind, changeStatus: () {
      ref.read(todoProvider.notifier).updateTodoStatus(ind, true);
    });
  },
);

class TimeProvider extends StateNotifier<AsyncValue<double>> {
  final String index;
  final VoidCallback changeStatus;
  late StreamSubscription<double>? _subscription; // Add this variable

  TimeProvider(this.index, {required this.changeStatus})
      : super(const AsyncValue.data(0));

  Stream<double> countdownStream(int time) {
    print('time: $time');
    return Stream.periodic(
            const Duration(seconds: 1), (count) => (time - count) / time)
        .take(time);
  }

  void start(int time) {
    print('start called with time: $time');
    state = AsyncValue.data(time / 1);

    _subscription = countdownStream(time).listen((countdown) {
      print('countdown $index: $countdown');
      print(countdown * time);
      if (countdown * time > 1.9) {
        state = AsyncValue.data(countdown);
      } else {
        print('Time zero for index: $index');
        changeStatus();
        state = const AsyncValue.data(0);
      }
    });
  }

  void pauseStream() {
    _subscription?.pause();
  }

  void resumeStream() {
    _subscription?.resume();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

class Todo {
  final String ind;
  String desc;
  String? description;
  DateTime dateTime;
  bool active;

  Todo({
    required this.ind,
    required this.desc,
    this.description,
    required this.dateTime,
    required this.active,
  });

  Todo copyWith({
    String? index,
    String? desc,
    String? description,
    DateTime? dateTime,
    bool? active,
  }) {
    return Todo(
      ind: index ?? this.ind,
      desc: desc ?? this.desc,
      description: description ?? this.description,
      dateTime: dateTime ?? this.dateTime,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'index': ind,
      'desc': desc,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'active': active,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      ind: map['index'] as String,
      desc: map['desc'] as String,
      description:
          map['description'] != null ? map['description'] as String : null,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Todo(index: $ind, desc: $desc, description: $description, dateTime: $dateTime, active: $active)';
  }

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.ind == ind &&
        other.desc == desc &&
        other.description == description &&
        other.dateTime == dateTime &&
        other.active == active;
  }

  @override
  int get hashCode {
    return ind.hashCode ^
        desc.hashCode ^
        description.hashCode ^
        dateTime.hashCode ^
        active.hashCode;
  }

  factory Todo.fromSnapshpt(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data();
    return Todo(
      ind: data!['index'],
      desc: data["desc"],
      description: data["description"],
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime'] as int),
      active: data["active"],
    );
  }
}

class UserNotifier extends StateNotifier<List<Todo>> {
  // UserNotifier() : super([todo1, todo2, todo3]);
  UserNotifier() : super([]);
  final controller = Get.put(TodoController());

  void updateTodoStatus(String ind, bool newStatus) {
    print('update called');
    final newState = [...state];
    int index = newState.indexWhere((todo) => todo.ind == ind);
    state[index] = state[index].copyWith(active: newStatus);
    controller.updateTodoData(state[index]);
    state = [...state];
  }

  void updateText(int index, String newText) {
    state[index] = state[index].copyWith(desc: newText);
    controller.updateTodoData(state[index]);
    state = [...state];
  }

  void addDesc(int index, String description) {
    state[index] = state[index].copyWith(description: description);
    controller.updateTodoData(state[index]);
  }

  int getIndex(int ind) {
    state = [...state];
    int index = state.indexWhere((todo) => todo.ind == ind);
    return index;
  }

  void changeData(Todo todo) {
    state = [...state, todo];
  }

  void swapItem(int oldIndex, int newIndex) {
    final newState = [...state];
    final itemToMove = newState.removeAt(oldIndex);
    newState.insert(newIndex, itemToMove);
    state = newState;
  }

  void delete(int index) {
    final newState = [...state];
    controller.deleteTodoItem(newState[index]);
    newState.removeAt(index);
    state = newState;
  }
}
