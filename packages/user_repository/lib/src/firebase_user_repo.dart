import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'package:user_repository/src/user_repository.dart';

import 'user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _fireBaseAuth;
  final userColletion = FirebaseFirestore.instance.collection("users");
  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _fireBaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<void> logout() async {
    await _fireBaseAuth.signOut();
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await userColletion
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _fireBaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _fireBaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);
      myUser.userId = user.user!.uid;
      return myUser;
    } catch (e) {
      log(e.toString() as num);
      rethrow;
    }
  }

  @override
  Stream<MyUser?> get user {
    return _fireBaseAuth.authStateChanges().flatMap((firebaseUser) async* {
      if (firebaseUser == null) {
        yield MyUser.empty;
      } else {
        yield await userColletion.doc(firebaseUser.uid).get().then((value) =>
            MyUser.fromEntity(MyuserEntity.fromDocument(value.data()!)));
      }
    });
  }
}
