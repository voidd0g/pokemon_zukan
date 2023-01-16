import 'dart:convert';

import 'package:pokemon_zukan/constants/pokemon_type.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';

Pokemon? pokemonFromJson(String str) => Pokemon.fromJson(json.decode(str));

String pokemonToJson(Pokemon data) => json.encode(data.toJson());

class Pokemon {
  Pokemon({
    required this.name,
    required this.type1,
    this.type2,
    required this.stage,
    required this.form,
  });

  String name;
  PokemonType type1;
  PokemonType? type2;
  int stage;
  int form;

  factory Pokemon.fromJson(Map<String, dynamic> json) => Pokemon(
        name: json["name"] as String,
        type1: pokemonTypeFromString(json["type1"] as String),
        type2: json["type2"] == null ? null : pokemonTypeFromString(json["type2"] as String),
        stage: json["stage"] == null ? 0 : json["stage"] as int,
        form: json["form"] == null ? 0 : json["form"] as int,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type1": pokemonTypeToString(type1),
        "type2": type2 == null ? null : pokemonTypeToString(type2!),
        "stage": stage,
        "form": form,
      };
}

class PokemonEvoGroup {
  PokemonEvoGroup({
    required this.pokemons,
    required this.groupID,
  });

  List<Pokemon> pokemons;
  String groupID;

  factory PokemonEvoGroup.fromJson(Map<String, dynamic> json) => PokemonEvoGroup(
        pokemons: List<Pokemon>.from((json["pokemons"]!).map((x) => Pokemon.fromJson(x as Map<String, dynamic>))),
        groupID: json["id"] as String,
      );

  Map<String, dynamic> toJson() => {
        "pokemons": List<Map<String, dynamic>>.from(pokemons.map((x) => x.toJson())),
        "id": groupID,
      };
}

class EvoGroups {
  EvoGroups({
    required this.groups,
  });

  List<PokemonEvoGroup> groups;

  factory EvoGroups.fromJson(Map<String, dynamic> json) => EvoGroups(
        groups: List<PokemonEvoGroup>.from((json["groups"]!).map((x) => PokemonEvoGroup.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "groups": List<Map<String, dynamic>>.from(groups.map((x) => x.toJson())),
      };
}
