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
    if (!states.isInitialized) {
      Future.delayed(Duration.zero, () async {
        if (!await ref.read(loginProvider.notifier).isUserLoggedIn()) {
          await Future.delayed(Duration.zero, () async {
            await ref.read(loginProvider.notifier).initialized();
          });
        }
      });
    }
    if (states.isSignedIn) {
      Future.delayed(Duration.zero, () async {
        await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(
                  'ログイン成功',
                  style: TextStyle(
                    color: Colors.blue.shade500,
                    fontFamily: 'MPLUSRounded1c',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.blue.shade500,
                        fontFamily: 'MPLUSRounded1c',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            });
        await Future.delayed(Duration.zero, () async {
          await Navigator.of(context).pushNamed(Routes.home);
          await ref.read(loginProvider.notifier).loggedOut();
        });
      });
    } else if (states.isFailed) {
      Future.delayed(Duration.zero, () async {
        await showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(
                  'ログイン失敗',
                  style: TextStyle(
                    color: Colors.blue.shade500,
                    fontFamily: 'MPLUSRounded1c',
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.blue.shade500,
                        fontFamily: 'MPLUSRounded1c',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            });
      });
    } else {
      Future.delayed(Duration.zero, () async {
        if (await ref.read(loginProvider.notifier).isUserLoggedIn()) {
          await Future.delayed(Duration.zero, () async {
            await Navigator.of(context).pushNamed(Routes.home);
            await ref.read(loginProvider.notifier).loggedOut();
          });
        }
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
          child: states.isSigningIn || !states.isInitialized
              ? const SpinKitDualRing(color: Colors.black)
              : states.isSignedIn
                  ? const SizedBox.shrink()
                  : ElevatedButton(
                      onPressed: () async {
                        await ref.read(loginProvider.notifier).trySignInWithGoogle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.login),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Googleでログイン',
                            style: TextStyle(
                              color: Colors.blue.shade50,
                              fontFamily: 'MPLUSRounded1c',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}
