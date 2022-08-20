import 'package:bloc_pattern/model/model.dart';

class TodoRepository {
  Future<List<Map<String, dynamic>>> listTodo() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      {
        'id': '1',
        'title': 'Flutter 배우기',
        'createdAt': DateTime.now().toString(),
      },
      {
        'id': '2',
        'title': 'Flutter 써보기',
        'createdAt': DateTime.now().toString(),
      },
      {
        'id': '3',
        'title': '확정일자 받기',
        'createdAt': DateTime.now().toString(),
      }
    ];
  }

  Future<Map<String, dynamic>> createTodo(Todo todo) async {
    await Future.delayed(const Duration(seconds: 1));
    return todo.toJson();
  }

  Future<Map<String, dynamic>> deleteTodo(Todo todo) async {
    await Future.delayed(const Duration(seconds: 1));
    return todo.toJson();
  }
}
