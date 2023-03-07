import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/todos/models/todo_model.dart';

class TodoDataProvider {
  Future<List<dynamic>> getAllTodos(String collection) async {
    //Todo.fromMap(item.data())
    return (await FirebaseFirestore.instance.collection(collection).get())
        .docs
        .map((item) => item)
        .toList();
  }

  Future addTodo(String collection, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance.collection(collection).add(data);
  }

  Future updateTodoWithId(
      String collection, String documentId, Map<String, dynamic> data) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(documentId)
        .update(data);
  }

  Future deleteTodo(String collection, String documentId) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(documentId)
        .delete();
  }
}
