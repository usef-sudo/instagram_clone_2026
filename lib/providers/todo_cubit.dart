import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:instagram_clone/providers/todo_state.dart';

import '../data/models/todo_model.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(TodoLoading());

  Future<void> getData() async {
    final response =
        await http.get(Uri.parse("http://jsonplaceholder.typicode.com/todos"));

    if (response.statusCode != 200) emit(TodoError());

    final List data = jsonDecode(response.body);

    final todos = data.map((e) => Todo.fromJson(e)).toList();

    if (todos.length == 0) emit(TodoEmpty());

    emit(TodoSuccess(todos));
  }
}
