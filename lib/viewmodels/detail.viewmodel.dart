import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';
import 'package:pokemon_zukan/repos/like_services.dart';
import 'package:pokemon_zukan/viewmodels/states/detail.state.dart';

final detailProvider = StateNotifierProvider.autoDispose<DetailNotifier, DetailState>((ref) => DetailNotifier());

class DetailNotifier extends StateNotifier<DetailState> {
  DetailNotifier()
      : super(
          const DetailState(
            isSettingLike: false,
            isInitialized: false,
          ),
        );

  Future<bool> isUserLoggedIn() async {
    User? user = (await FirebaseServices.instance.getAuthInstance()).currentUser;
    return user != null;
  }

  Future<void> initialized() async {
    await Future.delayed(Duration.zero, () {
      state = const DetailState(
        isSettingLike: false,
        isInitialized: true,
      );
    });
  }

  Future<void> setLike({required bool toSet, required String groupId, required int stage, required int form}) async {
    await Future.delayed(Duration.zero, () async {
      state = const DetailState(
        isSettingLike: true,
        isInitialized: true,
      );
    });
    await LikeServices.instance.setLike(toSet: toSet, groupId: groupId, stage: stage, form: form);
    await Future.delayed(Duration.zero, () async {
      state = const DetailState(
        isSettingLike: false,
        isInitialized: true,
      );
    });
  }
}
