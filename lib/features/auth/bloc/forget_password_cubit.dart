import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(ForgetPasswordInitial());

  Future<void> resetPassword(String email) async {
    try {
      emit(ForgetPasswordLoading());

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      emit(ForgetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ForgetPasswordError(e.message ?? "Reset failed"));
    } catch (_) {
      emit(ForgetPasswordError("Something went wrong"));
    }
  }
}