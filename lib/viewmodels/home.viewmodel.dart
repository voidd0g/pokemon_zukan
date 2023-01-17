import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/repos/pokemon_services.dart';
import 'package:pokemon_zukan/viewmodels/states/home.state.dart';

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

  Future<void> logOut() async {
    await FirebaseServices.instance.signOutWithGoogle();
  }

  Future<void> getPokemons({bool force = false}) async {
    if (state.isInitializing) {
      return;
    }
    await Future.delayed(Duration.zero, () {
      state = HomeState(
        groups: [],
        isInitialized: false,
        isInitializing: true,
        user: state.user,
      );
    });
    User? user = (await FirebaseServices.instance.getAuthInstance()).currentUser;
    if (user != null) {
      await Future.delayed(Duration.zero, () {
        state = HomeState(
          groups: [],
          isInitialized: false,
          isInitializing: true,
          user: user,
        );
      });
      PokemonServicesResult res = await PokemonServices.instance.getPokemonEvoGroups(force: force);
      if (res.isSuccess) {
        await Future.delayed(Duration.zero, () {
          state = HomeState(
            groups: res.evoGroups!.groups
                .map((x) => HomeStateGroup(
                      pokemons: x.pokemons
                          .map((y) => HomeStateElement(
                                name: y.name,
                                type1: y.type1,
                                type2: y.type2,
                                imgPath: y.imgPath,
                              ))
                          .toList(),
                      basicName: x.groupID,
                    ))
                .toList(),
            isInitialized: true,
            isInitializing: false,
            user: state.user,
          );
        });
      } else {
        await Future.delayed(Duration.zero, () {
          state = HomeState(
            groups: [],
            isInitialized: false,
            isInitializing: false,
            user: state.user,
          );
        });
      }
    }
  }
}
