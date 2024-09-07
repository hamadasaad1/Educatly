import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/app/singlton.dart';

import '../../../../app/constants.dart';
import '../../../../app/network/api_app.dart';
import '../responses/base_response.dart';

abstract class AuthRemoteDataSource {
  Future<BaseResponse> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User?> loginToFirebase(String email, String password);

  Future<User?> registerToFirebase(String email, String password);

  Future<void> logout();
  Future<void> updateUserStatus({required bool isOnline});

  Future<void> addUserToFirestore(User user, String fullName,
      {required bool isSupporter});

  Future<DocumentSnapshot?> getUserData({required String userId});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AppServiceClient _serviceClient;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(
    this._serviceClient,
    this._firebaseAuth,
    this._firestore,
  );

  @override
  Future<BaseResponse> loginWithEmailAndPassword(
      {required String email, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> addUserToFirestore(User user, String fullName,
      {required bool isSupporter}) async {
    await _firestore.collection(Constants.usersKey).doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'fullName': fullName,
      'isSupporter': isSupporter,
      'token': Singleton().fcmToken,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<User?> loginToFirebase(String email, String password) async {
    return await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) => value.user);
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<User?> registerToFirebase(String email, String password) async {
    return await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => value.user);
  }

  @override
  Future<DocumentSnapshot<Object?>?> getUserData(
      {required String userId}) async {
    return await _firestore.collection(Constants.usersKey).doc(userId).get();
  }

  @override
  Future<void> updateUserStatus({required bool isOnline}) async {
    await _firestore
        .collection(Constants.usersKey)
        .doc(Singleton().userModel?.uid)
        .update({'isOnline': isOnline});
  }
}
