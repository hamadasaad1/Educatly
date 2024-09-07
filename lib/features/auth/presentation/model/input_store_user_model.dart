import 'package:firebase_auth/firebase_auth.dart';

class InputStoreUserModel {
  User user;
  String fullName;
  bool isSupporter;

  InputStoreUserModel({
    required this.user,
    required this.fullName,
    required this.isSupporter,
  });
}
