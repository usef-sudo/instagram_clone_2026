import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedHomeScreen extends StatelessWidget {
  const FeedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Posts").snapshots(),
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
          return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    height: 390,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data!.docs[index]['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 22),
                            ),
                            IconButton(
                                onPressed: () {
                                  final url = Uri.parse(
                                      "https://www.google.com/maps/search/?api=1&query=${snapshot.data!.docs[index]['latitude']},${snapshot.data!.docs[index]['longitude']}");

                                  try {
                                    launchUrl(url);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("Could not launch URL")));
                                  }
                                },
                                icon: Icon(Icons.location_searching))
                          ],
                        ),
                        Image.network(snapshot.data!.docs[index]['image'],
                            height: 200, fit: BoxFit.cover),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  snapshot.data!.docs[index]['discription'])),
                        ),
                        Row(
                          children: [
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    final url = Uri.parse(
                                        "https://wa.me/${snapshot.data!.docs[index]['phone']}");

                                    try {
                                      launchUrl(url);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Could not launch URL")));
                                    }
                                  },
                                  icon: Icon(Icons.link)),
                              Text(" ${snapshot.data!.docs[index]['phone']}"),
                            ]),
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    final url = Uri.parse(
                                        "sms:${snapshot.data!.docs[index]['phone']}");

                                    try {
                                      launchUrl(url);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Could not launch URL")));
                                    }
                                  },
                                  icon: Icon(Icons.message)),
                              Text(" ${snapshot.data!.docs[index]['phone']}"),
                            ]),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    final url = Uri.parse(
                                        "tel:${snapshot.data!.docs[index]['phone']}");

                                    try {
                                      launchUrl(url);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Could not launch URL")));
                                    }
                                  },
                                  icon: Icon(Icons.call)),
                              Text(" ${snapshot.data!.docs[index]['phone']}"),
                            ]),
                            Row(children: [
                              IconButton(
                                  onPressed: () {
                                    final url = Uri.parse(
                                        "mailto:${snapshot.data!.docs[index]['email']}?subject=Hello from the mobile app &body=<this email is from iphone");

                                    try {
                                      launchUrl(url);
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "Could not launch URL")));
                                    }
                                  },
                                  icon: Icon(Icons.mail)),
                              Text(" ${snapshot.data!.docs[index]['email']}"),
                            ]),
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
