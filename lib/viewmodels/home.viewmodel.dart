import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/repos/pokemon_services.dart';
import 'package:pokemon_zukan/viewmodels/states/home.state.dart';

final homeProvider = StateNotifierProvider.autoDispose<HomeNotifier, HomeState>((ref) => HomeNotifier());

class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier()
      : super(const HomeState(
          groups: [],
          isInitialized: false,
          isInitializing: false,
          user: null,
          isMoreLoading: false,
          noMoreAvailable: false,
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

  Future<bool> isUserLoggedIn() async {
    User? user = (await FirebaseServices.instance.getAuthInstance()).currentUser;
    return user != null;
  }

  Future<void> initialPokemons() async {
    if (state.isInitializing) {
      return;
    }
    await Future.delayed(Duration.zero, () async {
      state = HomeState(
        groups: [],
        isInitialized: false,
        isInitializing: true,
        user: (await FirebaseServices.instance.getAuthInstance()).currentUser,
        isMoreLoading: false,
        noMoreAvailable: false,
      );
    });
    PokemonServicesResult res = await PokemonServices.instance.getPokemonEvoGroups(groupAfter: null);
    if (res.isSuccess) {
      await Future.delayed(Duration.zero, () async {
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
                    groupId: x.groupId,
                  ))
              .toList(),
          isInitialized: true,
          isInitializing: false,
          user: state.user,
          isMoreLoading: false,
          noMoreAvailable: res.evoGroups!.groups.length < PokemonServices.readLimit,
        );
      });
    } else {
      await Future.delayed(Duration.zero, () async {
        state = HomeState(
          groups: [],
          isInitialized: false,
          isInitializing: false,
          user: state.user,
          isMoreLoading: false,
          noMoreAvailable: false,
        );
      });
    }
  }

  Future<void> getMorePokemons() async {
    if (state.isMoreLoading || state.noMoreAvailable) {
      return;
    }
    await Future.delayed(Duration.zero, () async {
      state = HomeState(
        groups: state.groups,
        isInitialized: true,
        isInitializing: false,
        user: state.user,
        isMoreLoading: true,
        noMoreAvailable: false,
      );
    });
    PokemonServicesResult res = await PokemonServices.instance.getPokemonEvoGroups(groupAfter: state.groups.last.groupId);
    if (res.isSuccess) {
      await Future.delayed(Duration.zero, () async {
        List<HomeStateGroup> newGroups = [...state.groups];
        newGroups.addAll(res.evoGroups!.groups.map((x) => HomeStateGroup(
              pokemons: x.pokemons
                  .map((y) => HomeStateElement(
                        name: y.name,
                        type1: y.type1,
                        type2: y.type2,
                        imgPath: y.imgPath,
                      ))
                  .toList(),
              groupId: x.groupId,
            )));
        state = HomeState(
          groups: newGroups,
          isInitialized: true,
          isInitializing: false,
          user: state.user,
          isMoreLoading: false,
          noMoreAvailable: res.evoGroups!.groups.length < PokemonServices.readLimit,
        );
      });
    } else {
      await Future.delayed(Duration.zero, () async {
        state = HomeState(
          groups: state.groups,
          isInitialized: false,
          isInitializing: false,
          user: state.user,
          isMoreLoading: false,
          noMoreAvailable: false,
        );
      });
    }
  }
}
