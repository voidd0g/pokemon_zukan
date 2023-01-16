import 'dart:convert';
import 'dart:math';

import 'package:pokemon_zukan/models/pokemon.dart';

class PokemonServices {
  static final PokemonServices _instance = PokemonServices._();
  static PokemonServices get instance => _instance;
  PokemonServicesResult? _result;

  PokemonServices._();

  Future<PokemonServicesResult> getPokemonEvoGroups({bool force = false}) async {
    if (force || _result == null) {
      await Future.delayed(const Duration(milliseconds: 200), () {});
      _result = PokemonServicesResult(
        Random().nextInt(10) == 0,
        EvoGroups.fromJson(jsonDecode('''
        {
          "groups": 
            [
              {
                "basic_name": "コライドン",
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
                "basic_name": "ピチュー",
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
              },
              {
                "basic_name": "パモ",
                "pokemons": 
                  [
                    {
                      "name": "パモ",
                      "type1": "electric",
                      "type2": null
                    },
                    {
                      "name": "パモット",
                      "type1": "electric",
                      "type2": "fighting"
                    },
                    {
                      "name": "パーモット",
                      "type1": "electric",
                      "type2": "fighting"
                    }
                  ]
              }
            ]
        }''')),
      );
    }
    return _result!;
  }
}

class PokemonServicesResult {
  final bool isSuccess;
  final EvoGroups evoGroups;

  const PokemonServicesResult(this.isSuccess, this.evoGroups);
}
