import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Page to display users from Firestore collection
/// Collection: users
/// Document ID: userId
/// Field: fullName

class UsersListPage extends StatelessWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('oldusers').doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final doc = snapshot.data;

          if (doc == null || !doc.exists) {
            return const Center(child: Text('User not found'));
          }

          final userId = doc.id;
          final data = doc.data() as Map<String, dynamic>;
          final fullName = data['Full Name'] ?? 'Unknown';

          return Center(
            child: ListTile(
              leading: CircleAvatar(
                child: Text(fullName.toString().isNotEmpty ? fullName[0] : '?'),
              ),
              title: Text(fullName),
              subtitle: Text('User ID: $userId'),
            ),

          );
        },
      ),
    );
  }
}

/// Usage:
/// Navigator.push(
///   context,
///   MaterialPageRoute(builder: (_) => const UsersListPage()),
/// );
