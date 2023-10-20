import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:to_do_list/Repository/todoRepo.dart';
import 'package:to_do_list/utility/riverpod.dart';

class TodoController extends GetxController {
  static TodoController get instance => Get.find();

  final _todoRepo = Get.put(TodoRepo());
  final User? user = FirebaseAuth.instance.currentUser;

  getTodoList() {
    var email = user!.email ?? '';
    return _todoRepo.getTodoList(email);
  }

  updateTodoData(Todo todo) async {
    var email = user!.email ?? '';
    await _todoRepo.updateTodo(todo, email);
  }

  deleteTodoItem(Todo todo) async {
    var email = user!.email ?? '';
    await _todoRepo.deleteTodo(todo, email);
  }
}
