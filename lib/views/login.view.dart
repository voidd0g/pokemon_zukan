import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_zukan/constants/routes.dart';
import 'package:pokemon_zukan/viewmodels/login.viewmodel.dart';

class LoginView extends ConsumerWidget {
  const LoginView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final states = ref.watch(loginProvider);
    if (states.isSignedIn) {
      Future.delayed(Duration.zero, () async {
        await Navigator.of(context).pushNamed(Routes.home);
        await ref.read(loginProvider.notifier).loggedOut();
      });
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'ポケモンずかん',
            style: TextStyle(
              color: Colors.blue.shade50,
              fontFamily: 'MPLUSRounded1c',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue.shade700,
        ),
        body: Center(
          child: states.isSigningIn
              ? const SpinKitDualRing(color: Colors.black)
              : states.isSignedIn
                  ? const Text('OK')
                  : ElevatedButton(
                      onPressed: () async {
                        await ref.read(loginProvider.notifier).trySignInWithGoogle();
                      },
                      child: const Icon(Icons.login),
                    ),
        ),
      ),
    );
  }
}
