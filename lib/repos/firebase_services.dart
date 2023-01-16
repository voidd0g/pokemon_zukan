import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokemon_zukan/firebase_options.dart';

class FirebaseServices {
  static final FirebaseServices _instance = FirebaseServices._();
  static FirebaseServices get instance => _instance;
  final FirebaseAuth _authInstance = FirebaseAuth.instance;
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  bool _isInitialized = false;

  FirebaseServices._();

  Future<FirebaseAuth> getAuthInstance() async {
    if (!_isInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
    }
    return _authInstance;
  }

  Future<FirebaseFirestore> getFirestoreInstance() async {
    if (!_isInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;
    }
    return _firestoreInstance;
  }
}
