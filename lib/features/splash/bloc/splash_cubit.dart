import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkLogin() async {
    emit(SplashLoading());

    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();

    String uid = prefs.getString("userUid") ?? "";

    if (uid.isNotEmpty) {
      emit(SplashAuthenticated(uid));
    } else {
      emit(SplashUnauthenticated());
    }
  }
}