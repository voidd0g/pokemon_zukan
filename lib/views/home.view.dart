import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_zukan/args/detail.args.dart';
import 'package:pokemon_zukan/constants/routes.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';
import 'package:pokemon_zukan/utils/pokemon_zukan_image_path.dart';
import 'package:pokemon_zukan/viewmodels/home.viewmodel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final states = ref.watch(homeProvider);
    Future.delayed(Duration.zero, () async {
      if (!await ref.read(homeProvider.notifier).isUserLoggedIn()) {
        await Future.delayed(Duration.zero, () async {
          if (ModalRoute.of(context)?.canPop == true) {
            await Future.delayed(Duration.zero, () async {
              Navigator.of(context).pop();
            });
          } else {
            await Future.delayed(Duration.zero, () async {
              Navigator.of(context).pushReplacementNamed(Routes.login);
            });
          }
        });
      }
    });

    if (!states.isInitialized && !states.isInitializing) {
      Future.delayed(Duration.zero, () async {
        if (await ref.read(homeProvider.notifier).isUserLoggedIn()) {
          await ref.read(homeProvider.notifier).initialPokemons();
        }
      });
    }

    List<Widget> listViewElements = states.groups
        .asMap()
        .entries
        .map<Widget>(
          (entry) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: Column(
                children: [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: GestureDetector(
                      onTap: () async {
                        await Future.delayed(Duration.zero, () async {
                          await Navigator.of(context).pushNamed(
                            Routes.detail,
                            arguments: DetailArgs(
                              pokemonName: entry.value.pokemons[entry.value.index].name,
                              groupName: entry.value.groupId,
                              stage: entry.value.pokemons[entry.value.index].stage,
                              form: entry.value.pokemons[entry.value.index].form,
                            ),
                          );
                          await ref.read(homeProvider.notifier).reloadLikes();
                        });
                      },
                      child: CachedNetworkImage(
                        imageUrl: pokemonZukanImagePath(name: entry.value.pokemons[entry.value.index].imgPath),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        entry.value.pokemons[entry.value.index].liked
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent.shade700,
                                    size: 18.0,
                                  ),
                                  Text(
                                    entry.value.pokemons[entry.value.index].name,
                                    style: TextStyle(
                                      color: Colors.amberAccent.shade700,
                                      fontFamily: 'MPLUSRounded1c',
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                entry.value.pokemons[entry.value.index].name,
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontFamily: 'MPLUSRounded1c',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        const SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          pokemonTypeToString(type: entry.value.pokemons[entry.value.index].type1),
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontFamily: 'MPLUSRounded1c',
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        entry.value.pokemons[entry.value.index].type2 != null
                            ? const SizedBox(
                                width: 20.0,
                              )
                            : const SizedBox.shrink(),
                        entry.value.pokemons[entry.value.index].type2 != null
                            ? Text(
                                pokemonTypeToString(type: entry.value.pokemons[entry.value.index].type2!),
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontFamily: 'MPLUSRounded1c',
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  entry.value.pokemons.length > 1
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(homeProvider.notifier).revEvolveAt(entry.key);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue.shade400),
                                  shape: MaterialStateProperty.resolveWith(
                                    (states) => const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                                child: const Icon(Icons.navigate_before),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  ref.read(homeProvider.notifier).evolveAt(entry.key);
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue.shade400),
                                  shape: MaterialStateProperty.resolveWith(
                                    (states) => const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                                child: const Icon(Icons.navigate_next),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        )
        .toList();
    if (!states.noMoreAvailable) {
      listViewElements.add(
        states.isMoreLoading
            ? SpinKitDancingSquare(
                color: Colors.blue.shade700,
              )
            : Center(
                child: GestureDetector(
                  onTap: () async {
                    await ref.read(homeProvider.notifier).getMorePokemons();
                  },
                  child: Text(
                    'もっと読み込む',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontFamily: 'MPLUSRounded1c',
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
        endDrawer: !states.isInitialized
            ? SpinKitFadingFour(
                color: Colors.blue.shade700,
              )
            : Drawer(
                child: ListView(
                  children: [
                    DrawerHeader(
                      child: Center(
                        child: Text(
                          states.user!.displayName!,
                          style: TextStyle(
                            color: Colors.blue.shade500,
                            fontFamily: 'MPLUSRounded1c',
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                        onPressed: () async {
                          final bool? isConfirmed = await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    'ログアウト',
                                    style: TextStyle(
                                      color: Colors.blue.shade500,
                                      fontFamily: 'MPLUSRounded1c',
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: Text(
                                    'ログアウトしますか？',
                                    style: TextStyle(
                                      color: Colors.blue.shade500,
                                      fontFamily: 'MPLUSRounded1c',
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text(
                                        'はい',
                                        style: TextStyle(
                                          color: Colors.blue.shade500,
                                          fontFamily: 'MPLUSRounded1c',
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: Text(
                                        'いいえ',
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
                          if (isConfirmed == true) {
                            await Future.delayed(Duration.zero, () async {
                              Navigator.of(context).pop();
                            });
                            await ref.read(homeProvider.notifier).logOut();
                            await Future.delayed(Duration.zero, () async {
                              if (ModalRoute.of(context)?.canPop == true) {
                                await Future.delayed(Duration.zero, () async {
                                  Navigator.of(context).pop();
                                });
                              } else {
                                await Future.delayed(Duration.zero, () async {
                                  Navigator.of(context).pushReplacementNamed(Routes.login);
                                });
                              }
                            });
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.logout),
                            Text(
                              'ログアウト',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                fontFamily: 'MPLUSRounded1c',
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
        body: !states.isInitialized || states.isReloading
            ? Center(
                child: SpinKitDancingSquare(
                  color: Colors.blue.shade700,
                ),
              )
            : Center(
                child: Container(
                  color: Colors.blue.shade200,
                  child: ListView(
                    children: listViewElements,
                  ),
                ),
              ),
      ),
    );
  }
}
