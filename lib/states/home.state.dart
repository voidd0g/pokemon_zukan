import 'package:pokemon_zukan/constants/pokemon_type.dart';

class HomeStateElement {
  final String name;
  final PokemonType type1;
  final PokemonType? type2;

  const HomeStateElement({
    required this.name,
    required this.type1,
    this.type2,
  });

  HomeStateElement copyFrom({
    String? newName,
    PokemonType? newType1,
    PokemonType? newType2,
    bool? newInEvoGroup,
  }) {
    return HomeStateElement(
      name: newName ?? name,
      type1: newType1 ?? type1,
      type2: newType2 ?? type2,
    );
  }
}

class HomeStateGroup {
  final List<HomeStateElement> pokemons;
  final int index;

  const HomeStateGroup(this.pokemons, {this.index = 0});

  HomeStateGroup increment() {
    int newIndex = index + 1;
    if (newIndex == pokemons.length) {
      newIndex = 0;
    }
    return HomeStateGroup(pokemons, index: newIndex);
  }

  HomeStateGroup decrement() {
    int newIndex = index - 1;
    if (newIndex == -1) {
      newIndex = pokemons.length - 1;
    }
    return HomeStateGroup(pokemons, index: newIndex);
  }
}

class HomeState {
  final List<HomeStateGroup> groups;
  final bool isLoading;

  const HomeState(this.groups, this.isLoading);

  HomeState updateAt(int index, {bool decrement = false}) {
    List<HomeStateGroup> newGroups = [...groups];
    newGroups[index] = decrement ? newGroups[index].decrement() : newGroups[index].increment();
    return HomeState(newGroups, isLoading);
  }
}
