import 'dart:convert';

import 'package:pokemon_zukan/constants/pokemon_type.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';

Pokemon? pokemonFromJson(String str) => Pokemon.fromJson(json.decode(str));

String pokemonToJson(Pokemon data) => json.encode(data!.toJson());

class Pokemon {
  Pokemon({
    required this.name,
    required this.type1,
    this.type2,
  });

  String name;
  PokemonType type1;
  PokemonType? type2;

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(name: json["name"] as String, type1: pokemonTypeFromString(json["type1"] as String), type2: json["type2"] == null ? null : pokemonTypeFromString(json["type2"] as String));

  Map<String, dynamic> toJson() => {
        "name": name,
        "type1": pokemonTypeToString(type1),
        "type2": type2 == null ? null : pokemonTypeToString(type2!),
      };
}

class PokemonEvoGroup {
  PokemonEvoGroup({
    required this.pokemons,
  });

  List<Pokemon> pokemons;

  factory PokemonEvoGroup.fromJson(Map<String, dynamic> json) => PokemonEvoGroup(pokemons: List<Pokemon>.from((json["pokemons"]!).map((x) => Pokemon.fromJson(x as Map<String, dynamic>))));

  Map<String, dynamic> toJson() => {
        "pokemons": List<Map<String, dynamic>>.from(pokemons.map((x) => x.toJson())),
      };
}

class EvoGroups {
  EvoGroups({
    required this.groups,
  });

  List<PokemonEvoGroup> groups;

  factory EvoGroups.fromJson(Map<String, dynamic> json) => EvoGroups(groups: List<PokemonEvoGroup>.from((json["groups"]!).map((x) => PokemonEvoGroup.fromJson(x as Map<String, dynamic>))));

  Map<String, dynamic> toJson() => {
        "groups": List<Map<String, dynamic>>.from(groups.map((x) => x.toJson())),
      };
}
