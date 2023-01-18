import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokemon_zukan/constants/pokemon_type.dart';

class HomeStateElement {
  final String name;
  final PokemonType type1;
  final PokemonType? type2;
  final int stage;
  final int form;
  final String imgPath;
  final bool liked;

  const HomeStateElement({
    required this.name,
    required this.type1,
    required this.stage,
    required this.form,
    this.type2,
    required this.imgPath,
    required this.liked,
  });

  HomeStateElement copyFrom({
    String? newName,
    PokemonType? newType1,
    PokemonType? newType2,
    int? newStage,
    int? newForm,
    String? newImgPath,
    bool? newLiked,
  }) {
    return HomeStateElement(
      name: newName ?? name,
      type1: newType1 ?? type1,
      type2: newType2 ?? type2,
      stage: newStage ?? stage,
      form: newForm ?? form,
      imgPath: newImgPath ?? imgPath,
      liked: newLiked ?? liked,
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
    return copyFrom(newIndex: newIndex);
  }

  HomeStateGroup decrement() {
    int newIndex = index - 1;
    if (newIndex == -1) {
      newIndex = pokemons.length - 1;
    }
    return copyFrom(newIndex: newIndex);
  }

  HomeStateGroup copyFrom({
    List<HomeStateElement>? newPokemons,
    String? newGroupId,
    int? newIndex,
  }) {
    return HomeStateGroup(
      pokemons: newPokemons ?? pokemons,
      groupId: newGroupId ?? groupId,
      index: newIndex ?? index,
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

  final bool isReloading;

  const HomeState({
    required this.groups,
    required this.isInitialized,
    required this.isInitializing,
    this.user,
    required this.isMoreLoading,
    required this.noMoreAvailable,
    required this.isReloading,
  });

  HomeState updateAt(int index, {bool decrement = false}) {
    List<HomeStateGroup> newGroups = [...groups];
    newGroups[index] = decrement ? newGroups[index].decrement() : newGroups[index].increment();
    return copyFrom(newGroups: newGroups);
  }

  HomeState copyFrom({
    List<HomeStateGroup>? newGroups,
    bool? newIsInitialized,
    bool? newIsInitializing,
    User? newUser,
    bool? newIsMoreLoading,
    bool? newNoMoreAvailable,
    bool? newIsReloading,
  }) {
    return HomeState(
      groups: newGroups ?? groups,
      isInitialized: newIsInitialized ?? isInitialized,
      isInitializing: newIsInitializing ?? isInitializing,
      user: newUser ?? user,
      isMoreLoading: newIsMoreLoading ?? isMoreLoading,
      noMoreAvailable: newNoMoreAvailable ?? noMoreAvailable,
      isReloading: newIsReloading ?? isReloading,
    );
  }
}
