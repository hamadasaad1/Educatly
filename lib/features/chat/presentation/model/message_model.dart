import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String message;
  final String senderId;
  final String senderName;

  final String receiverId;
  final String receiverName;
  final String? imageUrl;
  final Timestamp time;

  MessageModel({
    required this.message,
    required this.senderId,
    required this.receiverId,
    required this.receiverName,
    required this.senderName,
    this.imageUrl,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'message': message,
      'senderId': senderId,
      'senderName': senderName,
      'receiverName': receiverName,
      'imageUrl': imageUrl,
      'receiverId': receiverId,
      'time': time,
    };
  }

  MessageModel copyWith({
    String? message,
    String? senderId,
    String? senderName,
    String? receiverId,
    String? receiverName,
    String? imageUrl,
    Timestamp? time,
  }) {
    return MessageModel(
      message: message ?? this.message,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      imageUrl: imageUrl,
      time: time ?? this.time,
    );
  }
}
