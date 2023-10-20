import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_list/utility/riverpod.dart';

class TodoRepo extends GetxController {
  static TodoRepo get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  addTodo(Todo todo) async {
    await _db.collection('tyagikdmanav@gmail.com').add(todo.toMap());
    //     .whenComplete(() => Get.snackbar(
    //           'Success',
    //           'ToDo Added',
    //           snackPosition: SnackPosition.BOTTOM,
    //           backgroundColor: Colors.black,
    //           colorText: Colors.white,
    //         ))
    //     .catchError((error, stackTrace) {
    //   Get.snackbar(
    //     'Error',
    //     'Something went wrong, try again',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.black,
    //     colorText: Colors.white,
    //   );
    //   return 'error';
    // });
  }

  // late final snapshot;

  Future<List<Todo>> getTodoList(String mail) async {
    final snapshot = await _db.collection(mail).orderBy("dateTime").get();
    final userTodo = snapshot.docs.map((e) => Todo.fromSnapshpt(e)).toList();
    return userTodo;
  }

  Future<void> updateTodo(Todo todo, String mail) async {
    final snapshot =
        await _db.collection(mail).where("index", isEqualTo: todo.ind).get();
    var id = snapshot.docs.map((e) => e.id).single;
    print(id);
    await _db.collection(mail).doc(id).update(todo.toMap());
  }

  Future<void> deleteTodo(Todo todo, String mail) async {
    final snapshot =
        await _db.collection(mail).where("index", isEqualTo: todo.ind).get();
    print(todo);
    var id = snapshot.docs.map((e) => e.id).single;
    print(id);
    await _db.collection(mail).doc(id).delete();
  }
}
