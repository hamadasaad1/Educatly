import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:template/features/auth/data/remote_source/auth_remote_data_source.dart';
import 'package:template/features/auth/domain/model/base_response_entity.dart';

import '../../../../app/error/error_handler.dart';
import '../../../../app/error/failure.dart';
import '../../../../app/network/network_info.dart';
import '../../domain/repo/repository.dart';

class AuthRepositoryImpl implements Repository {
  final AuthRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl(
    this._networkInfo,
    this._remoteDataSource,
  );

  @override
  Future<Either<Failure, BaseResponseEntity>> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    if (await _networkInfo.isConnected) {
      try {
        // final response = await _authRemoteDataSource.loginWithEmailAndPassword(email: email, password: password);
        // return Right(response.toDomain());
        return Left(Failure(code: 0, message: 'message'));
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> addUserToFirestore(User user, String fullName,
      {required bool isSupporter}) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.addUserToFirestore(user, fullName,
            isSupporter: isSupporter);
        return const Right(Void);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, User>> loginToFirebase(
      String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.loginToFirebase(email, password);
        if (user == null)
          return Left(Failure(code: 0, message: 'User Not Found'));
        return Right(user);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.logout();
        return const Right(Void);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, User>> registerToFirebase(
      String email, String password) async {
    if (await _networkInfo.isConnected) {
      try {
        final user =
            await _remoteDataSource.registerToFirebase(email, password);
        if (user == null) {
          return Left(Failure(code: 0, message: 'Cannot Create User'));
        }
        return Right(user);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, DocumentSnapshot<Object?>>> getUserData(
      {required String userId}) async {
    if (await _networkInfo.isConnected) {
      try {
        final user = await _remoteDataSource.getUserData(userId: userId);
        if (user == null) {
          return Left(Failure(code: 0, message: 'User Not Found'));
        }
        return Right(user);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
  
  @override
  Future<Either<Failure, void>> updateUserStatus({required bool isOnline}) async{
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.updateUserStatus(isOnline: isOnline);
        return const Right(Void);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
