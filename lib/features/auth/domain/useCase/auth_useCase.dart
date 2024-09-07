import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../app/error/failure.dart';
import '../../../../app/usecase/base_usecase.dart';
import '../../presentation/model/input_login_model.dart';
import '../../presentation/model/input_register_model.dart';
import '../../presentation/model/input_store_user_model.dart';
import '../repo/repository.dart';

class LoginUseCase implements BaseUseCase<LoginInputModel, User> {
  final Repository _repository;

  LoginUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, User>> execute(LoginInputModel input) async {
    return await _repository.loginToFirebase(input.email, input.password);
  }
}

class RegisterUseCase implements BaseUseCase<InputRegisterModel, User> {
  final Repository _repository;

  RegisterUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, User>> execute(InputRegisterModel input) async {
    return await _repository.registerToFirebase(input.email, input.password);
  }
}

class LogoutUseCase implements BaseUseCase<void, void> {
  final Repository _repository;

  LogoutUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, void>> execute(Void) async {
    return await _repository.logout();
  }
}

class StoreUserUseCase implements BaseUseCase<InputStoreUserModel, void> {
  final Repository _repository;

  StoreUserUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, void>> execute(InputStoreUserModel model) async {
    return await _repository.addUserToFirestore(model.user, model.fullName,
        isSupporter: model.isSupporter);
  }
}

class AuthGetUserUseCase
    implements BaseUseCase<String, DocumentSnapshot<Object?>> {
  final Repository _repository;

  AuthGetUserUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, DocumentSnapshot<Object?>>> execute(
      String userId) async {
    return await _repository.getUserData(userId: userId);
  }
}

class UpdateUserStatusUseCase implements BaseUseCase<bool, void> {
  final Repository _repository;

  UpdateUserStatusUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, void>> execute(bool isOnline) async {
    return await _repository.updateUserStatus(isOnline: isOnline);
  }
}
