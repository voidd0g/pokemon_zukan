import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/repos/like_services.dart';
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
          isReloading: false,
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
      state = state.copyFrom(
        newIsInitializing: true,
        newUser: (await FirebaseServices.instance.getAuthInstance()).currentUser,
      );
    });
    PokemonServicesResult res = await PokemonServices.instance.getPokemonEvoGroups(groupAfter: null);
    if (res.isSuccess) {
      await Future.delayed(Duration.zero, () async {
        List<Future<HomeStateGroup>> groupsFuture = res.evoGroups!.groups.map((x) async {
          List<Future<HomeStateElement>> pokemonsFuture = x.pokemons.map((y) async {
            bool liked = await LikeServices.instance.getLike(groupId: x.groupId, stage: y.stage, form: y.form);
            return HomeStateElement(
              name: y.name,
              type1: y.type1,
              type2: y.type2,
              stage: y.stage,
              form: y.form,
              imgPath: y.imgPath,
              liked: liked,
            );
          }).toList();
          List<HomeStateElement> pokemons = [];
          for (var pokemon in pokemonsFuture) {
            pokemons.add(await pokemon);
          }
          return HomeStateGroup(
            pokemons: pokemons,
            groupId: x.groupId,
          );
        }).toList();
        List<HomeStateGroup> groups = [];
        for (var group in groupsFuture) {
          groups.add(await group);
        }
        state = state.copyFrom(
          newGroups: groups,
          newIsInitialized: true,
          newIsInitializing: false,
          newNoMoreAvailable: res.evoGroups!.groups.length < PokemonServices.readLimit,
        );
      });
    } else {
      await Future.delayed(Duration.zero, () async {
        state = state.copyFrom(
          newIsInitializing: false,
        );
      });
    }
  }

  Future<void> reloadLikes() async {
    await Future.delayed(Duration.zero, () async {
      state = state.copyFrom(
        newIsReloading: true,
      );
    });
    List<Future<HomeStateGroup>> groupsFuture = state.groups.map((x) async {
      List<Future<HomeStateElement>> pokemonsFuture = x.pokemons.map((y) async {
        bool liked = await LikeServices.instance.getLike(groupId: x.groupId, stage: y.stage, form: y.form);
        return y.copyFrom(newLiked: liked);
      }).toList();
      List<HomeStateElement> pokemons = [];
      for (var pokemon in pokemonsFuture) {
        pokemons.add(await pokemon);
      }
      return x.copyFrom(newPokemons: pokemons);
    }).toList();
    List<HomeStateGroup> groups = [];
    for (var group in groupsFuture) {
      groups.add(await group);
    }
    await Future.delayed(Duration.zero, () async {
      state = state.copyFrom(
        newGroups: groups,
        newIsReloading: false,
      );
    });
  }

  Future<void> getMorePokemons() async {
    if (state.isMoreLoading || state.noMoreAvailable) {
      return;
    }
    await Future.delayed(Duration.zero, () async {
      state = state.copyFrom(
        newIsMoreLoading: true,
      );
    });
    PokemonServicesResult res = await PokemonServices.instance.getPokemonEvoGroups(groupAfter: state.groups.last.groupId);
    if (res.isSuccess) {
      await Future.delayed(Duration.zero, () async {
        List<HomeStateGroup> newGroups = [...state.groups];
        List<Future<HomeStateGroup>> groupsFuture = res.evoGroups!.groups.map((x) async {
          List<Future<HomeStateElement>> pokemonsFuture = x.pokemons.map((y) async {
            bool liked = await LikeServices.instance.getLike(groupId: x.groupId, stage: y.stage, form: y.form);
            return HomeStateElement(
              name: y.name,
              type1: y.type1,
              type2: y.type2,
              stage: y.stage,
              form: y.form,
              imgPath: y.imgPath,
              liked: liked,
            );
          }).toList();
          List<HomeStateElement> pokemons = [];
          for (var pokemon in pokemonsFuture) {
            pokemons.add(await pokemon);
          }
          return HomeStateGroup(
            pokemons: pokemons,
            groupId: x.groupId,
          );
        }).toList();
        List<HomeStateGroup> groups = [];
        for (var group in groupsFuture) {
          groups.add(await group);
        }
        newGroups.addAll(groups);
        state = state.copyFrom(
          newGroups: newGroups,
          newIsMoreLoading: false,
          newNoMoreAvailable: res.evoGroups!.groups.length < PokemonServices.readLimit,
        );
      });
    } else {
      await Future.delayed(Duration.zero, () async {
        state = state.copyFrom(
          newIsInitialized: false,
          newIsMoreLoading: false,
        );
      });
    }
  }
}
