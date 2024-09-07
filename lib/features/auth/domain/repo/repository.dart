import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/features/auth/domain/model/base_response_entity.dart';

import '../../../../app/error/failure.dart';

abstract class Repository {
  Future<Either<Failure, BaseResponseEntity>> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginToFirebase(String email, String password);

  Future<Either<Failure, User>> registerToFirebase(
      String email, String password);

  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> updateUserStatus({required bool isOnline});

  Future<Either<Failure, void>> addUserToFirestore(User user, String fullName,
      {required bool isSupporter});

  Future<Either<Failure, DocumentSnapshot>> getUserData(
      {required String userId});
}
