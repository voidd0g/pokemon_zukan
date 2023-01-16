import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/viewmodels/states/login.state.dart';

final loginProvider = StateNotifierProvider<LoginNotifier, LoginState>((ref) => LoginNotifier());

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier()
      : super(const LoginState(
          isSigningIn: false,
          isSignedIn: false,
        ));

  Future<void> trySignInWithGoogle() async {
    await Future.delayed(Duration.zero, () {
      state = const LoginState(
        isSigningIn: true,
        isSignedIn: false,
      );
    });
    bool res = await FirebaseServices.instance.trySignInWithGoogle();
    await Future.delayed(Duration.zero, () {
      state = LoginState(
        isSigningIn: false,
        isSignedIn: res,
      );
    });
  }

  Future<void> loggedOut() async {
    await Future.delayed(Duration.zero, () {
      state = const LoginState(
        isSigningIn: false,
        isSignedIn: false,
      );
    });
  }
}
