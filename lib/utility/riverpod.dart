import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// final todoProvider = StateNotifierProvider<UserNotifier, Todo>(
//   (ref) => UserNotifier(
//     Todo(
//       desc: '',
//       dateTime: DateTime.now(),
//       active: false,
//     ),
//   ),
// );
final todos = <Todo>[];

final todoProvider = StateNotifierProvider<UserNotifier, List<Todo>>(
  (ref) => UserNotifier(),
);

class Todo {
  // final int index;
  String desc;
  DateTime dateTime;
  bool active;

  Todo({
    required this.desc,
    required this.dateTime,
    required this.active,
  });

  Todo copyWith({
    String? desc,
    DateTime? dateTime,
    bool? active,
  }) {
    return Todo(
      desc: desc ?? this.desc,
      dateTime: dateTime ?? this.dateTime,
      active: active ?? this.active,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'desc': desc,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'active': active,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      desc: map['desc'] as String,
      dateTime: DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int),
      active: map['active'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'Todo(desc: $desc, dateTime: $dateTime, active: $active)';

  @override
  bool operator ==(covariant Todo other) {
    if (identical(this, other)) return true;

    return other.desc == desc &&
        other.dateTime == dateTime &&
        other.active == active;
  }

  @override
  int get hashCode => desc.hashCode ^ dateTime.hashCode ^ active.hashCode;
}

// class UserNotifier extends StateNotifier<Todo> {
//   UserNotifier(super.state);

//   void updateStatus(bool newValue) {
//     state = Todo(desc: state.desc, dateTime: state.dateTime, active: newValue);
//   }
// }

class UserNotifier extends StateNotifier<List<Todo>> {
  UserNotifier() : super([]);

  void updateTodoStatus(int index, bool newStatus) {
    state[index] = state[index].copyWith(active: newStatus);
    state = [...state];
  }

  void updateText(int index, String newText) {
    state[index] = state[index].copyWith(desc: newText);
    state = [...state];
  }

  void changeData(Todo todo) {
    state = [...state, todo];
  }
}
