part of 'todo_bloc.dart';

@immutable
abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodosEvent extends TodoEvent {
  @override
  List<Object> get props => [];
}

class CreateTodoEvent extends TodoEvent {
  final String collection;
  final dynamic data;

  CreateTodoEvent({required this.collection, required this.data});
  @override
  List<Object> get props => [];
}

class updateTodoEvent extends TodoEvent {
  final String collection;
  final String documentId;
  final dynamic data;

  updateTodoEvent(this.collection, this.documentId, this.data);
  @override
  List<Object> get props => [];
}

class deleteTodoEvent extends TodoEvent {
  final String collection;
  final String documentId;
  deleteTodoEvent(this.collection,this.documentId);
  @override
  List<Object> get props => [];

}
