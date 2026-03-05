import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../data/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List<Todo> _todos = [];
  bool _isLoading = false;
  String _error = "";

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> getData() async {
    _isLoading = true;
    notifyListeners();

    final response =
    await http.get(Uri.parse("http://jsonplaceholder.typicode.com/todos"));


    if(response.statusCode!=200)
      _error = response.body;


    final List data = jsonDecode(response.body);

    _todos = data.map((e) => Todo.fromJson(e)).toList();

    _isLoading = false;
    notifyListeners();
  }
}
