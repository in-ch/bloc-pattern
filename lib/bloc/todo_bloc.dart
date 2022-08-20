import 'package:bloc_pattern/model/todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_pattern/bloc/todo_event.dart';
import 'package:bloc_pattern/bloc/todo_state.dart';

import 'package:bloc_pattern/repository/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository repository;

  TodoBloc({required this.repository}) : super(Empty()); // super에는 초기값.

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is ListTodosEvent) {
      yield* _mapListTodoEvent(event);
    } else if (event is CreateTodosEvent) {
      yield* _mapCreateTodoEvent(event);
    } else if (event is DeleteTodosEvent) {
      yield* _mapDeleteTodoEvent(event);
    }
  }

  Stream<TodoState> _mapListTodoEvent(ListTodosEvent event) async* {
    try {
      yield Loading();
      final repo = await repository.listTodo();
      final todos = repo.map<Todo>((e) => Todo.fromJson(e)).toList();
      Loaded(todos: todos);
    } catch (e) {
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapCreateTodoEvent(CreateTodosEvent event) async* {
    try {
      if (state is Loaded) {
        final parsedState = (state as Loaded);

        final newTodo = Todo(
          id: parsedState.todos.isNotEmpty
              ? parsedState.todos[parsedState.todos.length - 1].id + 1
              : 1,
          title: event.title,
          createdAt: DateTime.now().toString(),
        ); // optimistic update

        final prevTodos = [
          ...parsedState.todos,
        ];

        final newTodos = [
          newTodo,
          ...prevTodos,
        ];

        yield Loaded(todos: newTodos);

        final repo = await repository.createTodo(newTodo);

        yield Loaded(
          todos: [
            Todo.fromJson(repo),
            ...prevTodos,
          ],
        );
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapDeleteTodoEvent(DeleteTodosEvent event) async* {
    try {
      if (state is Loaded) {
        final newTodos = (state as Loaded)
            .todos
            .where((todo) => todo.id != event.todo.id)
            .toList(); // optimistic update

        yield Loaded(todos: newTodos);

        await repository.deleteTodo(event.todo);
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }
}
