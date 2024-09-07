import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../app/error/failure.dart';
import '../../../auth/domain/model/base_response_entity.dart';
import '../../presentation/model/input_notification.dart';
import '../../presentation/model/input_typing.dart';
import '../../presentation/model/message_model.dart';

abstract class ChatRepository {
  Future<Either<Failure, BaseResponseEntity>> sendNotification(
      {required NotificationRequest notificationRequest});

  Future<Either<Failure, void>> sendMessage({required MessageModel model});
  Future<Either<Failure, void>> updateTyping({required InputTypingStatus status});

  Future<Either<Failure, DocumentSnapshot>> getUserData(
      {required String userId});

  Future<Either<Failure, String>> uploadImage(File image);

  Future<Either<Failure, List<DocumentSnapshot>>> getAllUsers();

  Future<Either<Failure, List<DocumentSnapshot<Object?>>>> getLastMessage(
      {required String senderId, required List<DocumentSnapshot> users});
}
