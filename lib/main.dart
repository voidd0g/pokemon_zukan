import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/constants/routes.dart';
import 'package:pokemon_zukan/views/home.view.dart';
import 'package:pokemon_zukan/views/login.view.dart';

void main() {
  runApp(const ProviderScope(
    child: PokemonZukan(),
  ));
}

class PokemonZukan extends StatelessWidget {
  const PokemonZukan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ポケモンずかん',
      initialRoute: Routes.login,
      routes: {
        Routes.login: (context) => const LoginView(),
        Routes.home: (context) => const HomeView(),
      },
    );
  }
}
