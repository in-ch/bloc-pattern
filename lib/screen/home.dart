// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bloc_pattern/bloc/todo_cubic.dart';
import 'package:bloc_pattern/bloc/todo_state.dart';
import 'package:bloc_pattern/repository/todo_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(repository: TodoRepository()),
      child: const HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  String title = '';
  @override
  void initState() {
    super.initState();

    // ListTodosEvent
    BlocProvider.of<TodoCubit>(context).listTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter BloC'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<TodoCubit>().createTodo(title);
        },
        child: const Icon(Icons.edit),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (val) {
                title = val;
              },
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: BlocBuilder<TodoCubit, TodoState>(
                builder: (_, state) {
                  if (state is Empty) {
                    return Container();
                  } else if (state is Error) {
                    return Text(state.message);
                  } else if (state is Loading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is Loaded) {
                    final items = state.todos;

                    return ListView.separated(
                      itemBuilder: (_, index) {
                        final item = items[index];

                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.title,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                BlocProvider.of<TodoCubit>(context).deleteTodo(
                                  item,
                                );
                              },
                              child: const Icon(
                                Icons.delete,
                              ),
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (_, index) => const Divider(),
                      itemCount: items.length,
                    );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
