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
      "type": "service_account",
      "project_id": "notification-14cad",
      "private_key_id": "fce1ac57f86845c2af96ea0ff7196c48a80f2ce8",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC8xmZWmS/DIaOh\nhr2dm84Tf5uuAWF368USMUdItCLqFj8WEKdHkiYI6fBUVB1DrqtKMhxPCONcNssO\nk+TK3PXLztYNWb/wcF8Lb88CqeJXqAej3ZiAUJfjoJT8coXFnZMyc8cenxLDuTDD\ntrk82sxTVZ0sk4ESS6mosdGIZohHMV+QrHiHlnrPOBfqbRma9dcYIChJzh/4q4Uc\n6tP1RYNL+6KH/Haas3QCLvl886S6qpseE/+tENDw4fFwSAwGDaLiXNGzpi7IVo7v\nFfFYXNuFsTT+taGttzQ+2OmUMeYrSL1QgMkDTFQmJTbn4ZLj7bew3rKuLwBAHEVu\nXc22gZxZAgMBAAECggEAEN+jEiaLMGP3Xl7O4CGnH/MOFVWmQrPeX6vr9UG0xTvL\n08sVSL51i+JtSvxhyUT5pp4oDaB7wihbqifqEYACsH8CfxsAnxtMQ5dw54oL403v\nsOQD16Rcj0oxRwdtkaZuG9pheAk8Aiaxhyz0Dc546RIEBJICvYHp3lxWoFyZ3dMS\nY6UTGh1Lnf5XZMEf1Jv/ofFr/ym/faFKqwKBkT1x2X+WmYNpfnf/T2TQa5TVZ5tU\nIC5oYsZr2lt6lR8IuXmrqDJa7fWyyz13DIdq1lxZmN0LabWotWScrbraTU0ryuSg\nmUOB4xn8Ecfx4wmljSpDErwXGV6RxB8UlklLYqye6QKBgQD4BQvWne6yQzSztE7Z\nExiBSPMn1XMFNLUONAPYCJvQQTaFHi62mtv1VE5m4+Gn4uMaeN2nB+3rrqWuNbNg\nAP0pd1EGnAZ3oW3Sa8o8glm0adAmOHDMEu7Uw1zP2XgAcyUd31l9TS4+1143AVQ3\nVl2CzPVsnodjRuDdYuAsc90EfwKBgQDC2VnkSUFykxg4Saxt52b7hpYPuWob7ctG\nY3nLQLMA9prO4NgxtuIq4y/ar+otPogl2zQMjcPGXzHSGsiCC21rnU01RZHffZm2\nZR8ovZNHvoGD8ojm85zX/pums6ttoFj1zL75nU0N44jfFPuiDQDbb0QtyXxMtV8J\nERbydT+TJwKBgDd+qY9z9xzb/MbY6WuY4jrLX9zh3cKkcH6lFNcZ1gNbFB/lCP7C\n18SlAIX1J2CxW69oq+/bzliV02yPh3tLvVmx4OdhsfDCphgXFkFDyV6c7n4e0t5W\nvinNLM81EazIFt4AQ73NrzNQbTxRh855/KJvydpr/k8wZNAkd5R6uFFxAoGAO3KK\n3X6ILEe6nPnFVObD4bunLvb367t6SGhzMVL1Cjcy9ildbJWKnWEhKYyAWvt4GGyv\njaD2+R/0GFE5mYuY/7tHYhhusAwnCKIDhq+ILtxtsW8e26+5y6CPpqWsiM7iNWQZ\nZBjc+H7SNJW3TDLBbzGcUIfnl5PCgganxKOHGQMCgYBxO6TS7lOyThr1l1aMp+6M\ntSD9E91m0VJSZe3+SblWmR50CTO5NzWPtb0rkGTKCwtdc/kDu9JvN1pfEsy+0sQW\nyBb/TJlUlYpPDhFhpd50JtzR/rvXQ0f5LMRKC1ScTt28CMNLnws8CstlxEbuLeS5\nliHXssmQs47xG23N7cb4NA==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "notification-send@notification-14cad.iam.gserviceaccount.com",
      "client_id": "115400540998366787263",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/notification-send%40notification-14cad.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
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
