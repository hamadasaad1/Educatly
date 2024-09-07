import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Singleton {
  static final Singleton _singleton = Singleton._internal();

  Singleton._privateConstructor();

  static final Singleton _instance = Singleton._privateConstructor();

  static Singleton get instance => _instance;

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();

  User? userModel;
  DocumentSnapshot<Object?>? userData;
  String fcmToken = '';

  bool getDeviceTabletMobile() {
    // final data = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    return false;

    // data.size.shortestSide >= 600;
  }
}
