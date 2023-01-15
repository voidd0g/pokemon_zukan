import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/pokemon_services.dart';
import 'package:pokemon_zukan/states/home.state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier() : super(const HomeState([], true));

  void revEvolveAt(int index) {
    if (0 <= index && index < state.groups.length) {
      state = state.updateAt(
        index,
        decrement: true,
      );
    }
  }

  void evolveAt(int index) {
    if (0 <= index && index < state.groups.length) {
      state = state.updateAt(
        index,
        decrement: false,
      );
    }
  }

  Future<void> getPokemons() async {
    PokemonServicesResult res = await PokemonServices.getPokemonEvoGroups();
    if (res.isSuccess) {
      state = HomeState(res.evoGroups.groups.map((x) => HomeStateGroup(x.pokemons.map((y) => HomeStateElement(name: y.name, type1: y.type1, type2: y.type2)).toList())).toList(), false);
    } else {
      state = const HomeState([], false);
    }
  }
}
