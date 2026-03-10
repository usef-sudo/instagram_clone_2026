import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/bloc/forget_password_cubit.dart';
import 'package:instagram_clone/features/auth/bloc/forget_password_state.dart';
import 'package:instagram_clone/features/auth/widgets/app_text_field.dart';
import 'package:instagram_clone/features/auth/widgets/primary_button.dart';
import 'package:instagram_clone/features/splash/widgets/app_logo.dart';

class ForgetScreen extends StatelessWidget {
  ForgetScreen({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ForgetPasswordCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Forget Password"),
        ),
        body: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
          listener: (context, state) {
            if (state is ForgetPasswordSuccess) {
              emailController.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Password reset email sent!"),
                ),
              );
            }

            if (state is ForgetPasswordError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ForgetPasswordCubit>();

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [

                    const AppLogo(),

                    const SizedBox(height: 30),

                    AppTextField(
                      controller: emailController,
                      label: "Email",
                    ),

                    const SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PrimaryButton(
                        title: "Reset Password",
                        loading: state is ForgetPasswordLoading,
                        onPressed: () {
                          cubit.resetPassword(
                            emailController.text.trim(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}