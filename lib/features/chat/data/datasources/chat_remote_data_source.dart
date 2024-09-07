import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import '../../../../app/constants.dart';
import '../../../../app/network/api_app.dart';
import '../../../auth/data/responses/base_response.dart';
import '../../presentation/model/input_notification.dart';
import '../../presentation/model/input_typing.dart';
import '../../presentation/model/message_model.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;
import 'package:http/http.dart' as http;

abstract class ChatRemoteDataSource {
  Future<BaseResponse> sendNotification(
      {required NotificationRequest notificationRequest});

  Future<void> sendMessage({required MessageModel model});

  Future<DocumentSnapshot> getUserData({required String userId});

  Future<String> uploadImage(File image);

  Future<List<DocumentSnapshot>> getAllUsers();

  Future<List<DocumentSnapshot<Object?>>> getLastMessage(
      {required String senderId, required List<DocumentSnapshot> users});

  Future<void> updateTyping({required InputTypingStatus status});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final AppServiceClient _serviceClient;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  ChatRemoteDataSourceImpl(
    this._serviceClient,
    this._firestore,
    this._firebaseStorage,
  );

  @override
  Future<BaseResponse> sendNotification(
      {required NotificationRequest notificationRequest}) async {
    try {
      debugPrint('Send notification to ${notificationRequest.toJson()}');
      String accessKey = await getAssesToken();
      final response = await Dio().post(
        'https://fcm.googleapis.com/v1/projects/notification-14cad/messages:send',
        data: notificationRequest.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessKey',
            'content-type': 'application/json',
          },
        ),
      );

      // Parse the response into your BaseResponse class
      return BaseResponse.fromJson(response.data);
    } catch (error) {
      // Handle error
      debugPrint('error: $error');
      throw error;
    }
  }

  Future<String> getAssesToken() async {
    final acceToken = {
     
    };

    List<String> scope = [
      
      'https://www.googleapis.com/auth/firebase.messaging'
          'https://www.googleapis.com/auth/userinfo.email'
          'https://www.googleapis.com/auth/firebase.database'
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(acceToken), scope);

    auth.AccessCredentials accessCredentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(acceToken), scope, client);

    client.close();

    return accessCredentials.accessToken.data;
  }

  @override
  Future<void> sendMessage({required MessageModel model}) async {
    List<String> ids = [model.senderId, model.receiverId];
    ids.sort();
    String chatId = ids.join('_');
    await _firestore
        .collection(Constants.chatRoomKey)
        .doc(chatId)
        .collection(Constants.messagesKey)
        .add(model.toMap());
  }

  @override
  Future<DocumentSnapshot<Object?>> getUserData(
      {required String userId}) async {
    return await _firestore.collection(Constants.usersKey).doc(userId).get();
  }

  @override
  Future<String> uploadImage(File image) async {
    return await _firebaseStorage
        .ref()
        .child(image.path)
        .putFile(image)
        .then((value) => value.ref.getDownloadURL());
  }

  Future<List<DocumentSnapshot>> getAllChatRooms() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(Constants.usersKey).get();

    return querySnapshot.docs;
  }

  @override
  Future<List<DocumentSnapshot<Object?>>> getAllUsers() async {
    final querySnapshot = await _firestore.collection(Constants.usersKey).get();

    return querySnapshot.docs;
  }

  @override
  Future<List<DocumentSnapshot<Object?>>> getLastMessage(
      {required String senderId, required List<DocumentSnapshot> users}) async {
    List<DocumentSnapshot> lastMessages = [];

    for (DocumentSnapshot user in users) {
      List<String> ids = [senderId, user.id];
      ids.sort();
      String chatId = ids.join('_');
      await _firestore
          .collection(Constants.chatRoomKey)
          .doc(chatId)
          .collection(Constants.messagesKey)
          .orderBy('time', descending: true)
          .limit(1)
          .get()
          .then((value) {
        if (value.docChanges.isNotEmpty) {
          lastMessages.add(value.docs.first);
        }
      });
    }

    return lastMessages;
  }

  @override
  Future<void> updateTyping({required InputTypingStatus status}) async {
    List<String> ids = [status.senderId, status.receiverId];
    ids.sort();
    String chatId = ids.join('_');
    DocumentReference chatDocRef =
        _firestore.collection(Constants.typingKey).doc(chatId);

    DocumentSnapshot chatSnapshot = await chatDocRef.get();

    if (!chatSnapshot.exists) {
      await chatDocRef.set({
        'typing': null,
      });
    }

    await chatDocRef.update({
      'typing': status.isTyping ? status.senderId : null,
    });
  }
}
