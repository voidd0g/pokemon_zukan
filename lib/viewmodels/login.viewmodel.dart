import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/viewmodels/states/login.state.dart';

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>((ref) => LoginNotifier());

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier()
      : super(const LoginState(
          isInitialized: false,
          isSigningIn: false,
          isSignedIn: false,
          isFailed: false,
        ));

  Future<void> trySignInWithGoogle() async {
    await Future.delayed(Duration.zero, () {
      state = const LoginState(
        isInitialized: true,
        isSigningIn: true,
        isSignedIn: false,
        isFailed: false,
      );
    });
    bool res = await FirebaseServices.instance.trySignInWithGoogle();
    await Future.delayed(Duration.zero, () {
      state = LoginState(
        isInitialized: true,
        isSigningIn: false,
        isSignedIn: res,
        isFailed: !res,
      );
    });
  }

  Future<bool> isUserLoggedIn() async {
    User? user = (await FirebaseServices.instance.getAuthInstance()).currentUser;
    return user != null;
  }

  Future<void> initialized() async {
    await Future.delayed(Duration.zero, () {
      state = const LoginState(
        isInitialized: true,
        isSigningIn: false,
        isSignedIn: false,
        isFailed: false,
      );
    });
  }

  Future<void> loggedOut() async {
    await Future.delayed(Duration.zero, () {
      state = const LoginState(
        isInitialized: true,
        isSigningIn: false,
        isSignedIn: false,
        isFailed: false,
      );
    });
  }
}
