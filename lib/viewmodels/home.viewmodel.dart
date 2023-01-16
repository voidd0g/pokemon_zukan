import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/pokemon_services.dart';
import 'package:pokemon_zukan/states/home.state.dart';

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
      : super(const HomeState(
          groups: [],
          isInitialized: false,
          isInitializing: false,
        ));

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

  Future<void> getPokemons({bool force = false}) async {
    if (state.isInitializing) {
      return;
    }
    await Future.delayed(Duration.zero, () {
      state = const HomeState(
        groups: [],
        isInitialized: false,
        isInitializing: true,
      );
    });
    PokemonServicesResult res = await PokemonServices.instance.getPokemonEvoGroups(force: force);
    if (res.isSuccess) {
      await Future.delayed(Duration.zero, () {
        state = HomeState(
          groups: res.evoGroups.groups
              .map((x) => HomeStateGroup(
                    pokemons: x.pokemons
                        .map((y) => HomeStateElement(
                              name: y.name,
                              type1: y.type1,
                              type2: y.type2,
                            ))
                        .toList(),
                    basicName: x.basicName,
                  ))
              .toList(),
          isInitialized: true,
          isInitializing: false,
        );
      });
    } else {
      await Future.delayed(Duration.zero, () {
        state = const HomeState(
          groups: [],
          isInitialized: false,
          isInitializing: false,
        );
      });
    }
  }
}
