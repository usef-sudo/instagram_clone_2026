import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/bloc/register_cubit.dart';
import 'package:instagram_clone/features/auth/bloc/register_state.dart';
import 'package:instagram_clone/features/auth/pages/login_page.dart';
import 'package:instagram_clone/features/auth/widgets/app_text_field.dart';
import 'package:instagram_clone/features/auth/widgets/primary_button.dart';
import 'package:instagram_clone/features/splash/widgets/app_logo.dart';
import 'package:instagram_clone/presentation/pages/login_screen.dart';

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create New Account"),
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Account created successfully ✅"),
                ),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            }

            if (state is RegisterError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<RegisterCubit>();

            return SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    const AppLogo(),
                    const SizedBox(height: 20),
                    AppTextField(
                      controller: emailController,
                      label: "Email",
                    ),
                    AppTextField(
                      controller: nameController,
                      label: "Full Name",
                    ),
                    AppTextField(
                      controller: passwordController,
                      label: "Password",
                      obscure: true,
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: PrimaryButton(
                        title: "Create Account",
                        loading: state is RegisterLoading,
                        onPressed: () {
                          if (!formKey.currentState!.validate()) return;

                          cubit.register(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            name: nameController.text.trim(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 30),
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
