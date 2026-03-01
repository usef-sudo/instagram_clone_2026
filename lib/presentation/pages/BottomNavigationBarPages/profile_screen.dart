import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String userUid;
  ProfileScreen(this.userUid, {super.key});

  final _titleController = TextEditingController();
  final _discController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Posts")
            .where("userUid", isEqualTo: userUid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No Posts found'),
            );
          }
          return GridView.builder(
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data!.docs[index]['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                        Image.network(snapshot.data!.docs[index]['image'],
                            height: 80, fit: BoxFit.cover),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text(
                                            "Are you sure about deleting ${snapshot.data!.docs[index]['title']} Post?"),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection("Posts")
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .delete();
                                                Navigator.pop(context);
                                              },
                                              child: Text("Yes")),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text("cancel")),
                                        ],
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red[900],
                                size: 30,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _titleController.text =
                                    snapshot.data!.docs[index]['title'];
                                _discController.text =
                                    snapshot.data!.docs[index]['discription'];
                                _imageController.text =
                                    snapshot.data!.docs[index]['image'];

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SizedBox(
                                        height: 300,
                                        child: Dialog(
                                          child: Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller: _titleController,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  maxLines: 3,
                                                  controller: _discController,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                TextField(
                                                  controller: _imageController,
                                                  decoration: InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: [
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  "Posts")
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                  .id)
                                                              .update({
                                                            "title":
                                                                _titleController
                                                                    .text,
                                                            "discription":
                                                                _discController
                                                                    .text,
                                                            "image":
                                                                _imageController
                                                                    .text,
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Update")),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel"))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.yellow[900],
                                size: 30,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              });
        });
  }
}
//, isEqualTo: userUid
