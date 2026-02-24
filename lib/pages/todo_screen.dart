import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoScreen extends StatefulWidget {
  final String userUid;
  TodoScreen(this.userUid, {super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  bool isPublic = false;
  final TextEditingController _todoController = TextEditingController();

  CollectionReference publicTodosRef =
      FirebaseFirestore.instance.collection("public_todos");

  final _updateTodoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference privateTodosRef = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.userUid)
        .collection("private_todos");
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo Page"),
        actions: [
          IconButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                prefs.remove("userUid");

                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    color: Colors.amber,
                    child: Switch(
                        value: isPublic,
                        onChanged: (val) {
                          isPublic = val;
                          setState(() {});
                        })),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: TextField(
                      controller: _todoController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Enter todo item",
                      ),
                    ),
                  ),
                ),
                Container(
                    color: Colors.amber,
                    child: IconButton(
                        onPressed: () {
                          if (isPublic) {
                            // Add to public todos
                            publicTodosRef.doc().set({
                              "todo": _todoController.text,
                            });
                            _todoController.clear();
                          } else {
                            // Add to private todos
                            privateTodosRef.doc().set({
                              "todo": _todoController.text,
                              "isDone": false,
                              "createdAt": FieldValue.serverTimestamp(),
                            });
                            _todoController.clear();
                          }
                        },
                        icon: Icon(Icons.add)))
              ],
            ),
            Expanded(
                child: Container(
                    child: Column(
              children: [
                TabBar(
                  tabs: [
                    Tab(text: "Private Todos"),
                    Tab(text: "Public Todos"),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      StreamBuilder(
                          stream:
                              privateTodosRef.orderBy('createdAt').snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text('No users found'),
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.size,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: IconButton(
                                        onPressed: () {
                                          privateTodosRef
                                              .doc(
                                                  snapshot.data!.docs[index].id)
                                              .update({
                                            "isDone": !snapshot
                                                .data!.docs[index]["isDone"]
                                          });
                                        },
                                        icon: Icon(snapshot.data!.docs[index]
                                                ["isDone"]
                                            ? Icons.refresh
                                            : Icons.done)),
                                    title: Text(
                                        snapshot.data!.docs[index]['todo']),
                                    tileColor: snapshot.data!.docs[index]
                                            ['isDone']
                                        ? Colors.green[100]
                                        : Colors.amber,
                                    trailing: SizedBox(
                                      width: 100,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                _updateTodoController.text =
                                                    snapshot.data!.docs[index]
                                                        ['todo'];

                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return SizedBox(
                                                        height: 300,
                                                        child: Dialog(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(18.0),
                                                            child: Column(
                                                              children: [
                                                                TextField(
                                                                  controller:
                                                                      _updateTodoController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 40,
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    ElevatedButton(
                                                                        onPressed:
                                                                            () {
                                                                          privateTodosRef.doc(snapshot.data!.docs[index].id).update({
                                                                            "todo":
                                                                                _updateTodoController.text
                                                                          });
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            "Update")),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child: Text(
                                                                            "Cancel"))
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                              icon: Icon(Icons.edit)),
                                          IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            "Are you sure about deleting this todo?"),
                                                        actions: [
                                                          ElevatedButton(
                                                              onPressed: () {
                                                                privateTodosRef
                                                                    .doc(snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                        .id)
                                                                    .delete();
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  Text("Yes")),
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                  "cancel")),
                                                        ],
                                                      );
                                                    });
                                              },
                                              icon: Icon(Icons.delete)),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                      StreamBuilder(
                          stream: publicTodosRef.snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text('No users found'),
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.size,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(
                                        snapshot.data!.docs[index]['todo']),
                                  );
                                });
                          }),
                    ],
                  ),
                ),
              ],
            )))
          ],
        ),
      ),
    );
  }
}
