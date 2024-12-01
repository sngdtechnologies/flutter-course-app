// ignore_for_file: unnecessary_null_comparison, unused_import, unused_field

import 'package:firebase_auth/firebase_auth.dart';
import 'package:premiere/models/user.dart';
import 'package:premiere/services/database.dart';

// import 'notification_service.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AppUser? _userFromFirebaseUser(User? user) {
    initUser(user!);
    return user != null ? AppUser(user.uid) : null;
  }

  void initUser(User user) async {
    if (user == null) return;
    // NotificationService.getToken().then((value) {
    //   DatabaseService(user.uid).saveToken(value);
    // });
  }

  Stream<AppUser?>? get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // l'état de l'utilisateur en temps réel
  // Stream<AppUser> get user {
  //   _userFromFirebaseUser(_user);
  //   return _userFromFirebaseUser(_user);
  // }


  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result =
          await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return _userFromFirebaseUser(user);
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }

  // Future registerWithEmailAndPassword(String name, String email, String password) async {
  //   try {
  //     UserCredential result =
  //         await _auth.createUserWithEmailAndPassword(email: email, password: password);
  //     User user = result.user;
  //     if (user == null) {
  //       throw Exception("No user found");
  //     } else {
  //       await DatabaseService(user.uid).saveUser(name, 0);

  //       return _userFromFirebaseUser(user);
  //     }
  //   } catch (exception) {
  //     print(exception.toString());
  //     return null;
  //   }
  // }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (exception) {
      print(exception.toString());
      return null;
    }
  }
}
