import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pokemon_zukan/repos/firebase_services.dart';

class LikeServices {
  static final LikeServices _instance = LikeServices._();

  static LikeServices get instance => _instance;

  LikeServices._();

  Future<void> setLike({required bool toSet, required String groupId, required int stage, required int form}) async {
    FirebaseFirestore fs = await FirebaseServices.instance.getFirestoreInstance();
    User? user = (await FirebaseServices.instance.getAuthInstance()).currentUser;
    if (user == null) {
      return;
    }
    if (toSet) {
      await fs.collection('users').doc(user.uid).collection('likes').doc('$groupId-$stage-$form').set({
        'group_id': groupId,
        'stage': stage,
        'form': form,
      });
    } else {
      await fs.collection('users').doc(user.uid).collection('likes').doc('$groupId-$stage-$form').delete();
    }
  }

  Future<bool> getLike({required String groupId, required int stage, required int form}) async {
    FirebaseFirestore fs = await FirebaseServices.instance.getFirestoreInstance();
    User? user = (await FirebaseServices.instance.getAuthInstance()).currentUser;
    if (user == null) {
      return false;
    }
    return (await fs.collection('users').doc(user.uid).collection('likes').doc('$groupId-$stage-$form').get()).exists;
  }
}
