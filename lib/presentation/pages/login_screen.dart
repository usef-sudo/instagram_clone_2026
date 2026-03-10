// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_clone/providers/theme_cubit.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'create_account_screen.dart';
// import 'forget_password_screen.dart';
// import 'home_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   LoginScreen({ super.key});
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     // final themeProvider = Provider.of<ThemeProvider>(context);
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("login_screen").tr(),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: Image.network(
//                 "https://unblast.com/wp-content/uploads/2025/07/instagram-logo-colored.jpg",
//                 height: 70,
//                 width: 70,
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'email'.tr(),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(),
//                   labelText: 'password'.tr(),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 24,
//             ),
//             TextButton(
//                 onPressed: () {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => ForgetScreen()));
//                 },
//                 child: Text("forgot_password").tr()),
//             SizedBox(
//               height: 100,
//             ),
//             Center(
//               child: ElevatedButton(
//                   onPressed: () async {
//                     try {
//                       UserCredential userCredential = await FirebaseAuth
//                           .instance
//                           .signInWithEmailAndPassword(
//                         email: _emailController.text.trim(),
//                         password: _passwordController.text.trim(),
//                       );
//                       if (userCredential.user != null) {
//                         SharedPreferences prefs =
//                             await SharedPreferences.getInstance();
//
//                         await prefs.setString(
//                             'userUid', userCredential.user!.uid);
//                         Navigator.of(context).push(MaterialPageRoute(
//                             builder: (context) =>
//                                 HomeScreen(userCredential.user!.uid)));
//                       }
//                     } on FirebaseAuthException catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(e.code),
//                         ),
//                       );
//                     } catch (_) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text("Login failed."),
//                         ),
//                       );
//                     }
//                   },
//                   child: Text("login").tr()),
//             ),
//             SizedBox(
//               height: 24,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                     child: Divider(
//                   thickness: 2,
//                 )),
//                 Text("or").tr(),
//                 Expanded(
//                     child: Divider(
//                   thickness: 2,
//                 )),
//               ],
//             ),
//             SizedBox(
//               height: 24,
//             ),
//             Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
//               ElevatedButton(
//                   onPressed: () {
//                     context.setLocale(Locale("en"));
//                   },
//                   child: Text("English")),
//               ElevatedButton(
//                   onPressed: () {
//                     context.setLocale(Locale("ar"));
//                   },
//                   child: Text("Arabic")),
//             ]),
//             SizedBox(
//               height: 50,
//             ),
//             Center(
//               child: ElevatedButton(
//                   onPressed: () => context.read<ThemeCubit>().toggleTheme(),
//
//                   //themeProvider.toggleTheme,
//                   child: Text("Toogle_Theme").tr()),
//             ),
//             SizedBox(
//               height: 50,
//             ),
//             Center(
//               child: ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => CreateAccountScreen()));
//                   },
//                   child: Text("create_account").tr()),
//             ),
//           ],
//         ));
//   }
// }
