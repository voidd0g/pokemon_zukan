import 'package:pokemon_zukan/constants/pokemon_type.dart';

class Pokemon {
  Pokemon({
    required this.name,
    required this.type1,
    this.type2,
    required this.stage,
    required this.form,
    required this.imgPath,
  });

  String name;
  PokemonType type1;
  PokemonType? type2;
  int stage;
  int form;
  String imgPath;
}

class PokemonEvoGroup {
  PokemonEvoGroup({
    required this.pokemons,
    required this.groupID,
  });

  List<Pokemon> pokemons;
  String groupID;
}

class EvoGroups {
  EvoGroups({
    required this.groups,
  });

  List<PokemonEvoGroup> groups;
}
