import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/features/auth/bloc/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService authService;

  LoginCubit(this.authService) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    try {
      emit(LoginLoading());

      final credential = await authService.login(email, password);

      if (credential.user != null) {
        final prefs = await SharedPreferences.getInstance();

        await prefs.setString("userUid", credential.user!.uid);

        emit(LoginSuccess(credential.user!.uid));
      }
    } catch (e) {
      emit(LoginError(e.toString()));
    }
  }
}