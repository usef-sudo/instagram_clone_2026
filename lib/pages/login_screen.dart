import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/pages/todo_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'create_account_screen.dart';
import 'forget_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login Screen"),
        ),
        body: Column(
          children: [
            Image.network(
              "https://unblast.com/wp-content/uploads/2025/07/instagram-logo-colored.jpg",
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgetScreen()));
                    },
                    child: Text("Forgot Password?"))),
            SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    UserCredential userCredential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                    if (userCredential.user != null) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      await prefs.setString(
                          'userUid', userCredential.user!.uid);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              HomeScreen(userCredential.user!.uid)));
                    }
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.code),
                      ),
                    );
                  } catch (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Login failed."),
                      ),
                    );
                  }
                },
                child: Text("Login")),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Expanded(
                    child: Divider(
                  thickness: 2,
                )),
                Text("OR"),
                Expanded(
                    child: Divider(
                  thickness: 2,
                )),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CreateAccountScreen()));
                },
                child: Text("Create New Account")),
          ],
        ));
  }
}
