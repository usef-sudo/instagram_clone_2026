import 'package:instagram_clone/data/models/todo_model.dart';

abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodoError extends TodoState {}

class TodoEmpty extends TodoState {}

class TodoSuccess extends TodoState {
  final List<Todo> todos;
  TodoSuccess(this.todos);
}
