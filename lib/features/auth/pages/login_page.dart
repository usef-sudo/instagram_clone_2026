import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/bloc/auth_service.dart';
import 'package:instagram_clone/features/auth/bloc/login_cubit.dart';
import 'package:instagram_clone/features/auth/bloc/login_state.dart';
import 'package:instagram_clone/features/auth/pages/forget_password_screen.dart';
import 'package:instagram_clone/features/auth/widgets/app_text_field.dart';
import 'package:instagram_clone/features/auth/widgets/primary_button.dart';
import 'package:instagram_clone/features/splash/widgets/app_logo.dart';
import 'package:instagram_clone/presentation/pages/create_account_screen.dart';
import 'package:instagram_clone/presentation/pages/forget_password_screen.dart';
import 'package:instagram_clone/presentation/pages/home_screen.dart';
import 'package:instagram_clone/providers/theme_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(AuthService()),
      child: Scaffold(
        appBar: AppBar(
          title: Text("login_screen").tr(),
        ),
        body: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => HomeScreen(state.uid),
                ),
              );
            }

            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<LoginCubit>();

            return SingleChildScrollView(
              child: Column(
                children: [

                  const SizedBox(height: 30),

                  const AppLogo(),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: emailController,
                    label: "email".tr(),
                  ),

                  AppTextField(
                    controller: passwordController,
                    label: "password".tr(),
                    obscure: true,
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ForgetScreen(),
                        ),
                      );
                    },
                    child: Text("forgot_password").tr(),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: PrimaryButton(
                      loading: state is LoginLoading,
                      title: "login".tr(),
                      onPressed: () {
                        cubit.login(
                          emailController.text.trim(),
                          passwordController.text.trim(),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text("or").tr(),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      ElevatedButton(
                        onPressed: () {
                          context.setLocale(const Locale("en"));
                        },
                        child: const Text("English"),
                      ),

                      const SizedBox(width: 10),

                      ElevatedButton(
                        onPressed: () {
                          context.setLocale(const Locale("ar"));
                        },
                        child: const Text("Arabic"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () =>
                        context.read<ThemeCubit>().toggleTheme(),
                    child: Text("Toogle_Theme").tr(),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CreateAccountScreen(),
                        ),
                      );
                    },
                    child: Text("create_account").tr(),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}