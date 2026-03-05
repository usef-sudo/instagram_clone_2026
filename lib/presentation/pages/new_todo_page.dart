import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/todo_provider.dart';
import 'package:provider/provider.dart';

class NewTodoPage extends StatefulWidget {
  NewTodoPage({super.key});

  @override
  State<NewTodoPage> createState() => _NewTodoPageState();
}

class _NewTodoPageState extends State<NewTodoPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Todos"),
        ),
        body: Consumer<TodoProvider>(builder: (context, todoProvider, _) {
          if (todoProvider.isLoading)
            return Center(child: CircularProgressIndicator());

          if (todoProvider.error != "")
            return Center(child: Text(todoProvider.error));

          if (todoProvider.todos.length == 0)
            return Center(child: Text("No todos"));

          return ListView.builder(
            itemCount: todoProvider.todos.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(todoProvider.todos[index].title));
            },
          );
        }));
  }
}
