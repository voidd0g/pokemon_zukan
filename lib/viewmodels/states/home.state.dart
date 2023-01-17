import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokemon_zukan/constants/pokemon_type.dart';

class HomeStateElement {
  final String name;
  final PokemonType type1;
  final PokemonType? type2;
  final String imgPath;

  const HomeStateElement({
    required this.name,
    required this.type1,
    this.type2,
    required this.imgPath,
  });

  HomeStateElement copyFrom({
    String? newName,
    PokemonType? newType1,
    PokemonType? newType2,
    String? newImgPath,
  }) {
    return HomeStateElement(
      name: newName ?? name,
      type1: newType1 ?? type1,
      type2: newType2 ?? type2,
      imgPath: newImgPath ?? imgPath,
    );
  }
}

class HomeStateGroup {
  final List<HomeStateElement> pokemons;
  final String groupId;
  final int index;

  const HomeStateGroup({
    required this.pokemons,
    required this.groupId,
    this.index = 0,
  });

  HomeStateGroup increment() {
    int newIndex = index + 1;
    if (newIndex == pokemons.length) {
      newIndex = 0;
    }
    return HomeStateGroup(
      pokemons: pokemons,
      groupId: groupId,
      index: newIndex,
    );
  }

  HomeStateGroup decrement() {
    int newIndex = index - 1;
    if (newIndex == -1) {
      newIndex = pokemons.length - 1;
    }
    return HomeStateGroup(
      pokemons: pokemons,
      groupId: groupId,
      index: newIndex,
    );
  }
}

class HomeState {
  final List<HomeStateGroup> groups;
  final bool isInitialized;
  final bool isInitializing;
  final User? user;

  final bool isMoreLoading;

  final bool noMoreAvailable;

  const HomeState({
    required this.groups,
    required this.isInitialized,
    required this.isInitializing,
    this.user,
    required this.isMoreLoading,
    required this.noMoreAvailable,
  });

  HomeState updateAt(int index, {bool decrement = false}) {
    List<HomeStateGroup> newGroups = [...groups];
    newGroups[index] = decrement ? newGroups[index].decrement() : newGroups[index].increment();
    return HomeState(
      groups: newGroups,
      isInitialized: isInitialized,
      isInitializing: isInitializing,
      user: user,
      isMoreLoading: isMoreLoading,
      noMoreAvailable: noMoreAvailable,
    );
  }
}
