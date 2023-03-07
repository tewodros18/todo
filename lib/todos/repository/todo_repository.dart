import 'package:todo/todos/data_provider/todo_dataprovider.dart';
import 'package:todo/todos/models/todo_model.dart';

class TodoRepository {
  final TodoDataProvider todoDataProvider;
  TodoRepository({required this.todoDataProvider});

  Future<List<dynamic>> getAllTodos(String collection) async {
    return await todoDataProvider.getAllTodos(collection);
  }

  Future addTodo(String collections, Map<String, dynamic> data) async {
    return await todoDataProvider.addTodo(collections, data);
  }

  Future updateTodo(
      String collection, String documentId, Map<String, dynamic> data) async {
    return await todoDataProvider.updateTodoWithId(
        collection, documentId, data);
  }

  Future deleteTodo(String collection, String documentId) async {
    return await todoDataProvider.deleteTodo(collection, documentId);
  }
}
