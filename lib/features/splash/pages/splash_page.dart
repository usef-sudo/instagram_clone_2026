import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/pages/login_page.dart';
import 'package:instagram_clone/features/splash/bloc/splash_cubit.dart';
import 'package:instagram_clone/features/splash/bloc/splash_state.dart';
import 'package:instagram_clone/features/splash/widgets/app_logo.dart';
import 'package:instagram_clone/presentation/pages/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..checkLogin(),
      child: const SplashView(),
    );
  }
}

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is SplashAuthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(state.uid),
              ),
            );
          }

          if (state is SplashUnauthenticated) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) =>  LoginScreen(),
              ),
            );
          }
        },
        child: const Center(
          child: AppLogo(),
        ),
      ),
    );
  }
}