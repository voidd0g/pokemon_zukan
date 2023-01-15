import 'dart:convert';

import 'package:pokemon_zukan/models/pokemon.dart';

class PokemonServices {
  static Future<PokemonServicesResult> getPokemonEvoGroups() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    return PokemonServicesResult(
      true,
      EvoGroups.fromJson(jsonDecode('''
        {
          "groups": 
            [
              {
                "pokemons": 
                  [
                    {
                      "name": "コライドン",
                      "type1": "dragon",
                      "type2": "fighting"
                    }
                  ]
              },
              {
                "pokemons": 
                  [
                    {
                      "name": "ピチュー",
                      "type1": "electric",
                      "type2": null
                    },
                    {
                      "name": "ピカチュウ",
                      "type1": "electric",
                      "type2": null
                    },
                    {
                      "name": "ライチュウ",
                      "type1": "electric",
                      "type2": null
                    }
                  ]
              }
            ]
        }''')),
    );
  }
}

class PokemonServicesResult {
  final bool isSuccess;
  final EvoGroups evoGroups;

  const PokemonServicesResult(this.isSuccess, this.evoGroups);
}
