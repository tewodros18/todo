import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:todo/todos/repository/todo_repository.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc({required this.todoRepository}) : super(TodoInitial()) {
    on<LoadTodosEvent>((event, emit) async {
      emit(TodosLoadingState());
      try {
        final List todos = await todoRepository.getAllTodos("todos");
        emit(TodosLoadedState(todos));
      } catch (e) {
        print(e);
        emit(TodosLoadingFailedState(Error));
      }
    });

    on<CreateTodoEvent>((event, emit) async {
      emit(TodosLoadingState());
      try {
        await todoRepository.addTodo(event.collection, event.data);
        final List todos = await todoRepository.getAllTodos("todos");
        emit(TodosLoadedState(todos));
      } catch (e) {
        emit(TodosLoadingFailedState(Error));
      }
    });
    on<updateTodoEvent>((event, emit) async {
      emit(TodosLoadingState());
      try {
        await todoRepository.updateTodo(
            event.collection, event.documentId, event.data);
        final List todos = await todoRepository.getAllTodos("todos");
        emit(TodosLoadedState(todos));
      } catch (e) {
        emit(TodosLoadingFailedState(Error));
      }
    });
    on<deleteTodoEvent>((event, emit) async {
      emit(TodosLoadingState());
      try {
        await todoRepository.deleteTodo(event.collection, event.documentId);
        final List todos = await todoRepository.getAllTodos("todos");
        emit(TodosLoadedState(todos));
      } catch (e) {
        emit(TodosLoadingFailedState(Error));
      }
    });
  }
}
