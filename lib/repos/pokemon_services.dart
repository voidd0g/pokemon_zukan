import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemon_zukan/models/pokemon.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';

class PokemonServices {
  static final PokemonServices _instance = PokemonServices._();

  static const int readLimit = 2;

  static PokemonServices get instance => _instance;

  PokemonServices._();

  Future<PokemonServicesResult> getPokemonEvoGroups({String? groupAfter}) async {
    PokemonServicesResult result;
    try {
      List<PokemonEvoGroup> groups = [];
      FirebaseFirestore fs = await FirebaseServices.instance.getFirestoreInstance();
      var query = fs.collection('groups').limit(readLimit);
      if (groupAfter != null) {
        query = query.startAfterDocument(await fs.collection('groups').doc(groupAfter).get());
      }
      QuerySnapshot<Map<String, dynamic>> groupsRaw = await query.get();
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
              imgPath: pokDoc.get('img_path'),
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
      result = PokemonServicesResult(
        isSuccess: true,
        evoGroups: EvoGroups(
          groups: groups,
        ),
      );
    } catch (e) {
      result = PokemonServicesResult(
        isSuccess: false,
        failMessage: e.toString(),
      );
    }
    return result;
  }
}

class PokemonServicesResult {
  final bool isSuccess;
  final String? failMessage;
  final EvoGroups? evoGroups;

  const PokemonServicesResult({required this.isSuccess, this.failMessage, this.evoGroups});
}
