import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';
import 'package:pokemon_zukan/viewmodels/home.viewmodel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final states = ref.watch(homeProvider);
    if (!states.isInitialized && !states.isInitializing) {
      ref.read(homeProvider.notifier).getPokemons(force: true);
    } else if (states.isInitialized && states.user == null) {
      Future.delayed(Duration.zero, () async {
        Navigator.of(context).pop();
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
          actions: [
            ElevatedButton(
              onPressed: () async {
                await ref.read(homeProvider.notifier).logOut();
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
              },
              child: const Icon(Icons.logout),
            ),
          ],
        ),
        body: !states.isInitialized
            ? Center(
                child: SpinKitDancingSquare(
                  color: Colors.blue.shade700,
                ),
              )
            : Center(
                child: Container(
                  color: Colors.blue.shade200,
                  child: ListView(
                    children: states.groups
                        .asMap()
                        .entries
                        .map((entry) => Padding(
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          entry.value.pokemons[entry.value.index].name,
                                          style: TextStyle(
                                            color: Colors.blue.shade800,
                                            fontFamily: 'MPLUSRounded1c',
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.normal,
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
                                    entry.value.pokemons.length > 1
                                        ? Row(
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
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
        floatingActionButton: !states.isInitialized
            ? const SizedBox.shrink()
            : FloatingActionButton(
                onPressed: () async {
                  ref.read(homeProvider.notifier).getPokemons(force: true);
                },
                child: const Icon(Icons.refresh),
              ),
      ),
    );
  }
}
