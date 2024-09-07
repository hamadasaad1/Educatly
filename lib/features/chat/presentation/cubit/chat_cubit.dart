import 'dart:async';
import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../app/constants.dart';
import '../../../../app/error/failure.dart';
import '../../../../app/service_locator.dart';
import '../../../../app/singlton.dart';
import '../../../auth/domain/useCase/auth_useCase.dart';
import '../../domain/usecases/chat_usecase.dart';
import '../model/input_notification.dart';
import '../model/input_typing.dart';
import '../model/message_model.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  String senderId = Singleton().userModel!.uid.toString();
  final ChatSendNotificationUseCase _notificationUseCase =
      locator<ChatSendNotificationUseCase>();

  final ChatMessageUseCase _messageUseCase = locator<ChatMessageUseCase>();
  final ChatUploadFileUseCase _uploadFileUseCase =
      locator<ChatUploadFileUseCase>();

  final ChatGetAllUsersUseCase _getAllUsersUseCase =
      locator<ChatGetAllUsersUseCase>();
  final ChatGetLastMessagesUseCase _lastMessageUseCase =
      locator<ChatGetLastMessagesUseCase>();

  final UpdateUserStatusUseCase _statusUseCase =
      locator<UpdateUserStatusUseCase>();
  final ChatUpdateTypingUseCase _typingUseCase =
      locator<ChatUpdateTypingUseCase>();

  void sendMessage({required MessageModel model}) async {
    emit(ChatLoadingState());
    (await _messageUseCase.execute(model)).fold((failure) {
      return {
        emit(ChatErrorState(failure: failure)),
      };
    }, (data) {
      emit(ChatSuccessState());
      sendNotification(
          title: 'New Message ${Singleton().userData?.get('fullName') ?? ''}',
          body: model.message,
          receiverId: model.receiverId,
          userId: model.senderId);
    });
  }

  void uploadFile({required File file, required MessageModel model}) async {
    emit(ChatLoadingState());
    (await _uploadFileUseCase.execute(file)).fold((failure) {
      return {
        emit(ChatErrorState(failure: failure)),
      };
    }, (data) {
      debugPrint(data);
      emit(ChatUploadFileSuccessState(url: data));
      sendMessage(model: model.copyWith(imageUrl: data));
    });
  }

  Future<List<DocumentSnapshot>> _getAllUsers() async {
    List<DocumentSnapshot> users = [];
    (await _getAllUsersUseCase.execute(Void)).fold((failure) {
      users = [];
    }, (data) {
      users = data;
    });

    return users;
  }

  void getAllUsers() async {
    emit(ChatAllUsersLoading());
    (await _getAllUsersUseCase.execute(Void)).fold((failure) {
      return {
        emit(ChatAllUsersError(failure: failure)),
      };
    }, (data) {
      emit(ChatAllUsersLoaded(users: data));
    });
  }

  void getLastMessage() async {
    emit(ChatLastMessageLoading());
    (await _lastMessageUseCase.execute(await _getAllUsers())).fold((failure) {
      return {
        emit(ChatLastMessageError(failure: failure)),
      };
    }, (data) {
      emit(ChatLastMessageLoaded(messages: data));
    });
  }

  Stream<QuerySnapshot> getMessages({required String receiverId}) {
    List<String> ids = [senderId, receiverId];
    ids.sort();
    String chatId = ids.join('_');
    return locator<FirebaseFirestore>()
        .collection(Constants.chatRoomKey)
        .doc(chatId)
        .collection(Constants.messagesKey)
        .orderBy('time', descending: false)
        .snapshots();
  }

  void updateUserStatus({required bool isOnline}) async {
    (await _statusUseCase.execute(isOnline)).fold((failure) {
      return {
        debugPrint(failure.message),
      };
    }, (data) {
      debugPrint('data Status Changed');
    });
  }

  void updateTyping(
      {required bool isTyping, required String receiverId}) async {
    (await _typingUseCase.execute(InputTypingStatus(
            senderId: Singleton().userModel?.uid ?? '',
            receiverId: receiverId,
            isTyping: isTyping)))
        .fold((failure) {
      return {
        debugPrint(failure.message),
      };
    }, (data) {
      debugPrint('data Typing Changed');
    });
  }

  Stream<String?> getTypingStatus({
    required String receiverId,
  }) {
    List<String> ids = [Singleton().userModel?.uid ?? '', receiverId];
    ids.sort();
    String chatId = ids.join('_');
    return locator<FirebaseFirestore>()
        .collection(Constants.typingKey)
        .doc(chatId)
        .snapshots()
        .map((snapshot) {
      return snapshot.data()?['typing'] as String?;
    });
  }

  Stream<DocumentSnapshot<Object?>> getUserData({required String userId}) {
    return locator<FirebaseFirestore>()
        .collection(Constants.usersKey)
        .doc(userId)
        .snapshots();
  }

  void sendNotification({
    required String title,
    required String body,
    required String receiverId,
    required String userId,
    String? senderId,
  }) async {
    var receiverUser = await getUser(userId: receiverId);
    if (receiverUser == null) return;
    String token = receiverUser.get('token');
    emit(ChatSendNotificationLoading());

    (await _notificationUseCase.execute(
      NotificationRequest(
        notification:
            NotificationInput(body: body, title: title, senderId: senderId),
        toToken: token,
      ),
    ))
        .fold((failure) {
      return {
        emit(ChatSendNotificationError(failure: failure)),
      };
    }, (data) async {
      emit(ChatSendNotificationSuccess());
    });
  }

  Future<DocumentSnapshot?> getUser({required String userId}) async {
    var result = await locator<FirebaseFirestore>()
        .collection(Constants.usersKey)
        .doc(userId)
        .get();
    return result;
  }
}
