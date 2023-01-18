import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_zukan/constants/routes.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';
import 'package:pokemon_zukan/viewmodels/home.viewmodel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final states = ref.watch(homeProvider);
    Future.delayed(Duration.zero, () async {
      if (await ref.read(homeProvider.notifier).isUserLoggedIn()) {
        if (!states.isInitialized && !states.isInitializing) {
          await ref.read(homeProvider.notifier).initialPokemons();
        }
      } else {
        Future.delayed(Duration.zero, () async {
          if (ModalRoute.of(context)?.canPop == true) {
            Future.delayed(Duration.zero, () async {
              Navigator.of(context).pop();
            });
          } else {
            Future.delayed(Duration.zero, () async {
              Navigator.of(context).pushReplacementNamed(Routes.login);
            });
          }
        });
      }
    });

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
                    child: CachedNetworkImage(
                      imageUrl: 'https://zukan.pokemon.co.jp/zukan-api/up/images/index/${entry.value.pokemons[entry.value.index].imgPath}.png',
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
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
                          pokemonTypeToString(entry.value.pokemons[entry.value.index].type1),
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
                                pokemonTypeToString(entry.value.pokemons[entry.value.index].type2!),
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
                                    shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                        )),
                                  ),
                                  child: const Icon(Icons.navigate_before)),
                              const SizedBox(
                                width: 20.0,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    ref.read(homeProvider.notifier).evolveAt(entry.key);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.blue.shade400),
                                    shape: MaterialStateProperty.resolveWith((states) => const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(100)),
                                        )),
                                  ),
                                  child: const Icon(Icons.navigate_next)),
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
                    'Click here to read some more!',
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
          actions: [
            ElevatedButton(
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
                  await ref.read(homeProvider.notifier).logOut();
                  Future.delayed(Duration.zero, () async {
                    if (!(await Navigator.of(context).maybePop())) {
                      Future.delayed(Duration.zero, () async {
                        Navigator.of(context).pushNamed(Routes.login);
                      });
                    }
                  });
                }
              },
              child: const Icon(Icons.logout),
            ),
          ],
        ),
        body: !states.isInitialized || states.user == null
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
        floatingActionButton: !states.isInitialized || states.user == null
            ? const SizedBox.shrink()
            : FloatingActionButton(
                onPressed: () async {
                  ref.read(homeProvider.notifier).initialPokemons();
                },
                child: const Icon(Icons.refresh),
              ),
      ),
    );
  }
}
