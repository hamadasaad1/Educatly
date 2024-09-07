import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../../app/error/failure.dart';
import '../../../../app/singlton.dart';
import '../../../../app/usecase/base_usecase.dart';
import '../../../auth/domain/model/base_response_entity.dart';
import '../../presentation/model/input_notification.dart';
import '../../presentation/model/input_typing.dart';
import '../../presentation/model/message_model.dart';
import '../repositories/repository.dart';

class ChatSendNotificationUseCase
    implements BaseUseCase<NotificationRequest, BaseResponseEntity> {
  final ChatRepository _repository;

  ChatSendNotificationUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, BaseResponseEntity>> execute(
      NotificationRequest notificationRequest) async {
    return await _repository.sendNotification(
        notificationRequest: notificationRequest);
  }
}

class ChatMessageUseCase implements BaseUseCase<MessageModel, void> {
  final ChatRepository _repository;

  ChatMessageUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, void>> execute(MessageModel model) async {
    return await _repository.sendMessage(model: model);
  }
}

class ChatGetUserUseCase implements BaseUseCase<String, DocumentSnapshot> {
  final ChatRepository _repository;

  ChatGetUserUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, DocumentSnapshot>> execute(String id) async {
    return await _repository.getUserData(userId: id);
  }
}

class ChatUploadFileUseCase implements BaseUseCase<File, String> {
  final ChatRepository _repository;

  ChatUploadFileUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, String>> execute(File file) async {
    return await _repository.uploadImage(file);
  }
}

class ChatGetAllUsersUseCase
    implements BaseUseCase<void, List<DocumentSnapshot>> {
  final ChatRepository _repository;

  ChatGetAllUsersUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, List<DocumentSnapshot>>> execute(Void) async {
    return await _repository.getAllUsers();
  }
}

class ChatGetLastMessagesUseCase
    implements
        BaseUseCase<List<DocumentSnapshot<Object?>>,
            List<DocumentSnapshot<Object?>>> {
  final ChatRepository _repository;

  ChatGetLastMessagesUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, List<DocumentSnapshot>>> execute(
      List<DocumentSnapshot<Object?>> user) async {
    return await _repository.getLastMessage(
        senderId: Singleton().userModel!.uid.toString(), users: user);
  }
}


class ChatUpdateTypingUseCase implements BaseUseCase<InputTypingStatus, void> {
  final ChatRepository _repository;

  ChatUpdateTypingUseCase(
    this._repository,
  );

  @override
  Future<Either<Failure, void>> execute(InputTypingStatus model) async {
    return await _repository.updateTyping(status: model);
  }
}

