import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/providers/todo_cubit.dart';
import 'package:instagram_clone/providers/todo_provider.dart';
import 'package:instagram_clone/providers/todo_state.dart';
import 'package:provider/provider.dart';

class NewTodoPage extends StatelessWidget {
  NewTodoPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Todos"),
        ),
        body: BlocBuilder<TodoCubit, TodoState>(builder: (context, todoState) {
          if (todoState is TodoLoading) return CircularProgressIndicator();
          if (todoState is TodoError) return Text("Something went wrong");
          if (todoState is TodoEmpty) return Text("No todos");
          if (todoState is TodoSuccess)
            return ListView.builder(
                itemCount: todoState.todos.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(todoState.todos[index].title));
                });
          return SizedBox();
        })

        // Consumer<TodoProvider>(builder: (context, todoProvider, _) {
        //   if (todoProvider.isLoading)
        //     return Center(child: CircularProgressIndicator());
        //
        //   if (todoProvider.error != "")
        //     return Center(child: Text(todoProvider.error));
        //
        //   if (todoProvider.todos.length == 0)
        //     return Center(child: Text("No todos"));
        //
        //   return ListView.builder(
        //     itemCount: todoProvider.todos.length,
        //     itemBuilder: (context, index) {
        //       return ListTile(title: Text(todoProvider.todos[index].title));
        //     },
        //   );
        // } )

        );
  }
}
