part of 'todo_bloc.dart';

@immutable
abstract class TodoState extends Equatable {
  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodosLoadingState extends TodoState {}

class TodosLoadedState extends TodoState {
  final List<dynamic> todoList;
  TodosLoadedState(this.todoList);

  @override
  List<Object> get props => [];
}

class TodosLoadingFailedState extends TodoState {
  final Error;
  TodosLoadingFailedState(this.Error);
}
