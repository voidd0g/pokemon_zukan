import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pokemon_zukan/models/pokemon.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/utils/pokemon_type_string.dart';

class PokemonServices {
  static final PokemonServices _instance = PokemonServices._();

  static const int readLimit = 3;

  static PokemonServices get instance => _instance;

  PokemonServices._();

  List<PokemonEvoGroup> groupsCache = [];

  Future<List<PokemonEvoGroup>> _getGroups({String? groupAfter, required int count}) async {
    List<PokemonEvoGroup> groups = [];
    FirebaseFirestore fs = await FirebaseServices.instance.getFirestoreInstance();
    var query = fs.collection('groups').limit(count);
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
            type1: pokemonTypeFromString(type: pokDoc.get('type1')),
            type2: pokDoc.get('type2') == null ? null : pokemonTypeFromString(type: pokDoc.get('type2')),
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
          groupId: doc.get('id'),
        ),
      );
    }
    return groups;
  }

  Future<PokemonServicesResult> getPokemonEvoGroups({String? groupAfter}) async {
    PokemonServicesResult result;

    try {
      if (groupAfter == null) {
        if (readLimit <= groupsCache.length) {
          result = PokemonServicesResult(
            isSuccess: true,
            evoGroups: EvoGroups(
              groups: groupsCache.take(readLimit).toList(),
            ),
          );
        } else if (groupsCache.isEmpty) {
          List<PokemonEvoGroup> groups = await _getGroups(groupAfter: null, count: readLimit);
          groupsCache.addAll(groups);

          result = PokemonServicesResult(
            isSuccess: true,
            evoGroups: EvoGroups(
              groups: groupsCache.take(readLimit).toList(),
            ),
          );
        } else {
          String lastId = groupsCache.last.groupId;
          List<PokemonEvoGroup> groups = await _getGroups(groupAfter: lastId, count: readLimit - groupsCache.length);

          groupsCache.addAll(groups);

          result = PokemonServicesResult(
            isSuccess: true,
            evoGroups: EvoGroups(
              groups: groupsCache.take(readLimit).toList(),
            ),
          );
        }
      } else {
        Iterable<MapEntry<int, PokemonEvoGroup>> hit = groupsCache.asMap().entries.where((entry) => entry.value.groupId == groupAfter);
        if (hit.isNotEmpty) {
          if (hit.first.key + 1 + readLimit <= groupsCache.length) {
            result = PokemonServicesResult(
              isSuccess: true,
              evoGroups: EvoGroups(
                groups: groupsCache.skip(hit.first.key + 1).take(readLimit).toList(),
              ),
            );
          } else {
            String lastId = groupsCache.last.groupId;
            List<PokemonEvoGroup> groups = await _getGroups(groupAfter: lastId, count: readLimit + hit.first.key + 1 - groupsCache.length);

            groupsCache.addAll(groups);

            result = PokemonServicesResult(
              isSuccess: true,
              evoGroups: EvoGroups(
                groups: groupsCache.skip(hit.first.key + 1).take(readLimit).toList(),
              ),
            );
          }
        } else {
          List<PokemonEvoGroup> groups = await _getGroups(groupAfter: groupAfter, count: readLimit);

          result = PokemonServicesResult(
            isSuccess: true,
            evoGroups: EvoGroups(
              groups: groups,
            ),
          );
        }
      }
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
