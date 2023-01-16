import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:pokemon_zukan/models/pokemon.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';

class PokemonServices {
  static final PokemonServices _instance = PokemonServices._();
  static PokemonServices get instance => _instance;
  PokemonServicesResult? _result;

  PokemonServices._();

  Future<PokemonServicesResult> getPokemonEvoGroups({bool force = false}) async {
    if (force || _result == null) {
      try {
        List<PokemonEvoGroup> groups = [];
        FirebaseFirestore fs = await FirebaseServices.instance.getFirestoreInstance();
        QuerySnapshot<Map<String, dynamic>> groupsRaw = await fs.collection('groups').get();
        List<QueryDocumentSnapshot<Map<String, dynamic>>> documentsRaw = groupsRaw.docs;
        for (var doc in documentsRaw) {
          List<Pokemon> pokemons = [];
          QuerySnapshot<Map<String, dynamic>> pokemonsRaw = await doc.reference.collection('pokemons').get();
          List<QueryDocumentSnapshot<Map<String, dynamic>>> pokDocsRaw = pokemonsRaw.docs;
          for (var pokDoc in pokDocsRaw) {
            pokemons.add(
              Pokemon(
                name: pokDoc.get('name'),
                type1: pokemonTypeFromString(pokDoc.get('type1')),
                type2: pokDoc.get('type2') == null ? null : pokemonTypeFromString(pokDoc.get('type2')),
                stage: pokDoc.get('stage'),
                form: pokDoc.get('form'),
              ),
            );
          }
          pokemons.sort((l, r) => l.stage != r.stage ? l.stage - r.stage : l.form - r.form);
          groups.add(
            PokemonEvoGroup(
              pokemons: pokemons,
              groupID: doc.get('id'),
            ),
          );
        }
        _result = PokemonServicesResult(
          isSuccess: true,
          evoGroups: EvoGroups(
            groups: groups,
          ),
        );
      } catch (e) {
        _result = PokemonServicesResult(
          isSuccess: false,
          failMessage: e.toString(),
        );
        if (kDebugMode) {
          print(e);
        }
      }
    }
    return _result!;
  }
}

class PokemonServicesResult {
  final bool isSuccess;
  final String? failMessage;
  final EvoGroups? evoGroups;

  const PokemonServicesResult({required this.isSuccess, this.failMessage, this.evoGroups});
}
