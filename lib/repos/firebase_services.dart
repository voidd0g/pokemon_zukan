import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pokemon_zukan/firebase_options.dart';

class FirebaseServices {
  static final FirebaseServices _instance = FirebaseServices._();
  static FirebaseServices get instance => _instance;
  FirebaseAuth? _authInstance;
  FirebaseFirestore? _firestoreInstance;
  bool _isInitialized = false;

  FirebaseServices._();

  Future<FirebaseAuth> getAuthInstance() async {
    if (!_isInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _authInstance = FirebaseAuth.instance;
      _firestoreInstance = FirebaseFirestore.instance;
      _isInitialized = true;
    }
    return _authInstance!;
  }

  Future<FirebaseFirestore> getFirestoreInstance() async {
    if (!_isInitialized) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _authInstance = FirebaseAuth.instance;
      _firestoreInstance = FirebaseFirestore.instance;
      _isInitialized = true;
    }
    return _firestoreInstance!;
  }

  Future<void> signOutWithGoogle() async {
    if (!kIsWeb) {
      await GoogleSignIn().signOut();
    }
    await (await getAuthInstance()).signOut();
  }

  Future<bool> trySignInWithGoogle() async {
    if (!kIsWeb) {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        try {
          final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

          final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken,
          );

          await (await getAuthInstance()).signInWithCredential(credential);
          if ((await getAuthInstance()).currentUser != null) {
            return true;
          } else {
            return false;
          }
        } catch (e) {
          if (kDebugMode) {
            print(e);
          }
          return false;
        }
      } else {
        return false;
      }
    } else {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        await (await getAuthInstance()).signInWithPopup(authProvider);
        if ((await getAuthInstance()).currentUser != null) {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return false;
      }
    }
  }
}
