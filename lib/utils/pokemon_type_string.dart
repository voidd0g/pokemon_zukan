import 'package:pokemon_zukan/constants/pokemon_type.dart';

String pokemonTypeToString({required PokemonType type}) {
  switch (type) {
    case PokemonType.normal:
      return 'ノーマル';
    case PokemonType.fire:
      return 'ほのお';
    case PokemonType.water:
      return 'みず';
    case PokemonType.grass:
      return 'くさ';
    case PokemonType.electric:
      return 'でんき';
    case PokemonType.ice:
      return 'こおり';
    case PokemonType.fighting:
      return 'かくとう';
    case PokemonType.poison:
      return 'どく';
    case PokemonType.ground:
      return 'じめん';
    case PokemonType.flying:
      return 'ひこう';
    case PokemonType.psychic:
      return 'エスパー';
    case PokemonType.bug:
      return 'むし';
    case PokemonType.rock:
      return 'いわ';
    case PokemonType.ghost:
      return 'ゴースト';
    case PokemonType.dark:
      return 'あく';
    case PokemonType.dragon:
      return 'ドラゴン';
    case PokemonType.steel:
      return 'はがね';
    case PokemonType.fairy:
      return 'フェアリー';
  }
}

PokemonType pokemonTypeFromString({required String type}) {
  switch (type) {
    case 'ノーマル':
    case 'normal':
      return PokemonType.normal;
    case 'ほのお':
    case 'fire':
      return PokemonType.fire;
    case 'みず':
    case 'water':
      return PokemonType.water;
    case 'くさ':
    case 'grass':
      return PokemonType.grass;
    case 'でんき':
    case 'electric':
      return PokemonType.electric;
    case 'こおり':
    case 'ice':
      return PokemonType.ice;
    case 'かくとう':
    case 'fighting':
      return PokemonType.fighting;
    case 'どく':
    case 'poison':
      return PokemonType.poison;
    case 'じめん':
    case 'ground':
      return PokemonType.ground;
    case 'ひこう':
    case 'flying':
      return PokemonType.flying;
    case 'エスパー':
    case 'psychic':
      return PokemonType.psychic;
    case 'むし':
    case 'bug':
      return PokemonType.bug;
    case 'いわ':
    case 'rock':
      return PokemonType.rock;
    case 'ゴースト':
    case 'ghost':
      return PokemonType.ghost;
    case 'あく':
    case 'dark':
      return PokemonType.dark;
    case 'ドラゴン':
    case 'dragon':
      return PokemonType.dragon;
    case 'はがね':
    case 'steel':
      return PokemonType.steel;
    case 'フェアリー':
    case 'fairy':
      return PokemonType.fairy;
  }
  throw Exception('Invalid String for PokemonType');
}
