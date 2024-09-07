import 'dart:ffi';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:template/features/chat/presentation/model/input_typing.dart';
import 'package:template/features/chat/presentation/model/message_model.dart';

import '../../../../app/error/error_handler.dart';
import '../../../../app/error/failure.dart';
import '../../../../app/network/network_info.dart';
import '../../../auth/data/mapper/mapper_base.dart';
import '../../../auth/domain/model/base_response_entity.dart';
import '../../domain/repositories/repository.dart';
import '../../presentation/model/input_notification.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  final NetworkInfo _networkInfo;

  ChatRepositoryImpl(
    this._remoteDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, BaseResponseEntity>> sendNotification(
      {required NotificationRequest notificationRequest}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.sendNotification(
            notificationRequest: notificationRequest);

        return Right(response.toDomain());
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
        final response = await _remoteDataSource.getUserData(userId: userId);
        return Right(response);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(
      {required MessageModel model}) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.sendMessage(model: model);
        return const Right(Void);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    if (await _networkInfo.isConnected) {
      try {
        final imageUrl = await _remoteDataSource.uploadImage(image);
        return Right(imageUrl);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<DocumentSnapshot<Object?>>>> getAllUsers() async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getAllUsers();
        return Right(response);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, List<DocumentSnapshot<Object?>>>> getLastMessage(
      {required String senderId,
      required List<DocumentSnapshot<Object?>> users}) async {
    if (await _networkInfo.isConnected) {
      try {
        final response = await _remoteDataSource.getLastMessage(
            senderId: senderId, users: users);
        return Right(response);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }

  @override
  Future<Either<Failure, void>> updateTyping({required InputTypingStatus status}) async{
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.updateTyping(status: status);
        return const Right(Void);
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
  }
}
