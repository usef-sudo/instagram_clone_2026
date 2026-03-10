abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  final String uid;

  SplashAuthenticated(this.uid);
}

class SplashUnauthenticated extends SplashState {}