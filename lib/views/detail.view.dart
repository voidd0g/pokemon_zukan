import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_zukan/args/detail.args.dart';
import 'package:pokemon_zukan/constants/routes.dart';
import 'package:pokemon_zukan/viewmodels/detail.viewmodel.dart';

class DetailView extends ConsumerWidget {
  const DetailView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final states = ref.watch(detailProvider);
    Future.delayed(Duration.zero, () async {
      if (!await ref.read(detailProvider.notifier).isUserLoggedIn()) {
        if (ModalRoute.of(context)?.canPop == true) {
          await Future.delayed(Duration.zero, () async {
            Navigator.of(context).pop();
          });
        } else {
          await Future.delayed(Duration.zero, () async {
            Navigator.of(context).pushReplacementNamed(Routes.login);
          });
        }
      }
    });

    if (!states.isInitialized) {
      Future.delayed(Duration.zero, () async {
        if (await ref.read(detailProvider.notifier).isUserLoggedIn()) {
          await Future.delayed(Duration.zero, () async {
            await ref.read(detailProvider.notifier).initialized();
          });
        }
      });
    }

    final Object? argsRaw = ModalRoute.of(context)?.settings.arguments;
    Widget body;
    if (argsRaw == null || argsRaw is! DetailArgs) {
      Future.delayed(Duration.zero, () async {
        Navigator.of(context).pop();
      });
      body = const SizedBox.shrink();
    } else {
      final DetailArgs args = argsRaw;
      body = !states.isInitialized
          ? const SpinKitDualRing(color: Colors.black)
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  states.isSettingLike
                      ? SpinKitFadingGrid(color: Colors.blue.shade700)
                      : TextButton(
                          onPressed: () async {
                            await Future.delayed(Duration.zero, () async {
                              ref.read(detailProvider.notifier).setLike(
                                    toSet: true,
                                    groupId: args.groupName,
                                    stage: args.stage,
                                    form: args.form,
                                  );
                            });
                          },
                          child: Text(
                            '${args.pokemonName}に💛をつける',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontFamily: 'MPLUSRounded1c',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  states.isSettingLike
                      ? SpinKitFadingGrid(color: Colors.blue.shade700)
                      : TextButton(
                          onPressed: () async {
                            await Future.delayed(Duration.zero, () async {
                              ref.read(detailProvider.notifier).setLike(
                                    toSet: false,
                                    groupId: args.groupName,
                                    stage: args.stage,
                                    form: args.form,
                                  );
                            });
                          },
                          child: Text(
                            '${args.pokemonName}から💛をはずす',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontFamily: 'MPLUSRounded1c',
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextButton(
                    onPressed: () async {
                      await Future.delayed(Duration.zero, () async {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      'もどる',
                      style: TextStyle(
                        color: Colors.blue.shade700,
                        fontFamily: 'MPLUSRounded1c',
                        fontSize: 20.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            );
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
        body: body,
      ),
    );
  }
}
