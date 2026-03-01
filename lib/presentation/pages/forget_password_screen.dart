import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetScreen extends StatelessWidget {
  ForgetScreen({super.key});

  final _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forget Password"),
      ),
      body: Column(
        children: [
          Image.network(
            "https://png.pngtree.com/png-vector/20221018/ourmid/pngtree-instagram-icon-png-image_6315974.png",
            height: 70,
            width: 70,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance
                    .sendPasswordResetEmail(email: _emailController.text);

                _emailController.clear();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Password reset email sent!"),
                ));
              },
              child: Text("Reset Password"))
        ],
      ),
    );
  }
}
