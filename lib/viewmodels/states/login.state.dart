class LoginState {
  final bool isInitialized;
  final bool isSigningIn;
  final bool isSignedIn;
  final bool isFailed;
  const LoginState({
    required this.isInitialized,
    required this.isSigningIn,
    required this.isSignedIn,
    required this.isFailed,
  });

  LoginState copyFrom({
    bool? newIsInitialized,
    bool? newIsSigningIn,
    bool? newIsSignedIn,
    bool? newIsFailed,
  }) {
    return LoginState(
      isInitialized: newIsInitialized ?? isInitialized,
      isSigningIn: newIsSigningIn ?? isSigningIn,
      isSignedIn: newIsSignedIn ?? isSignedIn,
      isFailed: newIsFailed ?? isFailed,
    );
  }
}
